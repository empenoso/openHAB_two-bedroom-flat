#!/bin/bash
# stop openhab instance (here: systemd service)
echo "+-+-+-+-+-+-+ Stopping service...+-+-+-+-+-+-+-+"
sudo systemctl stop openhab2.service

# backup current installation with settings
echo "+-+-+-+-+-+-+ timestamp and folder setup +-+-+-+-+-+-+-+-+";
TIMESTAMP="`date +%Y%m%d_%H%M%S`";
sudo mkdir  "/home/openhabian/openhab2-backup-$TIMESTAMP";
sudo mkdir  "/home/openhabian/openhab2-backup-$TIMESTAMP/influxdb";
sudo mkdir  "/home/openhabian/openhab2-backup-$TIMESTAMP/grafana";
#bakdir="$HOME/openhab2-backup/$TIMESTAMP";
#mkdir -p "${bakdir}"

echo "+-+-+-+-+-+-+ OH backup +-+-+-+-+-+-+-+-+-+-+"
#cp -arv /etc/openhab2 "${bakdir}/conf"
#cp -arv /var/lib/openhab2 "${bakdir}/userdata"
#find /var/lib/openhab2 \( -path /var/lib/openhab2/tmp -prune -o -path /var/lib/openhab2/cache -prune \) -o -name '*' -exec cp -arv {} "${bakdir}/userdata"  \;
sudo cp -arv "/etc/openhab2" "/home/openhabian/openhab2-backup-$TIMESTAMP/conf";
sudo cp -arv "/var/lib/openhab2" "/home/openhabian/openhab2-backup-$TIMESTAMP/userdata";

echo "+-+-+-+-+-+-+ Grafana backup +-+-+-+-+-+-+-+-+"
sudo systemctl stop grafana-server
sudo cp -arv "/etc/grafana/grafana.ini" "/home/openhabian/openhab2-backup-$TIMESTAMP/grafana/grafana.ini";
sudo cp -arv "/var/lib/grafana/grafana.db" "/home/openhabian/openhab2-backup-$TIMESTAMP/grafana/grafana.db";

echo "+-+-+-+-+-+-+ Influxdb backup +-+-+-+-+-+-+-+"
sudo cp -arv "/etc/influxdb/influxdb.conf" "/home/openhabian/openhab2-backup-$TIMESTAMP/influxdb/influxdb.conf"
sudo influxd backup "/home/openhabian/openhab2-backup-$TIMESTAMP/influxdb/metastore/"
sudo influxd backup -database openhab_db "/home/openhabian/openhab2-backup-$TIMESTAMP/influxdb/db/"

# restart openhab instance
echo "+-+-+-+-+-+-+ Starting service...+-+-+-+-+-+-+-+-+"
sudo systemctl start openhab2.service
sudo systemctl start grafana-server

echo "+-+-+-+-+-+-+ Clear cache and tmp folder +-+-+-+-+-+-+-+-+"
sudo rm -rf "/home/openhabian/openhab2-backup-$TIMESTAMP/userdata/cache"
sudo rm -rf "/home/openhabian/openhab2-backup-$TIMESTAMP/userdata/tmp"

# Packen
echo "+-+-+-+-+-+-+ Pack Backup Folder into tar.gz +-+-+-+-+-+-+-+-+"
sudo tar cfvz /home/openhabian/openhab2-backup-$TIMESTAMP.tar.gz /home/openhabian/openhab2-backup-$TIMESTAMP

# Entpacken-> tar xfvz archiv.tar.gz

# Folder size
# sudo ls -1d */ | sudo xargs -I{} du {} -sh && sudo du -sh
sudo df -h /home/openhabian/; sudo du -sh -- /home/openhabian/*

# https://community.openhab.org/t/recommended-way-to-backup-restore-oh2-configurations-and-things/7193/73