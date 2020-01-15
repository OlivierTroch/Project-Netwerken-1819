# Testplan LAMP
## 1: Variabelen instellen
Pas de config.sh file aan met de gewenste gegevens. (gebruikersnaam, wachtwoord...)

## 2: Server initialiseren
Typ "vagrant up" in powershell in de map met de vagrant file  
-> De scripts runnen volledig automatisch en succesvol, er is geen interactie met de gebruiker

## 3: Bezoek server met browser
Surf met een browser naar het IP-adres van de virtualbox
(in ons geval 192.168.1.35)  
-> We verwachten de drupal pagina

## 4: Check inloggen
Gebruik de ingestelde gegevens uit stap 1 om succesvol in te loggen bij de drupal site. 

## 5: Content toevoegen via Drupal
Ga naar in de browser naar het content-tabblad op de drupal site en voeg content toe.  
Voeg er een comment aan toe in het comment-veld, bv. "Testcomment".  

## 6: Controleer of content is toegevoegd aan databank
maak een ssh verbinding naar de server adhv

    vagrant ssh srvLAMP

Log in bij mysql met het wachtwaard ROOT_PASS , dat ingesteld staat in config.sh

    mysql -u root -p"wachtwoord"

Gebruik de databanknaam NAME_DB, ook ingesteld in config.sh

    use "demodb"

In deze databank selecteren we in dit codevoorbeeld alle records die "Test" bevatten in het comment veld.

    select * from comment__comment_body where comment_body_value like "%Test%" 
    
 In dit resultaat moet je de rij vinden met de comment_body_value die de tekst bevat die je eerder als commentaar meegaf in het comment-veld op de drupal site. (vandaar dat ik records zocht die "Test" bevatten) Indien dit het geval is werkt Drupal correct met mysql.
 

--------------------------
Auteur(s) testplan: Robin