# Testplan WISA
## 1: Server init
Typ *vagrant up* in de powershell CLI die je geopend hebt in de map *Testomgeving WISA*. 
Door dit command wordt de server opgestart en wordt *vagrant provision* ook automatisch aangeroepen. Dit zorgt ervoor dat het bijhorende script gerunt wordt. 

## 2: ASP.NET App installatie
Volg de documentatie voor het uitvoeren van de installatie van de .NET applicatie.

## 3: Bezoeken van de server met je browser in je OS
Surf met een browser naar het IP-adres van de virtual box  
(in ons geval 192.168.56.31)

## 4: Testen de database door creatie van een user
Surf met een browser naar het IP-adres van de virtual box en maak een account aan via **sign in**. 

- Name: tester
- Email: tester@test.com
- Pass: test123  

Test de werking van de database door eerst uit te loggen en vervolgens opnieuw in te loggen en toegang te krijgen tot je account.

---------------------------------
Auteur(s) testplan: Olivier Troch