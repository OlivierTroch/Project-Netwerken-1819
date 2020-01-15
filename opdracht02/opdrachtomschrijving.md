# Opdracht 2: Automatiseren opzetten servers

Deadline: Week 7

## Opdrachtomschrijving: Webapplicatieservers

Verschillende klanten vragen ons om hun **webapplicatie** te hosten. Tot nu toe hebben we altijd manueel een server opgezet waarbij de nodige software geïnstalleerd en geconfigureerd werd. Door de groeiende vraag is dit niet houdbaar. De bedoeling is een soort "sjabloon" uit te werken zodat we veel sneller een nieuwe server kunnen opzetten die meteen geconfigureerd is om een applicatie op te draaien. Om het voor een webapplicatie-ontwikkelaar eenvoudiger te maken om op haar/zijn eigen laptop een **testomgeving** op te zetten, is de eerste stap het creëren van VirtualBox VMs.

We voorzien in eerste instantie de volgende platformen:

- **LAMP stack**: **L**inux (CentOS 7 of Fedora Server) + **A**pache + **M**ariaDB + **P**HP
- **WISA stack**: **W**indows Server 2016 + **I**IS + **S**QLServer + **A**SP.NET

De bedoeling is om servers met *exact dezelfde* configuratie in een **productie-omgeving** te kunnen opzetten. We zijn er echter nog niet uit of we zelf de nodige infrastructuur willen opzetten en onderhouden (*private cloud*), of dit uitbesteden via een Infrastructure as a Service provider (*public cloud*). Public cloud providers die we overwegen zijn [Digital Ocean](https://www.digitalocean.com/) (50$ credits verkrijgbaar via [Github Student Pack](https://education.github.com/pack)), of [Amazon Web Services](https://aws.amazon.com/s/dm/landing-page/start-your-free-trial/) (12 maand gratis trial, maar wel kredietkaart nodig bij activeren).

### Acceptatiecriteria

- Het moet voor een applicatie-ontwikkelaar eenvoudig zijn om een testomgeving op te zetten voor het draaien van een webapplicatie met database-backend.
    - Dit toon je aan door een demo te geven van een webapplicatie die op het platform draait (bv. Drupal op LAMP, of een [open source ASP.NET applicatie](https://www.codeproject.com/Tips/667263/ASP-NET-Open-Source-Projects) op WISA)
- Het opzetten van deze servers moet **exact reproduceerbaar** zijn. Om écht op schaal bruikbaar te zijn, moet je het installatieproces automatiseren. Dat kan door gebruik te maken van een automatiseringstool zoals [Vagrant](http://vagrantup.com/), gecombineerd met een installatiescript (Bash, PowerShell).
- Er is de nodige aandacht besteed aan herbruikbaarheid.
    - De scripts zijn bruikbaar op verschillende types systemen: binnen de VirtualBox testomgeving op je desktop, binnen één van de voorgestelde public/private cloud platformen.
    - Instellingen die specifiek zijn voor een applicatie (bv. database-gebruikersnaam en wachtwoord) zijn configureerbaar. Vermijd dus "hard-coded" data tussen de code, maar gebruik waar mogelijk variabelen.
    - Maak onderscheid tussen het installatiescript voor het *platform* (dat herbruikbaar is) en de webapplicatie zelf (door de gebruiker bepaald)
- Er is een proof-of-concept opgezet met een public cloud platform (hetzij uit de opgegeven providers/producten hetzij een ander na afspraak met de begeleiders) voor minstens één van de types applicatieservers.
- Voorzie documentatie:
    - technische documentatie die alle teamleden en de begeleiders in staat stelt om de omgeving op te zetten zonder hulp te moeten vragen
    - gebruikersdocumentatie voor de klant die uitlegt hoe de omgeving moet geconfigureerd worden om een gekozen webapplicatie op te zetten
