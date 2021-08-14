#!/bin/sh
pkg1=x2x
status1="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg1" 2>&1)"
if [ ! $? = 0 ] || [ ! "$status1" = installed ] ; then
echo "x2x installing">x2x
sudo apt install $pkg1
echo "x2x installed">x2x
fi
pkg2=alsa-utils
status2="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg2" 2>&1)"
if [ ! $? = 0 ] || [ ! "$status2" = installed ] ; then
echo "alsa-utils installing">x2x
sudo apt install $pkg2 
echo "alsa-utils installed">alsa
fi
exit