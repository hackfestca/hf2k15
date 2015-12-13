#!/usr/bin/python 
from scapy.all import *

send(IP(src="10.2.2.100",dst="10.2.2.110")/ICMP()/"Hello World")
