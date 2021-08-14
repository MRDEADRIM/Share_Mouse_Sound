#!/bin/sh
password=`cat data/password`
id=`cat data/id`
sleep 20
while :
do
if [ -z "$(pgrep -f run.sh)" ]; then
exit
else
echo "started"
#sshpass -p  $password ssh $usr sensors > autoscript/temperature/remote_system
#sensors > autoscript/temperature/local_system
sleep 5
fi
done t_checker