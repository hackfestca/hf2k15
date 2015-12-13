import pexpect
import sys
import time


def connect(user, host, password, enapass):
        ssh_newkey = "Are you sure you want to continue connecting"
        connStr = 'ssh ' + user + '@' + host
        child = pexpect.spawn(connStr)
        ret = child.expect([pexpect.TIMEOUT, ssh_newkey, '[P|p]assword:'])
        if ret == 0 :
                print '[-] Error Connecting to ' + host
                return
        if ret == 1 :
                child.sendline('Yes')
                ret = child.expect([pexpect.TIMEOUT, '[P|p]assword:'])
                if ret == 0:
                        print '[-] Error Connecting to ' + host
                        return
        child.sendline(password)
        child.expect('>')
        return child

def main():
	IP = "10.2.2.2" 
	USER = "hf"
        PASS = "HF2015$"
	ENABLE = "HF2015$\n"	
	child = connect(USER,IP,PASS,ENABLE)
	fout = file('{0}.log'.format(IP),'w')
	child.logfile = fout
	child.sendline("enable")
	child.expect('Password:')
	child.sendline(ENABLE)
	child.expect('#')
	child.sendline("clear mac address-table dynamic\n")
	child.expect('#')
	child.sendline('exit')
	fout.close()

if  __name__ == '__main__':
        main()

