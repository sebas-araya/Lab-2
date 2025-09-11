directorio="/home/sebasaraya"
logfile="/home/sebasaraya/logs/monitoreo2.log"

echo "Se va a monitorear el direcotorio $directorio, los cambios se guardan en $logfile"

inotifywait -m -q -e create,modify,delete "$directorio" |
while read evento; do
	echo "$(date "+%Y-%m-%d %H:%M:%S")- $evento">> "$logfile"
done
