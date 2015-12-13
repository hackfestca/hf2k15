#!/bin/bash

while [1]
do
sleep 60
ifconfig eth0 down
macchanger -r et0
ifconfig eth0 up 
done 

