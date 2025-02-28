#!/bin/bash

device="F4:4E:FD:A1:CE:76"
pulseaudio --start --exit-idle-time=-1

until bluetoothctl connect $device
do
  bluetoothctl disconnect $device
  sleep 2
  pulseaudio --start --exit-idle-time=-1
done
