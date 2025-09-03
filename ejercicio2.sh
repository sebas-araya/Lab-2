#!/bin/bash

comando="$@"
log="monitoreo.log"

$comando &

PID=$(ps -C "$comando" -o pid= | head -n 1)

if [ z "$PID" ]; then
	echo "No se pudo encontrar el proceso"
	exit 1
fi

echo "Se va a ejecutar el comando $comando con el PID: $PID. Los datos de CPU y memoria se guardan en $log"

while ps -p $PID > /dev/null; do
	TS=$(date +%s)
	CPU=$(ps -p $PID -o %cpu=)
	mem=$(ps -p $PID -o %mem=)
	echo "$TS,$CPU,$MEM" >> "$log"
	sleep 2
done

