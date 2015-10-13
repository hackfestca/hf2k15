# Thanks to
# https://github.com/quick2wire/trackbot/blob/master/python/spike.py

# SDA=2  SCL=3
#from quick2wire.i2c import I2CMaster, writing_bytes
#from time import sleep
#address = 0x05

#def send_i2c():
#    with I2CMaster() as master:    
#        while(True):
#            c = input(':')
#            if c.startswith('q'):
#                break
#            master.transaction(
#                writing_bytes(address, ord(c[0])))
#send_i2c()


#from quick2wire.spi import SPIDevice, writing, writing_bytes, reading
from quick2wire.spi import *
import curses
import time

def send_spi_live():
    with SPIDevice(0) as spi0:
        stdscr = curses.initscr()
        while(True):
            #c = input('>')
            c = stdscr.getch()
            if chr(c).startswith('q'):
                break
            spi0.transaction(
                writing_bytes(c))
        curses.endwin()

def getFlag1():
    flag = b''
    with SPIDevice(0) as spi0:
        # Get only first char
        spi0.transaction(
            writing_bytes(ord('_')))
        time.sleep(0.5)
        while 1: 
            raw = spi0.transaction(reading(1))
            #print(raw)
            c = raw[0]
            if c == b'\x00':
                break
            flag += c
        print(flag)
        
#send_spi_live()
getFlag1()
