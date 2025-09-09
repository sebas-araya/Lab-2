#!/bin/bash

comando="$@"
log="monitoreo.log"

$comando & #manda comando a background

PID=$(ps -C "$comando" -o pid= | head -n 1)

if [ -z "$PID" ]; then
	echo "No se pudo encontrar el proceso"
	exit 1
fi

echo "Se ejecutará el comando: $comando con el PID: $PID. Los datos de CPU y memoria se guardan en $log"

for i in 1 2 3 4 5; do
	fecha=$(date +%s)
	info=$(ps -C "$comando" -o %cpu=,%mem= | head -n 1)
	echo "$fecha,$info" >> "$log"
done

