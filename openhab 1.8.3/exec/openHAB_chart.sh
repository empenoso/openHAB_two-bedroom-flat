#!/bin/bash
wget -O /tmp/chart1.jpg "http://192.168.88.70:8080/chart?items=USB_Maximum_amplitude_dB,MikroTik_Wireless_Clients&period=W&h=595&w=842" 2>/dev/null;
sleep 5;
wget -O /tmp/chart2.jpg "http://192.168.88.70:8080/chart?items=P7_DS18B20_WC_cold,P8_DS18B20_WC_hot,P5_DS18B20_MQ2,P2_DS18B20,P13_DS18B20_bedroom&period=W&h=595&w=842" 2>/dev/null;
sleep 5;
wget -O /tmp/chart3.jpg "http://192.168.88.70:8080/chart?items=cpuCombined,openhabCpuPercent,LAN_MikroTik,LAN_MegaD328,LAN_Beward&period=W&h=595&w=842" 2>/dev/null;