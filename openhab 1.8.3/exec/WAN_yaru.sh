#!/bin/bash
hostname=ya.ru
if ping -c 1 $hostname &> /dev/null
then
  ping -c 5 $hostname | grep rtt | cut -d"/" -f5
else
  echo 0
fi