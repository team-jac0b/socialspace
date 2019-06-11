# socialspace
Code repository for the social projection project from CSE 441/DES 372 Spring 2019. 

Socialspace is an ambient installation which seeks to foster spontaneous conversation between the two CSE buildings on the UW Seattle campus. It achieves this through a word-cloud visualization which prompts users with questions such as "What are your plans for this summer?" and then populates a word cloud with their responses. Users in both buildings can see the word clouds of the other building in real time, allowing a new form of conversation to occur. 

This repository contains the code to handle both the backend and frontend aspects of the project. 

In the backend folder, you will find two python files: 

- audio_input.py utilizes Google Cloud Speech-to-Text, spaCy, and profanity_filter to process input from a microphone, pull out key words, and then send those key words to an MQTT server which the frontend will pull the words from. 
- camera_input.py utilizes opencv and face_recognition to grab a picture from an attached webcam and then identify the number of faces in that picture. The number of faces will then be sent to an MQTT server to inform the frontend on how many individuals are currently present in the installation. 

In the frontend folder, you will find the processing sketch for running the animation. 