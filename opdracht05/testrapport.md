# Testrapport taak 5: Backup Server

## Vm's instellen
Uitvoeren van "vagrant up" is succesvol want beide servers zijn geinstalleerd en werken.

## Schedule sync naar BackupServer
Ik heb de backupfolder gecontroleerd en deze bevatte geen archief.
Verder heb ik volgend commando uitgevoerd:

    crontab -e

Schedule is toegevoegd, automatische bestandsoverdracht van archiefbestand is voltooid. Door gebruik van dit commando:
     
    30 13 * * 1 /home/scripts/backupWebserver.sh

## Test syncen van lesmateriaal naar WebServer
Tijdens het vergelijken waren beide mappen verschillend. Ik heb het lesmateriaal op de webserver gecontroleerd en deze komt overeen met het lesmateriaal op de backup server.

## Test

Uitvoerder(s) test: Olivier Troch
Uitgevoerd op: 13/05/2019