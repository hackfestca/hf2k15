#!/usr/bin/env python
# -*- coding: utf-8 -*-

import smbus
import time

# for RPI version 1, use "bus = smbus.SMBus(0)"
bus = smbus.SMBus(1)

# This is the address we setup in the Arduino Program
address = 0x04

def writeNumber(value):
    bus.write_byte(address, value)
    # bus.write_byte_data(address, 0, value)
    return -1

def readNumber():
    number = bus.read_byte(address)
    # number = bus.read_byte_data(address, 1)
    return number

def writeData(value):
    for v in value:
        bus.write_byte(address,v)
    return -1

def readData():
    return bus.read_block_data(address,1)

while True:
    #var = raw_input("Enter data: ")
    var = [0x41,0x42,0x43]
    if not var:
        continue

    #writeNumber(var)
    writeData(var)
    print "RPI: Hi Arduino, I sent you ", var
    # sleep one second
    time.sleep(1)
    
    #number = readNumber()
    data = readData()
    print "Arduino: Hey RPI, I received data", data
    print
