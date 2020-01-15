# Testplan taak 5: Backup Server
## Vm's instellen
Voer "vagrant up" uit om de 2 VM's aan te maken en de basisconfiguratie op te starten. 

## Schedule sync naar BackupServer 
Alvorens te testen, zorg ervoor dat er op de backup-server onder /home/Backupfolder nog geen archief bestand staat met de huidige datum.  
Voer volgend commando uit op de webserver:

    crontab -e

Voeg een schedule toe voor ons sync.sh script: volgorde: minute hour DayOfMonth month dayOfWeek command:        

    0 6 * * 1 /home/scripts/backupWebserver.sh

Dus afhankelijk van het moment waarop je test (vb vandaag, maandag om 14u) moet je dit respectievelijk ingeven als
     
    0 14 * * 1 /home/scripts/backupWebserver.sh

Na dit tijdstip kijk je of de files zijn toegekomen op de BackupServer onder /home/Backupfolder


## Test syncen van lesmateriaal naar WebServer
Vergelijk de twee verschillende lesmateriaal-mappen op de beide servers. Zorg ervoor dat op de backup server meer bestanden staan die kunnen gesynced worden naar de webserver. bv.

    touch newFile.txt

Voer het script sync.sh uit en verifiëer of het is toegekomen op de WebServer onder "/home/data/Lesmateriaal"

Indien dit allemaal lukt dan is de opdracht correct uitgevoerd.



Auteur(s) testplan: Piet Jacobs
Testplan nagelezen door: Robin Boone