import cv2

import face_recognition

import spacy

import paho.mqtt.client as mqtt

import pyaudio
import wave

import io
import os

# Imports the Google Cloud client library
from google.cloud import speech
from google.cloud.speech import enums
from google.cloud.speech import types

os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="/Users/studentuser/Documents/Team-Jacob-044ef9a1def9.json"

loop = True

# while loop:
# =============== START IMAGE CAPTURE PART =============== #
#
# # Camera 0 is the integrated web cam on my netbook
# # Camera 1 is the connected webcam
# camera_port = 0
#
# # Number of frames to throw away while the camera adjusts to light levels
# ramp_frames = 10
#
# # Now we can initialize the camera capture object with the cv2.VideoCapture class.
# # All it needs is the index to a camera port.
# camera = cv2.VideoCapture(camera_port)
#
#
# # Captures a single image from the camera and returns it in PIL format
# def get_image():
#     # read is the easiest way to get a full image out of a VideoCapture object.
#     retval, im = camera.read()
#     return im
#
#
# # Ramp the camera - these frames will be discarded and are only used to allow v4l2
# # to adjust light levels, if necessary
# for i in range(ramp_frames):
#     temp = get_image()
# print("Taking image...")
# # Take the actual image we want to keep
# camera_capture = get_image()
# file = "people.png"
# # A nice feature of the imwrite method is that it will automatically choose the
# # correct format based on the file extension you provide. Convenient!
# cv2.imwrite(file, camera_capture)
#
# # You'll want to release the camera, otherwise you won't be able to create a new
# # capture object until your script exits
# del camera

# =============== START AUDIO CAPTURE PART =============== #

# CHUNK = 1024
# FORMAT = pyaudio.paInt16
# CHANNELS = 2
# RATE = 44100
# RECORD_SECONDS = 10
# WAVE_OUTPUT_FILENAME = "output.wav"
#
# p = pyaudio.PyAudio()
#
# stream = p.open(format=FORMAT,
#                 channels=CHANNELS,
#                 rate=RATE,
#                 input=True,
#                 frames_per_buffer=CHUNK)
#
# print("* recording")
#
# frames = []
#
# for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
#     data = stream.read(CHUNK)
#     frames.append(data)
#
# print("* done recording")
#
# stream.stop_stream()
# stream.close()
# p.terminate()
#
# wf = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
# wf.setnchannels(CHANNELS)
# wf.setsampwidth(p.get_sample_size(FORMAT))
# wf.setframerate(RATE)
# wf.writeframes(b''.join(frames))
# wf.close()

# =============== START SPEECH TO TEXT PART =============== #

# # Instantiates a client
# client = speech.SpeechClient()
#
# # The name of the audio file to transcribe
# file_name = os.path.join(
#     os.path.dirname(__file__),
#     'output.wav')
#
# # Loads the audio into memory
# with io.open(file_name, 'rb') as audio_file:
#     content = audio_file.read()
#     audio = types.RecognitionAudio(content=content)
#
# config = types.RecognitionConfig(
#     encoding=enums.RecognitionConfig.AudioEncoding.LINEAR16,
#     sample_rate_hertz=44100,
#     audio_channel_count=2,
#     language_code='en-US')
#
# # Detects speech in the audio file
# response = client.recognize(config, audio)
#
# transcript = "";
#
# for result in response.results:
#     print('Transcript: {}'.format(result.alternatives[0].transcript))
#     transcript += result.alternatives[0].transcript

# =============== BEGIN FACIAL RECOGNITION PART =============== #
#
# # Load the jpg file into a numpy array
# image = face_recognition.load_image_file("people.png")
#
# # Find all the faces in the image using the default HOG-based model.
# # This method is fairly accurate, but not as accurate as the CNN model and not GPU accelerated.
# # See also: find_faces_in_picture_cnn.py
# face_locations = face_recognition.face_locations(image)
#
# print("{}".format(len(face_locations)))

# =============== MQTT STUFF STARTS HERE =============== #
#
# # The callback for when the client receives a CONNACK response from the server.
# def on_connect(client, userdata, flags, rc):
#     print("Connected with result code "+str(rc))
#
#     # Subscribing in on_connect() means that if we lose the connection and
#     # reconnect then subscriptions will be renewed.
#     client.subscribe("$SYS/#")
#
# # The callback for when a PUBLISH message is received from the server.
# def on_message(client, userdata, msg):
#     print(msg.topic+" "+str(msg.payload))
#
# client = mqtt.Client()
# client.on_connect = on_connect
# # client.on_message = on_message
#
# client.connect("test.mosquitto.org", 1883, 60)
# client.publish("uwsocialspacenums", len(face_locations), qos=2)
# # Blocking call that processes network traffic, dispatches callbacks and
# # handles reconnecting.
# # Other loop*() functions are available that give a threaded interface and a
# # manual interface.


# =============== BEGIN TEXT PROCESSING PART =============== #

nlp = spacy.load("en_core_web_sm")

merge_ents = nlp.create_pipe("merge_entities")
nlp.add_pipe(merge_ents)

merge_nc = nlp.create_pipe("merge_noun_chunks")
nlp.add_pipe(merge_nc)

text = "I’m going to visit my friend down in California, and also go see my friend in Minnesota"

# Process the text
doc = nlp(text)



for token in doc:
    # Get the token text, part-of-speech tag and dependency label
    token_text = token.text
    #token_pos = token.pos_
    if (token.pos_ == "NOUN" or token.pos_ == "PROPN"):
        if (token.dep_ != "nsubj" and token.dep_ != "dobj"):
            print(token_text)
    if (token.pos_ == "VERB" and token.dep_ == "ROOT"):
        if (token_text != "doing" and token_text != "going"):
            print(token_text)
    # print(token_text + " " + token.pos_ + " " + token.dep_)

    #token_dep = token.dep_
    # This is for formatting only
    #print("{:<12}{:<10}{:<10}".format(token_text, token_pos, token_dep))

# for chunk in doc.noun_chunks:
#     print(chunk.text, chunk.root.text, chunk.root.dep_,
#             chunk.root.head.text)
#     if (chunk.root.dep_ == "dobj" or chunk.root.dep_ == "pobj" or chunk.root.dep_ == "ROOT"):
#         #client.publish("uwsocialspacewords", chunk.root.text, qos=2)
#         print(chunk.root.text)

#client.loop_forever()
