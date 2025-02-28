#!/bin/bash

sudo service dbus start
sudo service bluetooth start
./bt_pair.sh
./bt_connect.sh
/usr/bin/librespot --name "Living Room Speakers" --device pulse --bitrate 320 --disable-audio-cache --enable-volume-normalisation --initial-volume 30
/bin/bash