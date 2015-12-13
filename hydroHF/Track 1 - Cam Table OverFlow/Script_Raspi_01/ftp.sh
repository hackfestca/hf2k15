#!/bin/bash
HOST='10.2.2.110'
USER='vsftpd'
PASSWD='HF2015$'

ftp -n -v $HOST << EOT
ascii
user $USER $PASSWD
prompt
put hydro.hf.command
ls -la
bye
EOT

