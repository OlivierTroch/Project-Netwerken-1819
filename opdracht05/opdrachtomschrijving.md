# Opdracht 5: Backup server

Op vraag van VZW Taijitan Yoshin Ryu (http://jiu-jitsu-gent.be/) zullen studenten van HOGENT een webapplicatie ontwikkelen voor het bijhouden van de ledenadministratie en voor het beschikbaar maken van multimediaal lesmateriaal (beschrijvingen van oefeningen, afbeeldingen, video, enz.). De applicatie zelf zal worden geschreven door de studenten van het keuzevak programmeren en gehost op een webserver. De klant wil ook een backup-server, en aangezien dit eerder systeembeheertaak is, wordt dit jullie opdracht.

Deze server blijft in beheer van de klant en staat bij hem thuis. Dit is dus geen VPS of server in de cloud, maar eerder een NAS. De uiteindelijke vorm en functionaliteit van deze server ligt nog niet 100% vast. De klant heeft enkele ideeën van de gewenste functionaliteit, maar hoe dit in de praktijk zal/kan uitgewerkt worden is nog niet duidelijk. Jullie taak is om enkele proof-of-concepts op te zetten die aantonen dat het idee realiseerbaar is.

## Basisfunctionaliteit: synchronisatie ledendatabank en lesmateriaal

* De beheerder wil op regelmatige tijdstippen een synchronisatie kunnen uitvoeren tussen de webapplicatie en de backup-server:
    * Backup van de ledendatabank van de webaplicatieserver naar de backup-server.
    * Op de backup-server worden in principe nooit wijzigingen aangebracht in de ledendatabank, dat gebeurt enkel in de applicatie. Synchroniseren gebeurt dus in één richting.
    * De beheerder bereidt regelmatig nieuw lesmateriaal voor en slaat dit op op de backup-server. Als dit klaar is voor publicatie, dan moet dit gesynchroniseerd worden met de webapplicatieserver. Op de webapplicatieserver zullen geen wijzigingen gemaakt worden, dus ook hier gebeurt de synchronisatie in één richting.
* Bepalen *hoe* de synchronisatie precies zal verlopen moet gebeuren in onderling overleg met de begeleiders en de programmeurs.
    * Welke database wordt gebruikt in de applicatie? MySQL/MariaDB, SQLite, ...? Kan je die ook installeren op de backup-server? Hoe kan je data synchroniseren tussen de applicatieserver en de backup-server?
    * Op welke manier wordt het lesmateriaal beschikbaar gemaakt voor de leden en hoe ga je controleren welke bestanden gewijzigd zijn en naar de applicatieserver gekopieerd moeten worden? Kijk bv. naar rsync, sftp, ...
    * Behalve het opstarten van het synchronisatieproces is er van de gebruiker geen enkele interactie nodig en gebeurt alles automatisch via een script. Als er iets misloopt met het proces, dan moet het voor de gebruiker mogelijk zijn om de oorzaak te achterhalen en dit op te lossen.
* Gebruik de LAMP-server uit opdracht 2 om de webapplicatieserver te simuleren.
    * Pas waar nodig de installatie-scripts aan aan deze opdracht
    * Indien mogelijk kan je ook contact opnemen met een team programmeurs om een demo-versie van hun applicatie te bekomen en die op jullie server te installeren. Probeer in elk geval de configuratie van de webapplicatieserver af te stemmen op hoe die er in de praktijk zal uitzien.

## Uitbreiding: toegang tot lesmateriaal over het Internet

* De beheerder wil leden van thuis uit toegang geven tot het lesmateriaal op de backup-server. Zij melden zich aan met hun gebruikersnaam en wachtwoord, zoals die in de ledendatabank is geregistreerd, en kunnen het lesmateriaal specifiek voor hun niveau (= kleur gordel) bekijken, maar niet het lesmateriaal voor hogere niveaus. Videos worden niet gedownload, maar getoond via streaming. Probeer een schatting te maken van de maandelijkse netwerktrafiek die dit systeem zou gebruiken, zodat de klant een kostenraming kan maken.
* Hoe ga je de bestanden op een gebruiksvriendelijke manier toegankelijk maken voor de gebruikers? Een voor de hand liggende keuze is via een webserver (bv Apache). Hoe ga je authenticatie implementeren?
    * Kan je authenticatie rechtstreeks koppelen aan de ledendatabank? Hoe zal authenticatie in de webapplicatie gebeuren en hoe worden wachtwoorden opgeslagen?
    * Bestudeer de werking van `.htaccess`. Is het eventueel mogelijk om `.htaccess`-bestanden te genereren vanuit de ledendatabank?
* Voor deze functionaliteit zijn geen extra manuele handelingen nodig om dit te onderhouden. Alle nodige configuratiewijzigingen (bv. nieuwe leden, gewijzigde wachtwoorden, wijzigingen in toegangsrechten, ...) worden via het synchronisatiescript uitgevoerd.

## Niet-functionele requirements

* Gebruik in eerste instantie een VirtualBox VM met Linux om het proof-of-concept op te zetten. Automatiseer de installatie en configuratie met Vagrant en scripts.
* De klant heeft een NAS die hij wil gebruiken om de servercomponent van de applicatie op de draaien, meer bepaald een Iomega StorCenter ix2.
    * Is de functionaliteit van dat toestel voldoende om de gevraagde functionaliteit op te implementeren? Op NAS-systemen draait typisch Linux en sommige modellen laten toe om er applicaties (databank, webserver, enz) op te installeren of in te loggen op de Bash shell.
* De klant staat ook open voor andere hardware als de NAS onvoldoende functionaliteit heeft om jullie oplossing te realiseren. Ga in dat geval op zoek naar een geschikt apparaat en maak een prijsschatting. Dat kan een NAS zijn met meer functionaliteit (kijk in de eerste plaats naar Synology of QNAP), een mini-pc met Linux, enz. Requirements:
    * De nodige serversoftware (bv. database, webserver, fileserver, ...) en scripts moet kunnen geïnstalleerd worden op dit apparaat
    * Er moet voldoende schijfcapaciteit voorzien worden voor het huidige materiaal en het materiaal dat in de toekomst nog zal ontwikkeld worden
* Alle nodige nodige scripts en duidelijke documentatie voor het installeren en configureren van de server wordt opgeleverd aan de klant. Die moet in staat zijn om aan de hand daarvan de backup-server opnieuw "from scratch" op te zetten.

## Acceptatiecriteria

- Er is een proof-of-concept opgezet die de werking van de backup-server demonstreert, die bestaat uit:
    - Een VM voor de backup-server
    - Een VM voor een mock-up van de applicatieserver
- Bij oplevering moeten jullie aan de hand van een demo minstens kunnen aantonen dat de basisfunctionaliteit (zoals hierboven beschreven) werkt. Met andere woorden, maak een wijziging in het lesmateriaal en in het ledenbestand, en voer de synchronisatie uit. Optioneel tonen jullie ook de werking van de voorgestelde uitbreiding aan.
- Tenslotte doen jullie ook een aanbeveling voor hoe de functionaliteit op de NAS van de klant kan geïnstalleerd worden, of -als dat om de ene of de andere reden niet mogelijk is- welke hardware eventueel kan aangekocht worden als alternatief (specificaties + kostenraming).
- Voorzie de nodige technische en gebruikersdocumentatie

