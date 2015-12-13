#!/usr/bin/python

import RPi.GPIO as GPIO
import time

#content = 1 , 4 
#moyen   = 2 , 17
#neutre  = 3 , 18
#facher  = 4 , 21

GPIO.setmode(GPIO.BCM)
GPIO.setup(4, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(17, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(18, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(21, GPIO.IN, pull_up_down=GPIO.PUD_UP)


while True:
	input_state = GPIO.input(4)
	if input_state == False:
		#print('Button Press 1')
		with open("score.txt", "a") as log:
			log.write("{} Button Press 1\n".format(time.strftime("%Y-%m-%d %I:%M:%S")))
		time.sleep(0.5)
	input_state = GPIO.input(17)
	if input_state == False:
		#print('Button Press 2')
		with open("score.txt", "a") as log:
			log.write("{} Button Press 2\n".format(time.strftime("%Y-%m-%d %I:%M:%S")))
		time.sleep(0.5)
	input_state = GPIO.input(18)
	if input_state == False:
		#print('Button Press 3')
		with open("score.txt", "a") as log:
			log.write("{} Button Press 3\n".format(time.strftime("%Y-%m-%d %I:%M:%S")))
		time.sleep(0.5)
	input_state = GPIO.input(21)
	if input_state == False:
		#print('Button Press 4')
		with open("score.txt", "a") as log:
			log.write("{} Button Press 4\n".format(time.strftime("%Y-%m-%d %I:%M:%S")))
		time.sleep(0.5)

