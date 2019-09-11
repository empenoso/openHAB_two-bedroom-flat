# https://community.openhab.org/t/recommended-way-to-backup-restore-oh2-configurations-and-things/7193/73

#!/bin/bash
# stop openhab instance (here: systemd service)
echo "+-+-+-+-+-+-+ Stopping service...+-+-+-+-+-+-+-+"
sudo systemctl stop openhab2.service

# restore current installation with settings
#echo "+-+-+-+-+-+-+ timestamp and folder setup +-+-+-+-+-+-+-+-+";
#TIMESTAMP="`date +%Y%m%d_%H%M%S`";
#sudo mkdir  "/home/openhabian/openhab2-backup-$TIMESTAMP";
#sudo mkdir  "/home/openhabian/openhab2-backup-$TIMESTAMP/influxdb";
#sudo mkdir  "/home/openhabian/openhab2-backup-$TIMESTAMP/grafana";
#bakdir="$HOME/openhab2-backup/$TIMESTAMP";
#mkdir -p "${bakdir}"

# Sample
# $TIMESTAMP -> 20171130_054320
# search and replace it via editor

echo "+-+-+-+-+-+-+ OH restore +-+-+-+-+-+-+-+-+-+-+"
#cp -arv /etc/openhab2 "${bakdir}/conf"
#cp -arv /var/lib/openhab2 "${bakdir}/userdata"
#find /var/lib/openhab2 \( -path /var/lib/openhab2/tmp -prune -o -path /var/lib/openhab2/cache -prune \) -o -name '*' -exec cp -arv {} "${bakdir}/userdata"  \;
sudo cp -arv "/home/openhabian/openhab2-backup-$TIMESTAMP/conf" "/etc/openhab2";
sudo cp -arv "/home/openhabian/openhab2-backup-$TIMESTAMP/userdata" "/var/lib/openhab2";

echo "+-+-+-+-+-+-+ Grafana backup +-+-+-+-+-+-+-+-+"
sudo systemctl stop grafana-server
sudo cp -arv "/home/openhabian/openhab2-backup-$TIMESTAMP/grafana/grafana.ini" "/etc/grafana/grafana.ini";
sudo cp -arv "/home/openhabian/openhab2-backup-$TIMESTAMP/grafana/grafana.db" "/var/lib/grafana/grafana.db";

# https://docs.influxdata.com/influxdb/v1.3/administration/backup_and_restore/
echo "+-+-+-+-+-+-+ Influxdb backup +-+-+-+-+-+-+-+"

service influxdb stop

sudo cp -arv "/home/openhabian/openhab2-backup-$TIMESTAMP/influxdb/influxdb.conf" "/etc/influxdb/influxdb.conf"
sudo influxd restore -metadir /var/lib/influxdb/meta "/home/openhabian/openhab2-backup-$TIMESTAMP/influxdb/metastore/"
sudo influxd restore -database openhab_db -datadir /var/lib/influxdb/data "/home/openhabian/openhab2-backup-$TIMESTAMP/influxdb/db/"

service influxdb start

# restart openhab instance
echo "+-+-+-+-+-+-+ Starting service...+-+-+-+-+-+-+-+-+"
sudo systemctl start openhab2.service
sudo systemctl start grafana-server

#echo "+-+-+-+-+-+-+ Clear cache and tmp folder +-+-+-+-+-+-+-+-+"
#sudo rm -rf "/home/openhabian/openhab2-backup-$TIMESTAMP/userdata/cache"
#sudo rm -rf "/home/openhabian/openhab2-backup-$TIMESTAMP/userdata/tmp"

# Packen
#echo "+-+-+-+-+-+-+ Pack Backup Folder into tar.gz +-+-+-+-+-+-+-+-+"
#tar cfvz /home/openhabian/openhab2-backup-$TIMESTAMP.tar.gz /home/openhabian/openhab2-backup-$TIMESTAMP

# Entpacken-> tar xfvz archiv.tar.gz

# Folder size
# sudo ls -1d */ | sudo xargs -I{} du {} -sh && sudo du -sh
#sudo df -h /home/openhabian/; sudo du -sh -- /home/openhabian/*


