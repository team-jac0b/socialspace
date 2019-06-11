from __future__ import division

import cv2

import face_recognition

import paho.mqtt.client as mqtt

import time;

# =============== START IMAGE CAPTURE PART =============== #
def cameraCapture():
    #
    # Camera 0 is the integrated web cam on my netbook
    # Camera 1 is the connected webcam
    camera_port = 0

    # Number of frames to throw away while the camera adjusts to light levels
    ramp_frames = 10

    # Now we can initialize the camera capture object with the cv2.VideoCapture class.
    # All it needs is the index to a camera port.
    camera = cv2.VideoCapture(camera_port)


    # Captures a single image from the camera and returns it in PIL format
    def get_image():
        # read is the easiest way to get a full image out of a VideoCapture object.
        retval, im = camera.read()
        return im


    # Ramp the camera - these frames will be discarded and are only used to allow v4l2
    # to adjust light levels, if necessary
    for i in range(ramp_frames):
        temp = get_image()
    print("Taking image...")
    # Take the actual image we want to keep
    camera_capture = get_image()
    file = "people.png"
    # A nice feature of the imwrite method is that it will automatically choose the
    # correct format based on the file extension you provide. Convenient!
    cv2.imwrite(file, camera_capture)

    # You'll want to release the camera, otherwise you won't be able to create a new
    # capture object until your script exits
    del camera

# =============== BEGIN FACIAL RECOGNITION PART =============== #
#
def faceRecog(clientMQTT):
    # Load the jpg file into a numpy array
    image = face_recognition.load_image_file("people.png")

    # Find all the faces in the image using the default HOG-based model.
    # This method is fairly accurate, but not as accurate as the CNN model and not GPU accelerated.
    # See also: find_faces_in_picture_cnn.py
    face_locations = face_recognition.face_locations(image)

    print("Number of faces: ")
    print("{}".format(len(face_locations)))
    clientMQTT.publish("uwsocialspacenumsAllen", len(face_locations), qos=2)

def main():

    # =============== MQTT STUFF STARTS HERE =============== #
    #
    # The callback for when the client receives a CONNACK response from the server.
    def on_connect(client, userdata, flags, rc):
        print("Connected with result code " + str(rc))

        # Subscribing in on_connect() means that if we lose the connection and
        # reconnect then subscriptions will be renewed.

    # The callback for when a PUBLISH message is received from the server.
    def on_message(client, userdata, msg):
        print(msg.topic + " " + str(msg.payload))

    clientMQTT = mqtt.Client()
    clientMQTT.on_connect = on_connect
    clientMQTT.username_pw_set("c4cc8af9", "959dcc8e063b9572")
    clientMQTT.connect_async("broker.shiftr.io", 1883, 60)
    clientMQTT.loop_start()

    # Continuously capture an image from the webcam and then sleep for 5 seconds before repeating
    while True:
        cameraCapture()
        faceRecog(clientMQTT)
        time.sleep(5)


if __name__ == '__main__':
    main()
