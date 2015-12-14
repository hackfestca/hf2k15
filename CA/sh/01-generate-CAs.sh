#!/bin/bash

## root CA
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest root CA"
./_create-cert.sh -t 'ca' -n 'hf.ca.root' -i 'hf.ca.root' -s "$SUBJECT" -d 3650

## intermediate CA
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA VPN"
./_create-cert.sh -t 'ca' -n 'hf.ca.vpn' -i 'hf.ca.root' -s "$SUBJECT" -d 1825 

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA Clients"
./_create-cert.sh -t 'ca' -n 'hf.ca.cli' -i 'hf.ca.root' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA Public Services"
./_create-cert.sh -t 'ca' -n 'hf.ca.pub' -i 'hf.ca.root' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA Core Infra"
./_create-cert.sh -t 'ca' -n 'hf.ca.cor' -i 'hf.ca.root' -s "$SUBJECT" -d 1825

## intermedaite CA for CTFs. One for each.
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA CTF 2015"
./_create-cert.sh -t 'ca' -n 'hf.ca.ctf' -i 'hf.ca.root' -s "$SUBJECT" -d 240       # 2015-11-08 - 2015-03-13

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA iHack2k15"
./_create-cert.sh -t 'ca' -n 'hf.ca.ihack2k15' -i 'hf.ca.root' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA CTF2015"
./_create-cert.sh -t 'ca' -n 'hf.ca.ctf2015' -i 'hf.ca.root' -s "$SUBJECT" -d 6

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA CTF2016"
./_create-cert.sh -t 'ca' -n 'hf.ca.ctf2016' -i 'hf.ca.root' -s "$SUBJECT" -d 361 # Expire: 2016-11-06

## intermediate CA for scoreboard DB access
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Hackfest inter CA CTF Scoreboard"
./_create-cert.sh -t 'ca' -n 'hf.ca.sb' -i 'hf.ca.root' -s "$SUBJECT" -d 1825
