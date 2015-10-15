#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
Arduino controller class used for the model

@author: Martin Dubé
@organization: Hackfest Communications
@license: Modified BSD License
@contact: martin.dube@hackfest.ca

Copyright (c) 2015, Hackfest Communications
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'''

# Thanks to quick2wire for i2c/spi libs
# https://github.com/quick2wire/trackbot/blob/master/python/spike.py

# On rpi, pins are:
# SDA=2  SCL=3

# Python version validation
import sys 
if sys.version_info < (3,2,0):
    print('Python version 3.2 or later is needed for this script')
    exit(1);

sys.path.insert(0, 'sblib')


import config, ClientController
from Crypto.Cipher import AES
import binascii
import quick2wire.i2c as i2c
import quick2wire.spi as spi
import curses
from time import sleep

class CasinoController(ClientController.ClientController):
    i2cAddr = 0x04

    def __init__(self):
        self._sUser = config.DB_RPI_USER
        self._sPass = config.DB_RPI_PASS
        self._sCrtFile = config.DB_RPI_CRT_FILE
        self._sKeyFile = config.DB_RPI_KEY_FILE
        super().__init__()

    def _send_i2c(self,msg):
        with i2c.I2CMaster() as master:
            master.transaction(
                i2c.writing(self.i2cAddr, msg))
    
    def updateCountDown(self):
        cd = self._exec('getModelCountDown()').encode('utf-8')
        self._send_i2c(b'c'+cd)
    
    def updateNews(self):
        news = self._exec('getModelNews()')
        self._send_i2c(b'n'+news)
    
    def updateTopTeams(self):
        topTeams = self._exec('getModelTopTeams()')
        self._send_i2c(b't'+topTeams)
    
    def getI2CFlag1(self,key):
        self._send_i2c(b'f'+key)
        sleep(1)
    
        # Get flag
        with i2c.I2CMaster() as master:
            encFlag = master.transaction(
                    i2c.reading(self.i2cAddr,16))[0]
            print('Encrypted Flag: %s' % encFlag)
    
            # Decrypt
            IV = 16 * "\x00"
            mode = AES.MODE_CBC
            encryptor = AES.new(key,mode,IV=IV)
            flag = encryptor.decrypt(encFlag)
            print(b'Flag is: ' + flag)
    

class RoboticArmController(ClientController.ClientController):
    def __init__(self):
        self._sUser = config.DB_RPI_USER
        self._sPass = config.DB_RPI_PASS
        self._sCrtFile = config.DB_RPI_CRT_FILE
        self._sKeyFile = config.DB_RPI_KEY_FILE
        super().__init__()

    def send_spi_live(self):
        with spi.SPIDevice(0) as spi0:
            stdscr = curses.initscr()
            while(True):
                #c = input('>')
                c = stdscr.getch()
                if chr(c).startswith('q'):
                    break
                spi0.transaction(
                    spi.writing_bytes(c))
            curses.endwin()
    
    def getSPIFlag1(self):
        flag = b''
        with spi.SPIDevice(0) as spi0:
            # Get only first char
            spi0.transaction(
                spi.writing_bytes(ord('_')))
            sleep(0.5)
            while 1: 
                raw = spi0.transaction(spi.reading(1))
                #print(raw)
                c = raw[0]
                if c == b'\x00':
                    break
                flag += c
            print(flag)




c = CasinoController()
#key = b'ZZZZZZZZZZZZZZZZ'
#c.getI2CFlag1(key)
c.updateCountDown()

#c = RoboticArmController()
#c.send_spi_live()
#c.getSPIFlag1()




