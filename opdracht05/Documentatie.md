# Documentatie opdracht 5: Backup server

1. Opzetten van 2 linux machines
2. Programma's & scripts
3. shell script om backup te maken
4. Schedule backups met cron


## 1. Opzetten van 2 linux machines

Wij gaan gebruikmaken van een testomgeving met vagrant: Een linux systeem dat dient als webserver en een linux systeem als backupserver.


## 2. Programma's & scripts

Hier testen we de nodige programma's en scripts om onze backups te nemen.

### Rsync

De 2 servers moeten bestanden kunnen doorsturen via rsync over ssh

* webserver:  

installeer Rsync  op de webserver en maak de directory data:

    sudo yum install -y rsync

    sudo mkdir /home/data

ssh keygen genereren in een commando.  

    ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""

kopieer public sshkey naar andere machine

    ssh-copy-id -i /root/.ssh/id_rsa.pub IPADRESSBACKUPSERVER

Zoek config.ssh.insert_key in vagrantfile en verander naar true, voeg ook de 2 bovenstaande lijntjes toe

    config.ssh.username = 'root'
    config.ssh.password = 'vagrant'
    config.ssh.insert_key = true

rsync over ssh zonder passwoord:

    ssh IPADRESS

* backupserver:  

Installeer Rsync en maak een Backup folder op de backupserver

    sudo yum install -y rsync

    sudo mkdir /home/Backupfolder

Op backupserver, om schrijfpermissies toe te laten wanneer niet root:

    sudo chmod 777 /home/Backupfolder


### Backup van databank

Met dit commando dumpen we de databank van drupal in het bestand "dump.sql" in de map /home/data

    sudo mysqldump -u root -ptest demodb -r /home/data/dump.sql

### Archiveren databank

we archiveren de laatste dump van de databank in een .bz2 bestand en stoppen de huidige datum in de bestandsnaam.

    tar -jcvf /home/data/backup-$(date +%Y-%m-%d).tar.bz2 /home/data/dump.sql

De redenen waarom archiveren een goed idee is:  
* minder opslagruimte
* ordelijk met datum in bestandsnaam
* alles naar één bestand omvormen om met rsync te verzenden

Belangrijk! Onderstaand lijntje code laten werken zonder wachtwoord vereiste

    sudo rsync -azvr /home/data/backup-2019-05-13.tar.bz2 -e ssh root@192.168.10.4:/home/Backupfolder


## 3. shell script om backup te maken

* applicatie ledendatabank -> backupserver  


Maak "backupWebserver.sh"  in /vagrant/provisioning :

    sudo mysqldump -u root -ptest demodb -r /home/data/dump.sql  
    tar -jcvf /home/data/backup-$(date +%Y-%m-%d).tar.bz2 /home/data/dump.sql  
    sudo rsync -azvr /home/data/backup-$(date +%Y-%m-%d).tar.bz2 -e ssh root@192.168.10.4:/home/Backupfolder

* klant slaat nieuw lesmateriaal op op backupserver -> publiceren == synchroniseren met webserver  

Op Webserver:

    mkdir /home/data/Lesmateriaal
    sudo chmod 777 /home/data/Lesmateriaal

op BackupServer:

    mkdir /home/Lesmateriaal

ssh keygen genereren in een commando.  

    ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""

kopieer public sshkey naar andere machine

    ssh-copy-id -i /root/.ssh/id_rsa.pub IPADRESSWEBSERVER

Volgende commando wordt gebruikt om het lesmateriaal te syncen, we stoppen dit ook in een scriptje in /vagrant/provisioning/sync.sh

    rsync -azvr /home/Lesmateriaal -e ssh root@192.168.10.3:/home/data

## 4. Schedule backups met cron

Eerst en vooral voor we schedulen, is het natuurlijk aangeraden om ervoor te zorgen dat de tijd juist wordt weergegeven op uw systeem, doe op de WebServer volgende commando's:

    mv /etc/localtime /etc/localtime.backup
    ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime

hierin plaatsen we ons sync.sh script. Vervolgens openen we de cron configuration:  

    crontab -e

Voeg een schedule toe voor ons sync.sh script:
volgorde: minute hour DayOfMonth month dayOfWeek command

    0 6 * * 1 /vagrant/provisioning/backupWebserver.sh

Dus bovenstaand lijntje in de cron config betekent een uitvoering van sync.sh elke maandag om 6:00





## Bronnen

* http://www.aupcgroup.com/blog/index.php?/archives/6-Backup-your-web-server-with-rsync,-mysqldump-and-tar.html

* https://www.jordanvanbergen.nl/post/170153757314/how-to-setup-rsync-without-password-using-ssh-on?fbclid=IwAR16kD4Z5eb2iFjnr2alHJ5dd0gLkKUrX9YOmUlSJAFqp_TzDG1DuUE8eiA

* https://www.unixmen.com/synchronize-files-directories-across-systems-using-rsync/






