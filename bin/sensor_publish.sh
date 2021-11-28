#!/bin/bash
# Params
PORT="${1:-3000}"
DELAY="${2:-3}"

URL="http://localhost:$PORT/cable_readings/events"

declare -a cableTypes=("MCV1" "MCV2" "MCV3")

function generateTemperatureReadings() {
   for i in {1..10}
    do 
        tempData="${RANDOM:0:4},$tempData"
    done
    tempData=${tempData%?}
}

function generateHumidityReadings() {
   for i in {1..10}
    do 
        humidityData="${RANDOM:0:4},$humidityData"
    done
    humidityData=${humidityData%?}
}

function generateCableSensorReadings(){
    sensorData=""
    epoch="$(date +"%s")"
    for i in {1..10}
    do 
        sensorId=$i
        index=$(($i%3))
        humidityData=""
        tempData=""
        generateHumidityReadings
        generateTemperatureReadings
        ts=$(($epoch + ${RANDOM:0:2}))
        sensorData="$ts:$sensorId:${cableTypes[$index]}:$tempData:$humidityData|$sensorData"
    done
    sensorData=${sensorData%?}
}

while true
do
    timenow="$(date +"%Y-%m-%dT%H-%M-%SZ")"
    deviceId=${RANDOM:0:2}
    batteryLevel=${RANDOM:0:2}
    generateCableSensorReadings
    curl -X POST -H "Content-Type: application/json" -d \
    '{"deviceId":'$deviceId',"batteryLevel":'$batteryLevel', "data":"'$sensorData'", "publishedAt":"'$timenow'"}' $URL; \
    sleep "$DELAY"s
done
