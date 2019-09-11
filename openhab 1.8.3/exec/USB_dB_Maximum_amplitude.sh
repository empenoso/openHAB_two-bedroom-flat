#!/bin/bash
/usr/bin/arecord -D plughw:1,0 -d 10 -f S16_LE /tmp/test.wav 2>/dev/null;
sleep 15;
sox /tmp/test.wav -n stat 2>&1 | sed -n 's#^Maximum amplitude:[^0-9]*\([0-9.]*\)$#\1#p';
#
# detect sound card: 
# cat /proc/asound/cards
# sudo apt-get install sox alsa-utils 