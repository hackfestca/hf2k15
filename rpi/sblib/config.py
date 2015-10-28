#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
Scripts config file

@author: Martin Dubé
@organization: Hackfest Communications
@license: Modified BSD License
@contact: martin.dube@hackfest.ca

Copyright (c) 2014, Hackfest Communications
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

DEFAULT_TOP_VALUE = 300

PLAYER_API_LISTEN_ADDR = '0.0.0.0'
PLAYER_API_LISTEN_PORT = 8000
PLAYER_API_URI = 'https://scoreboard.hf'
#PLAYER_API_URI = 'http://127.0.0.1:8000'
PLAYER_API_SSL_ROOT_CA = 'certs/hf.ca.ctf.chain.crt'

DB_HOST = 'db.hf'
DB_SCHEMA = 'scoreboard'
DB_NAME = 'scoreboard'
DB_SSL_ROOT_CA = 'certs/hf.ca.sb.chain.crt'
DB_CONNECT_TIMEOUT = 2

DB_RPI_USER = 'rpi'
DB_RPI_PASS = 'wggYUV5f9wEgBsPbCk1ToifhkLYRVwHk'
DB_RPI_CRT_FILE = None
DB_RPI_KEY_FILE = None

SQL_DATA_FILE = 'sql/data.sql'
SQL_FUNC_FILE = 'sql/functions.sql'
SQL_TABLE_FILE = 'sql/tables.sql'
SQL_SEC_FILE = 'sql/security.sql'

FLAG_UPDATER_SSH_USER = 'root'
FLAG_UPDATER_SSH_PUB_KEY = 'certs/id_rsa.hf2014.pub'
FLAG_UPDATER_SSH_PRIV_KEY = 'certs/id_rsa.hf2014'
FLAG_UPDATER_SSH_PRIV_PWD = ''

COMPETITION_MODE = True
'''
Not implemented yet. Enable to ensure nobody can accidentally delete data with initDB.py during competition.
@type: bool
'''

BENCH_DEFAULT_REQ_NUM = 50
BENCH_DEFAULT_CON_NUM = 30

