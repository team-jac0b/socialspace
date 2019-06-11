import face_recognition

# Load the jpg file into a numpy array
image = face_recognition.load_image_file("group-6.jpg")

# Find all the faces in the image using the default HOG-based model.
# This method is fairly accurate, but not as accurate as the CNN model and not GPU accelerated.
# See also: find_faces_in_picture_cnn.py
face_locations = face_recognition.face_locations(image)

print("{}".format(len(face_locations)))