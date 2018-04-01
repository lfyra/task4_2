#!/bin/bash
touch /var/mail/root
exec &> /var/mail/root
run=$(ls /var/run | grep ntp|wc -l)
more=$(grep -Fxvf /etc/ntpdefault /etc/ntp.conf | wc -l)
less=$(grep -Fxvf /etc/ntp.conf /etc/ntpdefault| wc -l)

if [[ $more -ne 0 || $less -ne 0 ]]
then
echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
echo "+++ $(grep -Fxvf /etc/ntpdefault /etc/ntp.conf)"
echo "--- $(grep -Fxvf /etc/ntp.conf /etc/ntpdefault)"
rm /etc/ntp.conf
cp /etc/ntpdefault /etc/ntp.conf
/etc/init.d/ntp restart > /dev/null
if [ $run -eq 0 ]
then
echo "NOTICE: ntp is not running"
/etc/init.d/ntp start
fi
else
if [ $run -eq 0 ]
then
echo "NOTICE: ntp is not running"
/etc/init.d/ntp start
fi
fi

