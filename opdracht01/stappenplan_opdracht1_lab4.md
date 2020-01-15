#### nodig
3 laptops, 3 switches, 3 routers, kabels

#### opstelling

geef de switches en routers een hostname S1 R1 ...

verbind S1 met R1 , S2 met R2...

verbind R1 met R2 (serieel, 2x S0/0/0)
verbind R2 met R3 (serieel, 2x S0/0/1)

verdeel de laptop over de switches en verbind deze.
(laptop aan S1 noemen we PC1 , S2 - PC2 etc.)

#### adressen

stel per laptop de juiste IP-instellingen in (zie adressing table)

zet bij de switches de juiste poorten up

stel bij de routers de ip adressen in op de poorten, volgens de adressentabel
bv:

    interface f0/0
    ip address 172.16.3 255.255.255.0

bij de routers de geconnecteerde poorten op up zetten.

controleer of elke PC, naar zijn bijhorende router kan pingen.

#### stel de static routes in

R2 (next hop, exit interface)

    ip route 192.168.2.0 255.255.255.0 192.168.1.1
    ip route 172.16.3.0 255.255.255.0 s0/0/0
R1 (default static route)
   
    ip route 0.0.0.0 0.0.0.0 172.16.2.2
R3 (summary route)
   
    ip route 172.16.0.0 255.255.252.0 192.168.1.2


#### testen
zet de firewalls op de laptops uit
test de connecties tussen de laptops (**ping**)


