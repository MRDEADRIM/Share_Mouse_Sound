#!/bin/sh
pkg=sshpass
status="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg" 2>&1)"
if [ ! $? = 0 ] || [ ! "$status" = installed ] ; then
echo "sshpass is not found installing">sshpass
sudo apt install $pkg
echo "sshpass installed">sshpass
fi
mkdir -p autoscript
mkdir -p data
mkdir -p scripts
mkdir -p errorlog
mkdir -p  autoscript/temperature
file=data/usr_status
if [ -f $file ]; then
echo "welcome"
else
echo "status:0" > data/usr_status
fi
if [ `cat $file` = "status:0" ]; then
echo "on" > data/mousekeybord
echo "on" > data/sound
echo "enter the username :>"
read usr
echo "$usr" > data/usr
echo "enter the targeted ip :>"
read ip
echo "$ip" > data/ip
id="$usr@$ip"
echo "$id" > data/id
echo "remote system direction east ,north ,south ,west[ e , n , s , w]"
while :
do
sleep 1
read direction
if [ "$direction" = "e" -o "$direction" = "n" -o "$direction" = "s" -o "$direction" = "w" ]; then
if [ "$direction"="e" ]; then
direction="east"
fi
if [ "$direction"="n" ]; then
direction="north"
fi
if [ "$direction"="s" ]; then
direction="south"
fi
if [ "$direction"="w" ]; then
direction="west"
fi
break
else
if [ "$direction" = "q" ]; then
echo "abort"
exit
else
echo "[e,n,s,w]Invalid key[q to quit]"
fi
fi
done
echo "-$direction">data/direction
echo "enter the password ( $id ) :"
read password
echo "$password" > data/password
sshpass -p $password ssh -t $id "mkdir pkg_script" 
echo "transfering script to user ($id)"
sleep 3
sshpass -p $password scp scripts/p_checker.sh $id:/home/akku/pkg_script
echo "finished transferip_ng script"
echo "checking for packages in remote system" 
sleep 10
sshpass -p $password ssh -t $id "sh pkg_script/p_checker.sh" 
echo "status:1" > data/usr_status
fi
sleep 10
while :
do
clear
if [ "$input" != "q" ]; then
echo " "
ip=`cat data/ip`
usr=`cat data/usr`
id=`cat data/id`
password=`cat data/password`
mousekeybord=`cat data/mousekeybord`
sound=`cat data/sound`
direction=`cat data/direction`
echo "v 0.1"
echo "+----------------------------------------------+"
echo "                  data                          "
echo "+----------------------------------------------+"
echo "username :>                    $usr"
echo "ip:>                           $ip" 
echo "ssh service :>                 $id"
echo "mouse and keybord switching :> $mousekeybord"
echo "system direction :>           $direction" 
echo "sound transfer :>              $sound"
echo " "
echo "u to update info [ u ]"
echo "v to view [ v ]"
echo "p to ping ($ip) [ p ]"
echo "l to list all availabel ip [ l ]"
echo "s to start [ s ]"
echo "t to check remote device and local device temperature [ t ]"
echo "h to stop all ssh running process [ h ]"
echo "q to quit [ q ]"
echo "r to remove all data [ r ]"
echo "+----------------------------------------------+"
read input
if [ "$input" = "t" ]; then
if [ -z "$(pgrep -f t_checker.sh)" ]; then
echo "processing.."
else
kill -9 $(pgrep -f t_checker.sh)
fi
sleep 10
sh scripts/t_checker.sh &
while :
do
clear
echo "----------------------------------------"
echo "the remote_system:"
echo "----------------------------------------"
cat autoscript/temperature/remote_system
echo "----------------------------------------"
echo " the local_system:"
echo "----------------------------------------"
cat autoscript/temperature/local_system
sleep 5   
done
sleep 10
fi
if [ "$input" = "v" ]; then
clear
echo "+----------------------------------------------+"
echo "                     view data                  "
echo "+----------------------------------------------+"
echo "ssh service :>                 $id"
echo "mouse and keybord switching :> $mousekeybord"
echo "sound transfer :>              $sound"
echo "+----------------------------------------------+"
while :
do
echo "presee any key"
sleep 1
read pass
if [ "$pass" != "q" ]; then
break
fi
done
fi
if [ "$input" = "l" ]; then
echo "enter your router ip (eg:192.168.1.1) :"
read r_ip
nmap -sn $r_ip/24
while :
do
echo "presee any key to continue"
sleep 1
read pass
if [ "$pass" != "q" ]; then
break
fi
done 
fi
if [ "$input" = "u" -o "$input" = "U"  ]; then
echo "user name :>"
read usr
echo "ip :>"
read ip
echo "$usr">data/usr
echo "$ip">data/ip
id="$usr@$ip"
echo "$id" > data/id

echo "mouse and keybord (off/on)"
read mousekeybord
if [ "$mousekeybord" = "on" ]; then
echo "on" > data/mousekeybord
echo "remote system direction east ,north ,south ,west[ e , n , s , w]"
while :
do
sleep 1
read direction
if [ "$direction" = "e" -o "$direction" = "n" -o "$direction" = "s" -o "$direction" = "w" ]; then
if [ "$direction"="e" ]; then
direction="east"
fi
if [ "$direction"="n" ]; then
direction="north"
fi
if [ "$direction"="s" ]; then
direction="south"
fi
if [ "$direction"="w" ]; then
direction="west"
fi
break
else
if [ "$direction" = "q" ]; then
echo "abort"
exit
else
echo "[e,n,s,w]Invalid key[q to quit]"
fi
fi
done
echo "-$direction" > data/direction
else
echo "off" > data/mousekeybord
fi
echo "sound transfer (off/on)"
read sound
if [ "$sound" = "on" ]; then
echo "enable"
echo "on">data/sound
else
echo "off">data/sound  
fi
clear
echo "+----------------------------------------------+"
echo "                    updated data               "
echo "+----------------------------------------------+"
echo "ssh service :>                 $id"
echo "mouse and keybord switching :> $mousekeybord"
echo "sound transfer :>              $sound"
echo "+----------------------------------------------+"
while :
do
echo "press any key to continue"
sleep 1
read pass
if [ "$pass" != "q" ]; then
break
fi
done
fi
if [ "$input" = "p" ]; then
ping -c 5 $ip
while :
do
echo "press any key to continue"
sleep 1
read pass
if [ "$pass" != "q" ]; then
break
fi
done
fi
if [ "$input" = "s" ]; then

echo "checking for requirement packages in the remote system"
sleep 3
sshpass -p $password ssh $id "cat pkg_script/x2x" > data/package_status_1
sshpass -p $password ssh $id "cat pkg_script/alsa" > data/package_status_2
package_status_1=`cat data/package_status_1`
package_status_2=`cat data/package_status_2`
clear
echo "+----------------------------------------------+"
echo "                     view                       "
echo "+----------------------------------------------+"
echo "ssh service :>                    $id"
echo "mouse and keybord switching :>    $mousekeybord"
echo "sound transfer :>                 $sound"

echo -n "x2x status on remote sys:>        "
if [ "$package_status_1" = "not x2x installed" ]; then
echo  "$package_status_1"
else
echo "$package_status_1"
fi

echo -n "alsa-utils status on remote sys:> "


if [ "$package_status_2" = "alsa-utils not installed" ]; then
echo "$package_status_2";
else

echo "$package_status_2";
fi


echo "+----------------------------------------------+"












sleep 1
echo "ssh -YC $id x2x $direction -to :0.0" > autoscript/ssh_mouse_key.sh
echo "ssh $id arecord - | aplay -" > autoscript/ssh_sound.sh
if [ "$mousekeybord" = "on" ]; then
while :
do
echo "press y to start mouse and keybord"
sleep 1
read pass
if [ "$pass" = "y" ]; then
break
fi
done
sshpass -p $password sh autoscript/ssh_mouse_key.sh > errorlog/mouse_out 2>&1 &
sleep 5
else
echo "mouse,keybord sharing off(turn on form update for enabling them)"
fi
if [ "$sound" = "on" ]; then
while :
do
echo "press y to start sound"
sleep 1
read pass
if [ "$pass" = "y" ]; then
break
fi
done
sshpass -p $password sh autoscript/ssh_sound.sh > errorlog/km_error_out 2>&1 &
sleep 5
else
echo "sound sharing off(turn on form update for enabling them)"
fi
while :
do
if [ "$sound" = "on" -o "$mousekeybord" = "on" ]; then
echo "finished the process is now running on background"
fi
echo "press enter to continue"
sleep 1
read pass
if [ "$pass" != "q" ]; then
break
fi
done
fi
else
exit
fi
if [ "$input" = "h" ]; then
while :
do
echo "temporary stoping all ssh process "
echo "Are you sure you want to continue[y/n]"
sleep 1
read pass
if [ "$pass" = "y" ]; then
killall ssh
while :
do
echo "done!!"
echo "press enter to continue"
sleep 1
read pass
if [ "$pass" != "q" ]; then
break
fi
done
break
fi
done
else
kill -9 $(pgrep -f t_checker.sh)
fi
done