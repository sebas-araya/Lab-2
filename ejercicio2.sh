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
	CPU=$(ps -C "$comando" -o %cpu= | head -n 1)
	mem=$(ps -C "$comando" -o %mem= | head -n 1)
	echo "$fecha,$CPU,$mem" >> "$log"
done

gnuplot -persist <<-EOF
	set title "Monitoreo de $comando"
	set xlabel "Tiempo (s)"
	set ylabel "Uso (%)"
	set datafile separator ","
	plot "$log" using 1:2 with lines title "CPU", \
	     "$log" using 1:3 with lines title "MEM"
EOF
