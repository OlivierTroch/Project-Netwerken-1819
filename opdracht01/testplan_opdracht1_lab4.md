# Testplan Opdracht 1 - Lab 4

## Part 1 : Router Configuration
#### privileged EXEC paswoord = "grp8" 
  
gebruik **enable** en log in met "grp8"  
(console paswoord is "grp8con" indien nodig)

#### hostname, no interaction with dns servers 

gebruik **show running-config** en controleer of de hostname respectievelijk R1,R2 of R3 is.  
check ook de aanwezigheid van de lijn "no ip domain-lookup"

#### verify console and virtual terminal lines configuration:

gebruik **show running-config** 

line vty 0 4  
password grp8vty  
login  
logging synchronous  
exec­timeout 0 0

line con 0  
password grp8con  
login  
logging synchronous  
exec-timeout 0 0    

## Part 2  : ip addresses

#### check PC's ip address, subnet mask, default gateway
Vergelijk met de addressing-table in de opgave pdf  
kijk in de ip configuration of gebruik **ip config** in command prompt

#### check router interface ip addresses & subnet masks
Opmerking: wij gebruiken S2/0 ipv S0/0/0 en S3/0 ipv S0/0/1  
Gebruik **show running-config** & vergelijk weer met de addressing-tabel uit de pdf.  
Controleer ook dat per seriële connectie 1 poort een clock rate heeft ingesteld van 64000

## Part 3  : static routing

#### check different static routes

Gebruik **show ip route** om de router tabel te tonen.  
Controleer dat R1 een default static route gebruikt (0.0.0.0 /0)
Controleer dat R2 static routes heeft gebruikmakende van zowel het next-hop adres als de exit interface.  
Controleer dat R3 slechts 1 (summary) static route gebruikt om de verschillende subnetwerken te bereiken, namelijk:  
172.16.0.0 255.255.252.0  
(gebruik eventueel **show running-config** om de gebruikte commando's te bekijken)

## Part 4  : check connectivity

Gebruik **ping *ip-addres*** in command promt van de pc's om zo te controleren dat elke pc in deze opstelling met elkaar kan communiceren.




