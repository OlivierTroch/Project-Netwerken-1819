#!/bin/sh

# dump van databank
sudo mysqldump -u root -ptest demodb -r /home/data/dump.sql  
#archiveren
tar -jcvf /home/data/backup-$(date +%Y-%m-%d).tar.bz2 /home/data/dump.sql  
#archief naar backupserver opslaan
sudo rsync -azvr /home/data/backup-$(date +%Y-%m-%d).tar.bz2 -e ssh root@192.168.10.4:/home/Backupfolder
# verwijder archief op webserver zelf
rm /home/data/backup-$(date +%Y-%m-%d).tar.bz2