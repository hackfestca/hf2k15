#!/bin/bash

aptitude install python3 python3-pip python-pip

git clone https://github.com/quick2wire/quick2wire-python-api
cd quick2wire-python-api
sudo python3 ./setup.py install
