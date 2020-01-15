# Documentatie Microsoft Deployment Toolkit

# Deel 1: Deployment VM klaarmaken voor gebruik
Eerst en vooral moet er een Windows Deployment Server klaargemaakt worden om zo de clients mee te deployen. Ik heb gebruik gemaakt van vagrant om makkelijk een Windows Server 2016 mee te deployen en hier dan verder software op te installeren.

Eens de server draaiende is moet er de nodige software op geïnstalleerd worden, namelijk MDT (Microsoft Deployment Kit) en ADK (Windows Assessment and Deployment Kit). Ik maak hiervoor gebruik van mremoteNG om makkelijk een RDP connectie (Remote Desktop Protocol) met mijn vm te maken.

    ADK als eerste installeren: https://support.microsoft.com/nl-be/help/4027209/oems-adk-download-for-windows-10
    MDT: https://www.microsoft.com/en-us/download/details.aspx?id=54259  


## Deployment share aanmaken
In MDT: "New deployment share" aanduiden, vervolgens "naam geven". We gebruiken de default settings. Met deze deployment share gaan we verder.

## Windows 10 iso downloaden
Nu is het belangrijk om een iso klaar te hebben met de windows 10 installatie. Ik heb de trial versie van W10 Enterprise gedownload.  
Mount de iso, vervolgens in MDT "Import operating system" -> "Full set of source files".  

Indien u een andere versie wilt (Home, Pro...) kan u dit doen als volgt:  
Gebruik makende van de Windows MediaCreationTool  
Het is best dat je dit op je pc zelf doet (niet op de vm) zodanig dat dit en de komende acties nog vrij snel kunnen gaan. Je kan uiteindelijk dan de bekomen files in je shared Vagrant folder steken (of de shared folder die je in virtualbox kan aanmaken) en dan op de vm zelf kopiëren (Het is heel belangrijk dat je dit effectief op de vm zelf kopiëert, dus niet in de shared folder laten zitten).

    https://www.microsoft.com/nl-nl/software-download/windows10

De optie "iso" kiezen

Uit de iso moet je de "boot.wim" file uit de map "sources" kopiëren naar een andere locatie op de machine. Ook hebben we de install.wim nodig,  
maar uit de WindowsMediaCreationTool heb je meerdere versies van Windows beschikbaar, waardoor er een "install.esd" bestaat.  
Om hier een .wim van te maken moet dit bestand ook gekopieerd worden naar een locatie op uw machine, vervolgens in cmd (admin) de volgende command uitvoeren:  

    dism /Get-WimInfo /WimFile:install.esd

Dit geeft een lijst met alle beschikbare versies die je hiermee kan installeren, kies er eentje uit met de respectievelijke index; vul deze index dan in onder "x" in volgende codefragment:

    dism /export-image /SourceImageFile:install.esd /SourceIndex:"x" /DestinationImageFile:install.wim /Compress:max /CheckIntegrity


## Software toevoegen
De installatiefiles downloaden, in Deployment Workbench bij "Applicatitions" een New Application toevoegen -> "Application with source files" -> Een naam geven -> Verwijzen naar de source directory (in mijn geval is dit C:/vagrant)  

Bij elk softwarepakket moet er een installatiescript meegegeven worden
(verander de naam van elk installatiebestand naar de naam die overeenkomt in de code) :

    LibreOffice: msiexec /i LibreOffice_6.2.3_Win_x64.msi /qn /norestart ALLUSERS=1 CREATEDESKTOPLINK=1 (silent)
    Java: java.exe /s (silent)
    Adobe reader: AcroRdrDC1900820071_en_US.exe /msi EULA_ACCEPT=YES /qn /rs (silent + reboot suppress)


# Deel 2: bootable iso creeëren met de gekozen instellingen
## Task sequence aanmaken
Maak een nieuwe task sequence aan met een bepaalde id (01) en naam/omschrijving.

## Drivers downloaden
Ga naar "http://www.catalog.update.microsoft.com/Search.aspx?q=Security%20rollup%20windows%2010" zoek hier de recentste download voor Windows 10 (8.1) en download alle bestanden. Sla deze op onder een specifieke map op de server.  
Onder packages in MDT maak je een nieuwe folder aan met naam "Windows 10", vervolgens doe je hierop "Import OS packages" en importeer je alle bestanden.

## Selection profile
Maak een nieuw selection profile aan (onder Advanced Configuration) en vink alles aan (dit zorgt ervoor dat alles van customization wordt toegepast).

## Create media
Maak nu een nieuwe Media aan en kies de zonet aangemaakte Selection Profile.  
Open de properties van deze Media en hernoem de iso file die dit genereert naar "W10 Pro Installer.iso". Deselecteer ook de x86 optie (we gaan geen machines aanmaken met x86).  

### Extra regels toevoegen

Op de Media001 rechtermuis -> properties; dan onder Rules moet het er zo uitzien (dit is niet noodzakelijk, maar vereenvoudigt het installatieproces):  


    CustomSettings.ini:
    [Settings]
    Priority=Default
    Properties=MyCustomProperty

    [Default]
    OSInstall=YES
    SkipCapture=YES
    SkipAdminPassword=YES
    SkipApplications=NO
    SkipBDDWelcome=YES
    SkipBitLocker=YES
    SkipComputerName=NO
    SkipLocaleSelection=YES
    SkipProductKey=YES
    SkipTaskSequence=NO
    SkipTimeZone=YES
    SkipUserData=YES
    KeyboardLocale=nl-BE
    TimeZoneName=Romance Standard Time
    UILanguage=nl-nl
    UserLocale=nl-nl


### Iso genereren
Opslaan en ten slotte Rechtermuis op MEDIA001 en Update dit.  
Er is nu een nieuwe iso aangemaakt waarmee je de clients mee kan booten. 




Gebruikte bronnen:  
Java (offline Windows): https://www.java.com/nl/download/manual.jsp  
LibreOffice (SDK): https://nl.libreoffice.org/download/libreoffice-fris/  
Adobe Reader: https://get.adobe.com/nl/reader/download/?installer=Reader_DC_2019.008.20071_Dutch_for_Windows&os=Windows%2010&browser_type=KHTML&browser_dist=Chrome&dualoffer=false&mdualoffer=true&stype=7527&d=McAfee_Security_Scan_Plus&d=McAfee_Safe_Connect  