# Testrapport voor installatie (2) 

## 2.1 Basic configs

## 2.2 VLANs

## 2.3 Dynamische IPs

    Testen basic config, vlans en dynamische ip's.  
    Verbind een apparaat via vlan 10 en een apparaat via vlan 20, bekijk of de automatisch toegewezen ip adressen overeenkomen met de voorziene pools en test of deze apparaten elkaar kunnen pingen.  

    Voorbeeld apparaat vlan 10 (ip adres = 192.168.0.1) pingt apparaat van vlan 20:  

        ping 192.168.0.34

Als we vanaf eender welk apparaat uit vlan 10 (Kantoor), proberen pingen naar "192.168.0.34" (= apparaat uit vlan 20/bezoeker VLAN), krijgen we "Requested timed out".
Dit is normaal en toont aan dat beide vlans zich in een ander (virtueel) netwerk bevinden. Test is dus geslaagd.

## 2.4 Internetverbinding  
        
            int g 0/0/1
            ip address dhcp

        Bij onze klant maken we gebruik van een vast IP adres.

        Probeer een website van het internet te pingen met een apparaat op vlan 10 alsook met een apparaat op vlan 20.

            ping 1.1.1.1

Pingen naar de Website (1.1.1.1) van eender welk apparaat (uit zowel vlan 10 als vlan 20) lukt. Test is dus geslaagd.

## 2.5 Security

    Vanaf het toepassen van de ACL lijst, mag pingen tussen vlan 10 en vlan 20 niet meer mogelijk zijn.  
    Test dit door een apparaat aan te sluiten op respectievelijk vlan 10 en vlan 20 en naar elkaar te proberen pingen.  
    Het resultaat moet zijn: "host is unreachable.

Na het toevoegen van de ACL, waarbij de apparaten uit VLAN 20 (bezoekers VLAN) zijn uitgesloten, kunnen we vanuit vlan 20 niet meer pingen naar vlan 10 en krijgen we "Destination host unreachable". Test is dus geslaagd.

## 2.6 VOIP

    In packet tracer kunnen we de VOIP phones daadwerkelijk testen door middel van het nummer van een andere in te geven en dan de telefoon "op te nemen"

Het bellen van 1010 naar 1020 en omgekeerd lukt. Test dus geslaagd.

## 2.7 Startup configs

    Bij de fysieke opstelling overschrijven we de startup configs niet, dit op vraag van de docenten, dus hier testen we ook niets.  

    In packet tracer kunnen we de startupconfig controleren door de devices eens af te zetten en terug op te starten. Vervolgens controleren we of alles nog correct werkt.

 Bij het afzetten en heropstarten van de apparaten (Switch, router enz.), zien we dat alles nog correct werkt. Test dus geslaagd.














