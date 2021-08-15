#!/bin/sh
pkg1=x2x
status1="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg1" 2>&1)"
if [ ! $? = 0 ] || [ ! "$status1" = installed ]; then
sudo apt install $pkg1 || echo "not x2x installed" > pkg_script/x2x

else
echo "x2x installed" > pkg_script/x2x
fi
pkg2=alsa-utils
status2="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg2" 2>&1)"
if [ ! $? = 0 ] || [ ! "$status2" = installed ]; then
sudo apt install $pkg2 || echo "alsa-utils not installed" > pkg_script/alsa

else
echo "alsa-utils installed" > pkg_script/alsa
fi
exit