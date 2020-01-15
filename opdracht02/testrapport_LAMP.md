# Testrapport LAMP
## 1: Variabelen instellen
Ik heb in dit geval geen variabelen aangepast aangezien dit bij het uitvoeren van het testplan geen noodzaak is.

## 2: Server up brengen en automatisch LAMP installeren
Na enkele ogenblikken krijg ik de message **>>> Sucessfully Configured your LAMP Server**

## 3: Bezoek server met browser
Na de installatie, uitgevoerd in stap 2 ga ik via mijn eigen host systeem naar het IP-adres dat ingesteld is in het *Vagrant-hosts.yml* bestand en zo bereik ik de drupal pagina.

## 4: Check inloggen
Inloggen is succesvol, in dit geval waren de gegevens de volgende: 
 - Name: admin
 - Pass: admin

## 5: Content toevoegen via Drupal  
Ik voeg de content toe met als commentaar:  
"Dit is een testcomment".  

## 6: Controleer of content is toegevoegd aan databank
Succesvol verbonden met een SSH verbinding. Verbonden met SQL met mijn passwoord dat ik geconfigureerd heb ik config.sh namelijk "test"  
Databank "demodb" gevonden door het commando (ingesteld in config.sh)  
Mijn toegevoegde content is gevonden als record na uitvoeren van volgende query:  

    select * from comment__comment_body where comment_body_value like "%testcomment%"        

## Test 1
Uitvoerder(s) test: Olivier Troch  
Uitgevoerd op: 24/03/2019  
Puntje 5 & 6 uitgevoerd op 25/03/2019