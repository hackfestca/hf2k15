#!/bin/sh
read -p "Ensure that the vmware tools are ready to be mounted (Guest -> Install vmware tools). Once ready, press [Enter]"
PKG='vmware-freebsd-tools.tar.gz'
cd /home
mount /dev/cd0c /mnt
cp /mnt/$PKG /home/
tar -xzvf $PKG
cd vmware-tools-distrib
perl ./vmware-install.pl -d
cd /home
umount /mnt
rm -rf vmware-tools-distrib
rm $PKG

