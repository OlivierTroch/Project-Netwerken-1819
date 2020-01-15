# Testplan voor installatie (2)

Dit testplan volgt de nummering van installatie voor groep 16, zo testen we bijvoorbeeld voor de eerste keer na 2.3 Dynamische IPs.  
Gelieve dit testplan dan ook naast de documentatie te leggen tijdens gebruik.  

## 2.1 Basic configs

## 2.2 VLANs

## 2.3 Dynamische IPs

Testen basic config, vlans en dynamische ip's.  
Verbind een apparaat via vlan 10 en een apparaat via vlan 20, bekijk of de automatisch toegewezen ip adressen overeenkomen met de voorziene pools en test of deze apparaten elkaar kunnen pingen.  

Voorbeeld apparaat vlan 10 (ip adres = 192.168.0.1) pingt apparaat van vlan 20:  

    ping 192.168.0.34

## 2.4 Internetverbinding  

Opgelet! Voor de fysieke opstelling moeten we de router dhcp client maken van de hogent server.
    
    int g 0/0/1
    ip address dhcp

Bij onze klant maken we gebruik van een vast IP adres.

Opmerking !! Bij vaste netwerkopstelling wordt pingen geblokkeerd door het HoGent netwerk.  
Alternatieve testmethode: stel eerst PAT in en surf vervolgens naar een website na het instellen van correcte DNS server.

### PAT / NAT Overload

Probeer een website van het internet te pingen met een apparaat op vlan 10 alsook met een apparaat op vlan 20.

    ping 1.1.1.1

Voor de fysieke opstelling:

    ping google.com

## 2.5 Security

vanaf het toepassen van de ACL lijst, mag pingen tussen vlan 10 en vlan 20 niet meer mogelijk zijn.  
Test dit door een apparaat aan te sluiten op respectievelijk vlan 10 en vlan 20 en naar elkaar te proberen pingen.  
Het resultaat moet zijn: "host is unreachable.

## 2.6 Startup configs

Bij de fysieke opstelling overschrijven we de startup configs niet, dit op vraag van de docenten, dus hier testen we ook niets.  

In packet tracer kunnen we de startupconfig controleren door de devices eens af te zetten en terug op te starten. Vervolgens controleren we of alles nog correct werkt.







