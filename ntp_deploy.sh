#!/bin/bash
if !(dpkg -l sed > /dev/null)
then
apt install sed -y
fi

if !(dpkg -l ntp > /dev/null)
then
apt install ntp -y
fi

sed -i '/^pool/d' /etc/ntp.conf
echo "pool ua.pool.ntp.org" >> /etc/ntp.conf
cp /etc/ntp.conf /etc/ntpdefault
/etc/init.d/ntp restart 1> /dev/null

path=$(dirname "$(readlink -f "$0")")
crontab -l | { cat; echo "* * * * * $path/ntp_verify.sh"; } | crontab -
