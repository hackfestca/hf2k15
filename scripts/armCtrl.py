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


from quick2wire.spi import SPIDevice, writing

def send_spi():
    with SPIDevice(0) as spi0:
        spi0.transaction(
            writing(0x20,bytes([0x01,0xFF])))
send_spi()
