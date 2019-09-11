#!/bin/bash
hostname=192.168.88.2
if ping -c 1 $hostname &> /dev/null
then
  ping -c 5 $hostname | grep rtt | cut -d"/" -f5
else
  echo 0
fi