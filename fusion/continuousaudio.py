from __future__ import division

import cv2

import face_recognition

import spacy

import paho.mqtt.client as mqtt

from profanity_check import predict, predict_prob

import pyaudio
import wave

from six.moves import queue
import re
import sys
import io
import os

# Imports the Google Cloud client library
from google.cloud import speech
from google.cloud.speech import enums
from google.cloud.speech import types

os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="Team-Jacob-0efc2ed78470.json"
#
# # Audio recording parameters
# RATE = 16000
# CHUNK = int(RATE / 10)  # 100ms

#=============== START AUDIO CAPTURE PART =============== #

def audio_capture():
    CHUNK = 1024
    FORMAT = pyaudio.paInt16
    CHANNELS = 2
    RATE = 44100
    RECORD_SECONDS = 10
    WAVE_OUTPUT_FILENAME = "output.wav"

    p = pyaudio.PyAudio()

    stream = p.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    input=True,
                    frames_per_buffer=CHUNK)

    print("* recording")

    frames = []

    for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
        data = stream.read(CHUNK)
        frames.append(data)

    print("* done recording")

    stream.stop_stream()
    stream.close()
    p.terminate()

    wf = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
    wf.setnchannels(CHANNELS)
    wf.setsampwidth(p.get_sample_size(FORMAT))
    wf.setframerate(RATE)
    wf.writeframes(b''.join(frames))
    wf.close()

# =============== START SPEECH TO TEXT PART =============== #

def speech_to_text():
    # Instantiates a client
    client = speech.SpeechClient()

    # The name of the audio file to transcribe
    file_name = os.path.join(
        os.path.dirname(__file__),
        'output.wav')

    # Loads the audio into memory
    with io.open(file_name, 'rb') as audio_file:
        content = audio_file.read()
        audio = types.RecognitionAudio(content=content)

    config = types.RecognitionConfig(
        encoding=enums.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=44100,
        audio_channel_count=2,
        language_code='en-US',
        enable_automatic_punctuation=True)

    # Detects speech in the audio file
    response = client.recognize(config, audio)

    transcript = "";

    for result in response.results:
        print('Transcript: {}'.format(result.alternatives[0].transcript))
        transcript += result.alternatives[0].transcript

    return transcript;

# =============== BEGIN PROFANITY CHECK PART =============== #

def profanity_check(input):
    transcriptArray = input.split()
    processText = True;
    profanityResult = predict(transcriptArray)
    for v in profanityResult:
        if v == 1:
            return False
    return True



# =============== BEGIN TEXT PROCESSING PART =============== #

def process_words(transcript, clientMQTT):
    nlp = spacy.load("en_core_web_sm")

    merge_ents = nlp.create_pipe("merge_entities")
    nlp.add_pipe(merge_ents)

    merge_nc = nlp.create_pipe("merge_noun_chunks")
    nlp.add_pipe(merge_nc)

    # Hardcoded string for testing
    text = "I’m going to visit my friend down in California, and also go see my friend in Minnesota."

    # Process the text
    doc = nlp(transcript)

    for token in doc:
        # Get the token text, part-of-speech tag and dependency label
        token_text = token.text
        #token_pos = token.pos_
        if (token.pos_ == "NOUN" or token.pos_ == "PROPN"):
            if (token.dep_ != "nsubj" and token.dep_ != "dobj"):
                if profanity_check(token_text):
                    print(token_text)
                    clientMQTT.publish("uwsocialspacewordsGates", token_text, qos=2)
        if (token.pos_ == "VERB" and token.dep_ == "ROOT"):
            if (token_text != "doing" and token_text != "going"):
                if profanity_check(token_text):
                    print(token_text)
                    clientMQTT.publish("uwsocialspacewordsGates", token_text, qos=2)
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

# Audio recording parameters
RATE = 16000
CHUNK = int(RATE / 10)  # 100ms


class MicrophoneStream(object):
    """Opens a recording stream as a generator yielding the audio chunks."""
    def __init__(self, rate, chunk):
        self._rate = rate
        self._chunk = chunk

        # Create a thread-safe buffer of audio data
        self._buff = queue.Queue()
        self.closed = True

    def __enter__(self):
        self._audio_interface = pyaudio.PyAudio()
        self._audio_stream = self._audio_interface.open(
            format=pyaudio.paInt16,
            # The API currently only supports 1-channel (mono) audio
            # https://goo.gl/z757pE
            channels=1, rate=self._rate,
            input=True, frames_per_buffer=self._chunk,
            # Run the audio stream asynchronously to fill the buffer object.
            # This is necessary so that the input device's buffer doesn't
            # overflow while the calling thread makes network requests, etc.
            stream_callback=self._fill_buffer,
        )

        self.closed = False

        return self

    def __exit__(self, type, value, traceback):
        self._audio_stream.stop_stream()
        self._audio_stream.close()
        self.closed = True
        # Signal the generator to terminate so that the client's
        # streaming_recognize method will not block the process termination.
        self._buff.put(None)
        self._audio_interface.terminate()

    def _fill_buffer(self, in_data, frame_count, time_info, status_flags):
        """Continuously collect data from the audio stream, into the buffer."""
        self._buff.put(in_data)
        return None, pyaudio.paContinue

    def generator(self):
        while not self.closed:
            # Use a blocking get() to ensure there's at least one chunk of
            # data, and stop iteration if the chunk is None, indicating the
            # end of the audio stream.
            chunk = self._buff.get()
            if chunk is None:
                return
            data = [chunk]

            # Now consume whatever other data's still buffered.
            while True:
                try:
                    chunk = self._buff.get(block=False)
                    if chunk is None:
                        return
                    data.append(chunk)
                except queue.Empty:
                    break

            yield b''.join(data)


def listen_print_loop(responses, clientMQTT):
    """Iterates through server responses and prints them.

    The responses passed is a generator that will block until a response
    is provided by the server.

    Each response may contain multiple results, and each result may contain
    multiple alternatives; for details, see https://goo.gl/tjCPAU.  Here we
    print only the transcription for the top alternative of the top result.

    In this case, responses are provided for interim results as well. If the
    response is an interim one, print a line feed at the end of it, to allow
    the next result to overwrite it, until the response is a final one. For the
    final one, print a newline to preserve the finalized transcription.
    """
    num_chars_printed = 0
    for response in responses:
        if not response.results:
            continue

        # The `results` list is consecutive. For streaming, we only care about
        # the first result being considered, since once it's `is_final`, it
        # moves on to considering the next utterance.
        result = response.results[0]
        if not result.alternatives:
            continue

        # Display the transcription of the top alternative.
        transcript = result.alternatives[0].transcript

        # Display interim results, but with a carriage return at the end of the
        # line, so subsequent lines will overwrite them.
        #
        # If the previous result was longer than this one, we need to print
        # some extra spaces to overwrite the previous result
        overwrite_chars = ' ' * (num_chars_printed - len(transcript))

        if not result.is_final:
            #sys.stdout.write(transcript + overwrite_chars + '\r')
            #sys.stdout.flush()

            num_chars_printed = len(transcript)

        else:
            #print(transcript + overwrite_chars)
            process_words(transcript + overwrite_chars, clientMQTT)

            # Exit recognition if any of the transcribed phrases could be
            # one of our keywords.
            if re.search(r'\b(exit|quit)\b', transcript, re.I):
                print('Exiting..')
                break

            num_chars_printed = 0


def main():
    # See http://g.co/cloud/speech/docs/languages
    # for a list of supported languages.
    language_code = 'en-US'  # a BCP-47 language tag

    client = speech.SpeechClient()
    config = types.RecognitionConfig(
        encoding=enums.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=RATE,
        language_code=language_code)
    streaming_config = types.StreamingRecognitionConfig(
        config=config,
        interim_results=True)

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
    # client.on_message = on_message
    clientMQTT.username_pw_set("c4cc8af9", "959dcc8e063b9572")
    clientMQTT.connect_async("broker.shiftr.io", 1883, 60)
    clientMQTT.loop_start()
    # Blocking call that processes network traffic, dispatches callbacks and
    # handles reconnecting.
    # Other loop*() functions are available that give a threaded interface and a
    # manual interface.
    while True:

        # with MicrophoneStream(RATE, CHUNK) as stream:
        #     audio_generator = stream.generator()
        #     requests = (types.StreamingRecognizeRequest(audio_content=content)
        #                 for content in audio_generator)
        #
        #     responses = client.streaming_recognize(streaming_config, requests)
        #
        #     # Now, put the transcription responses to use.
        #     try:
        #         listen_print_loop(responses, clientMQTT)
        #     except Exception as exception:
        #         print("Exception handle : Exceeded maximum allowed stream duration")
        audio_capture()
        transcript = speech_to_text()
        process_words(transcript, clientMQTT)


if __name__ == '__main__':
    main()
