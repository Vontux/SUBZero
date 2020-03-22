#!/usr/bin/env python
#tweaked a script from an adafruit tutorial
#https://learn.adafruit.com/playing-sounds-and-using-buttons-with-raspberry-pi?view=all
import os
from time import sleep
 
import RPi.GPIO as GPIO
 
GPIO.setmode(GPIO.BCM)

GPIO.setup(21, GPIO.IN,pull_up_down=GPIO.PUD_UP)
 
while True:
 
    if (GPIO.input(21) == False):
       os.system('echo Poweroff')
       os.system('sudo shutdown -h now')
 
 
    sleep(0.1);
