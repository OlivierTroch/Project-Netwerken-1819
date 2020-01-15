1. Netwerk  
1.1 VLAN kantoor  
1.2 VLAN bezoekers  
2. Installatie  
2.1 Basic configs  
2.2 VLANs  
2.3 Dynamische IPs  
2.4 Internetverbinding  
2.5 Security
2.6 VOIP
2.7 Startup configs
  


# 1. Netwerk
Onze allereerste stap is denken over het netwerk en de addressering. We gaan het netwerk opdelen in 2 VLANs: kantoor en bezoekers. Dit is om ordelijker en ook veiliger om de bezoekers in een andere LAN te stoppen.Zo kan je via de bezoekers VLAN niet zomaar met de printer of chromecast verbinden.  

We gaan gebruik maken van privé IP adressen. We praten over maar een klein aantal ip-adressen, dus we maken gebruik van: 192.168.0.0 /16.

## 1.1 VLAN kantoor
Er werd door de studenten vastgoed (groep 16) gesproken over:  
* 8 plaatsen in de vergaderzaal (we rekenen hiervoor 8 laptops extra)
* 3 gsm's werknemers
* 1 telefoon
* 3 laptops
* 1 printer
* 1 chromecast

Voor beide groepen komt dit neer op 16 devices (telefoon krijgt z'n eigen VLAN)die een ip-adres wensen. Bij dit getal tellen we nog eens 2 bij op voor het netwerk en het broadcast adres en dan nog eens eentje voor de interface van de router.  

Zo komen we op een nood aan minstens 19 ip-adressen. Vervolgens zoeken we de kleinste macht van twee die aan deze vereiste voldoet; en dat is 5:  

=> 2^5 = 32 && 32 > 19  

Zo kiezen we volgende range voor ons kantoor-VLAN:  
192.168.0.0 (/27)  
192.168.0.0 255.255.255.224  
192.168.0.0 -> 192.168.0.31

## 1.2 VLAN bezoekers

zowel groep 2 als 16:  
* 8 devices (gsm / laptop) tegelijk  

Voor beide groepen rekenen we dat er max tegelijkertijd 8 devices met het internet willen verbinden. Bij dit getal tellen we nog 'ns 2 adressen op voor het netwerk en broadcast adres van de vlan en dan nog eentje voor de interface van de router.  

Zo komen we op een nood aan 11 ip-adressen. Na het zoeken van de kleinste macht van twee die hieraan voldoet:

=> 2^4 = 16 && 16 > 11  

Zo kiezen we volgende range voor ons bezoekers-VLAN:  
192.168.0.32 (/28)  
192.168.0.32 255.255.255.240  
192.168.0.32 -> 192.168.0.47

# 2. Installatie

## 2.1 Basic configs
### Router basic config

    hostname RouterKantoor

We stellen wachtwoord in om in de privileged mode van de router te geraken, alsook voor connectie via de console poort. We stellen bewust geen VTY lijnen in omdat dit een klein bedrijf is met slechts 1 router en 1 switch.

    enable secret G08sys

    line con 0
    password G08sys
    login

passwoorden ge-encrypteerd opslaan:

    service password-encryption



### Switch basic config

    hostname RouterKantoor

We stellen wachtwoord in om in de privileged mode van de switch te geraken, alsook voor connectie via de console poort. We stellen bewust geen VTY lijnen in omdat dit een klein bedrijf is met slechts 1 router en 1 switch.

    enable secret G08sys

    line con 0
    password G08sys
    login

passwoorden ge-encrypteerd opslaan:

    service password-encryption

### Access point basic config

SSID's instellen (wifi naam):  

ImmoSea_Intern  
ImmoSea_Bezoekers

## 2.2 VLANs
configuratie op switch:  
kantoor:

    vlan 10
    name kantoor
    end

bezoekers

    vlan 20
    name bezoekers
    end

native
    vlan 99
    name native


interfaces

    interface fa 0/24
    switchport mode access
    switchport access vlan 20
    no shutdown

    interface range fa 0/1-23
    switchport mode access
    switchport access vlan 10
    no shutdown

    interface g 0/1
    switchport mode trunk
    switchport  trunk allowed vlan 10,20
    no shutdown

router configureren voor vlans (router on a stick)  
we nemen telkens eerste ip adres beschikbaar van de vlan voor de interface van de router

    interface f 0/0.10
    encapsulation dot1q 10
    ip address 192.168.0.1 255.255.255.224
    no shutdown

    interface f 0/0.20
    encapsulation dot1q 20
    ip address 192.168.0.33 255.255.255.240
    no shutdown

    int f0/0
    no shutdown

We stelden geen native VLAN in, alle poorten van de enkele switch zitten in het netwerk en de adressen zullen correct uitgedeeld worden via dhcp.  
Voor een grote organisatie is het wel aangeraden om de grootste VLAN native te maken en op G0/0 te zetten, dit zou CPU last verkleinen omdat verkeer van deze VLAN dan untagged is. 

## 2.3 Dynamische IPs
Elke VLAN heeft z'n eigen dhcp pool

op de KantoorRouter:  
excludeer addressen voor netwerk devices
pool een naam geven
address pool instellen
default-gateway router instellen

    ip dhcp excluded-address 192.168.0.1
    ip dhcp pool ImmoKantoorPool
    network 192.168.0.0 255.255.255.224
    default-router 192.168.0.1

    ip dhcp excluded-address 192.168.0.33
    ip dhcp pool ImmoBezoekersPool
    network 192.168.0.32 255.255.255.240
    default-router 192.168.0.33


## 2.4 Internetverbinding
Om te testen maken we gebruik van een fictieve internetservice provider met de range 1.0.0.0 /8 .
Van deze ISP hebben we het vaste ip-adres 1.7.7.7 toegewezen gekregen.

vlugge config enkel om te testen:
website ip = 1.1.1.1
ISP router:  

    interface g 0/0
    ip address 1.7.0.1 255.255.0.0
    no shutdown
    int g 0/1
    ip address 1.1.0.1 255.255.0.0
    no shutdown

onze router (hier wordt voorbeeld ip-adres gebruikt):

    int g0/1
    ip address 1.7.7.7 255.255.255.0
    no shutdown


default static route op onze router naar het internet  
(als een bepaald netwerk niet in z'n lijst staat, stuurt de router het ip-pakket buiten via g0/1)

    ip route 0.0.0.0 0.0.0.0 g0/1


### PAT / NAT Overload
We willen de router gebruiken om met onze internet ip-adressen toch het internet te kunnen bereiken, daarom passen we Port Address Translation toe. Bij connecties buiten ons netwerk gebruikt de router ons vast ip adres samen met een poortnummer om te identificeren welk uniek intern adres gebruikt werd.

op de KantoorRouter:  

maak access-list met de adressen die vertaald worden naar buiten

    access-list 1 permit 192.168.0.0 0.0.0.255

geef de lijst met adressen aan de binnenkant en de outside interface (normaal pool, maar hier enkel 1 adres, dus interface genoeg) aan de buitenkant mee

    ip nat inside source list 1 int f0/1 overload

    interface f0/1
    ip nat outside

    interface f0/0.10
    ip nat inside

    interface f0/0.20
    ip nat inside



## 2.5 Security

op de KantoorRouter:  
bezoekers toegang tot VLAN 10 (kantoor) ontzeggen adhv volgende access-list:

    access-list 10 deny 192.168.0.32 0.0.0.15
    access-list 10 permit any

    int f0/0.10
    ip access-group 10 out

### Wifi wachtwoorden

ImmoSea_Bezoekers:  
psk passphrase: Immosea1

ImmoSea_Intern
psk passphrase: HDPTAp6Jmr3c6QRb

## 2.6 VOIP

Het is nodig om een router te gebruiken die Voip ondersteund, wij maken in deze PacketTracer gebruik van een 2811.  

maximum uitbreiding van telefoons: 1 onthaal + 1 per werknemer = 3. Extra ip-adressen nodig: 2 voor netwerk en broadcastadres + 1 voor router interface.  

= 7 => 2^3 = 8 

192.168.0.48 /29  
192.168.0.48 255.255.255.248    
192.168.0.48 -> 192.168.0.55

Sluit de telefoon aan op het elektriciteitsnetwerk met z'n powercable.  

op switch: voice vlan:

    vlan 150
    name voice

enable QoS op de switch:

    mls qos

Op alle kantoor interfaces van de switch zorgen we dat ip phones aansluitbaar zijn:

    interface range fa 0/1 - 23
    switchport mode access
    switchport voice vlan 150
    mls qos trust cos
    no shutdown

voeg de voice vlan toe bij het trunken

    interface g 0/1
    switchport mode trunk
    switchport  trunk allowed vlan 10,20,150
    no shutdown

op de KantoorRouter:  
subinterface voor voice vlan.

    interface f 0/0.150
    encapsulation dot1q 150
    ip address 192.168.0.49 255.255.255.248
    no shutdown
    
dhcp voor vlan 150

    ip dhcp excluded-address 192.168.0.49
    ip dhcp pool ImmoVoicePool
    network 192.168.0.48 255.255.255.248
    default-router 192.168.0.49
    option 150 ip 192.168.0.49

max directory nummer en max ephones instellen
    telephony-service
    max-dn ~~
    max-ephones ~~
    ip source-address 192.168.0.49 port 2000

    ephone-dn 1
    number 1010

    ephone 1
    type 7960
    button 1:1


 Telefoon instellen om bellen te testen
    ephone-dn 2
    number 1020
    
    ephone 2
    type 7960
    button 1:2

## 2.7 Startup configs

Sla op zowel de router als de switch de running-config op als startup-config:  

    copy running-config startup-config














