#!/usr/bin/python3
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
import config, ModelController
import argparse
from time import sleep

# Get args
usage = 'usage: %prog action [options]'
description = 'HF Model client. Use this tool to interact with the model.'
parser = argparse.ArgumentParser(description=description)
parser.add_argument('-v','--version', action='version', version='%(prog)s 1.0 (2015-11-03)')
parser.add_argument('--debug', action='store_true', dest='debug', default=False, \
                    help='Run the tool in debug mode')
subparsers = parser.add_subparsers(dest='action')

casino = subparsers.add_parser('casino', help='Manage the casino')
casino.add_argument('--countdown', action='store_true', dest='countdown', default=False, help='Update countdown.')
casino.add_argument('--news', action='store_true', dest='news', default=False, help='Update news.')
casino.add_argument('--teams', action='store_true', dest='teams', default=False, help='Update teams.')
casino.add_argument('--all', action='store_true', dest='all', default=False, help='Update all.')
casino.add_argument('--drawFlag', action='store_true', dest='drawFlag', default=False, help='Draw Flag.')

arm = subparsers.add_parser('arm', help='Play with the Robotic Arm')
arm.add_argument('--getFlag', action='store_true', dest='getFlag', default=False, help='Get Flag.')
arm.add_argument('--play', action='store_true', dest='play', default=False, help='Play with the arm (live).')

pipeline = subparsers.add_parser('pipeline', help='Manage the pipeline')
pipeline.add_argument('--getFlag', action='store_true', dest='getFlag', default=False, help='Get Flag.')

args = parser.parse_args()

if args.debug:
    print('[-] Arguments: ' + str(args))

if args.action == 'casino':
    if args.countdown:
        c = ModelController.CasinoController()
        c.updateCountDown()
    elif args.news:
        c = ModelController.CasinoController()
        c.updateNews()
    elif args.teams:
        c = ModelController.CasinoController()
        c.updateTopTeams()
    elif args.all:
        c = ModelController.CasinoController()
        c.updateCountDown()
        sleep(1)
        c.updateNews()
        sleep(1)
        c.updateTopTeams()
        sleep(1)
    elif args.drawFlag:
        c = ModelController.CasinoController()
        c.drawFlag()
        
elif args.action == 'arm':
    if args.getFlag:
        c = ModelController.RoboticArmController()
        c.getFlag()
    elif args.play:
        c = ModelController.RoboticArmController()
        c.send_spi_live()

elif args.action == 'pipeline':
    if args.getFlag:
        c = ModelController.PipelineController()
        c.getFlag()
else:
    print('Invalid command')



