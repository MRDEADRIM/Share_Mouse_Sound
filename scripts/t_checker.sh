
while :
do
if [ -z "$(pgrep -f run.sh)" ]; then
exit
else
sshpass -p  'akku' ssh akku@192.168.1.10 sensors > autoscript/temperature/remote_system
sensors > autoscript/temperature/local_system
sleep 5
fi
done 