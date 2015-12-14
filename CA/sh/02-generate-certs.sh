#!/bin/bash

# server certificate
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=esx-g09.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.esx-g09' -i 'hf.ca.cor' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=vc02.infra.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.vc02' -i 'hf.ca.cor' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=ossim.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.ossim' -i 'hf.ca.cor' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=cacti.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.cacti' -i 'hf.ca.cor' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=seafile.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.seafile ' -i 'hf.ca.pub' -s "$SUBJECT" -d 1095

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=xmpp.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.xmpp ' -i 'hf.ca.pub' -s "$SUBJECT" -d 1825 

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=services.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.services ' -i 'hf.ca.pub' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=vpn.hackfest.ca"
./_create-cert.sh -t 'server' -n 'hf.srv.vpn.mart' -i 'hf.ca.vpn' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=db.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.db.hf' -i 'hf.ca.sb' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=imaginium.ctf.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.ihack-imaginium' -i 'hf.ca.ihack2k15' -s "$SUBJECT" -d 6 -a 'DNS:imaginium.ctf.hf'

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=fims.ctf.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.ihack-fims' -i 'hf.ca.ihack2k15' -s "$SUBJECT" -d 6 -a 'DNS:fims.ctf.hf'

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=scoreboard.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.scoreboard.hf' -i 'hf.ca.ihack2k15' -s "$SUBJECT" -d 1825

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=scoreboard.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.scoreboard2015.hf' -i 'hf.ca.ctf2015' -s "$SUBJECT" -d 6

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=demat.ctf.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.demat.ctf.hf' -i 'hf.ca.ctf2015' -s "$SUBJECT" -d 6

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=wifiradius.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.wifiradius.hf' -i 'hf.ca.cor' -s "$SUBJECT" -d 365

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=scoreboard.hf"
./_create-cert.sh -t 'server' -n 'hf.srv.scoreboard2016.hf' -i 'hf.ca.ctf2016' -s "$SUBJECT" -d 361 # Expire: 2016-11-06

## client certificate
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=Comite"
./_create-cert.sh -t 'client' -n 'hf.cli.comite' -i 'hf.ca.cli' -s "$SUBJECT" -d 1095

SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=admin"
./_create-cert.sh -t 'client' -n 'hf.cli.db.admin' -i 'hf.ca.sb' -s "$SUBJECT" -d 1095 -p $pwd
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=player"
./_create-cert.sh -t 'client' -n 'hf.cli.db.player' -i 'hf.ca.sb' -s "$SUBJECT" -d 1095 -p $pwd
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=web"
./_create-cert.sh -t 'client' -n 'hf.cli.db.web' -i 'hf.ca.sb' -s "$SUBJECT" -d 1095 -p $pwd
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=flagupdater"
./_create-cert.sh -t 'client' -n 'hf.cli.db.flagupdater' -i 'hf.ca.sb' -s "$SUBJECT" -d 1095 -p $pwd
SUBJECT="/C=CA/ST=Qc/L=Quebec/O=Hackfest Communication/OU=Hackfest Communication/CN=owner"
./_create-cert.sh -t 'client' -n 'hf.cli.db.owner' -i 'hf.ca.sb' -s "$SUBJECT" -d 1095 -p $pwd

## client certificate: VPN Clients
# removed.
