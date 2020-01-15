# Documentatie WISA

Deze documentatie bestaat uit 2 delen:  
1) smartstore website up & running krijgen adhv WISA server
2) documentatie en toelichting van de scripts

# Smartstore website up & running krijgen adhv WISA server


## VM's aanmaken
We voegen VM's toe in het "vagrant-hosts.yml" bestand (dit staat in dezelfde folder als de "provisioning"-folder)  
We geven de server een naam en ip in de provisioning folder (name: srvWISA
  ip: 192.168.56.31)
De boxfile kan meegegeven worden aan de hand van "box:PATH", indien dit niet gedaan wordt, gebruiken we de standaard boxfile in de vagrantfile: 

    DEFAULT_BASE_BOX = 'PATH'

Wij gebruiken Windows 16 server met SQL Server 14 al reeds meegeleverd. Deze werd ons aangeraden door Deheer Van Vreckem. Deze box viel gemakkelijk af te halen van de FTP-server van HoGent als volgt: connecteer in het netwerk-lokaal met het bekabeld netwerk en surf naar:

http://netlabfs/public/mirror/vagrant/

Alvorens de server up te brengen en de scripts te runnen, moet er voor gezorgd worden dat de website files in de juiste folder staan.  Wij maken gebruik van een opensource web store genaamd "SmartStore".
Zorg er voor dat de website files onder een map "SmartStore" staan in de resources-directory. De files vallen te bemachtingen door volgende link te downloaden en unzippen:

 https://github.com/smartstoreag/SmartStoreNET/releases/download/3.1.5/SmartStoreNET.WebPI.3.1.5.zip

Om de virtuele machine op te starten: In powershell, ga naar de directory met de "vagrantfile" in powershell en typ: 

    vagrant up

Eenmaal de virtuale machine runt, kunnen de scripts opnieuw uitgevoerd worden zonder de vm te hoeven rebooten (na bijvoorbeeld eventuele aanpassingen van de scripts) aan de hand van:

    vagrant provision

## Manueel deel : SmartStore

Na het succesvol runnen van de scripts op onze vm, moeten er nog een paar manuele stappen uitgevoerd worden alvorens de webstore bezocht kan worden:

Surf naar *ip-adres server*/install en volg volgende stappen / screenshots.  
### Store information (password root)

![alt text](Documentatie_Images/Image1.png "img1")

### Database information

![alt text](Documentatie_Images/Image2.png "img2")

### Options + create sample data

![alt text](Documentatie_Images/Image3.png "img3")

Na het succesvol volgen van deze stappen, valt de smartstore website te bezoeken, door het IP-adres van de server in te geven in de browser, in ons geval is dit:

    192.168.56.31


# Documentatie en toelichting van de scripts

## WISA stack

### Installing IIS 

    Install-windowsFeature -name Web-Server -includemanagementTools
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    $IISFeatures = "Web-App-Dev", "Web-Asp-Net45", "Web-Net-Ext45", "Web-ISAPI-Ext", "Web-ISAPI-Filter", "Web-Http-Redirect"
    Install-WindowsFeature -Name $IISFeatures

Webadministration module is een module voor powershell commando's met betrekking tot IIS.

    import-module webadministration

Default IIS website verwijderen

    Stop-WebSite 'Default Web Site'
    Remove-Website 'Default Web Site'

### Installatie Chocolatey
Chocolatey is a package manager voor windows. We gebruiken dit om automatisch installeren van software te vergemakkelijken.

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

### Installatie webdeploy for IIS
Web Deploy (msdeploy) versimpelt deployment van web applicaties en websites op IIS servers. We installeren dit adh chocolatey.

    choco install webdeploy -y

### Installatie van SQL server 2017
    Install SQL Server 2017 Express
    choco install sql-server-express -y

### Installatie server manager

    Import-Module ServerManager
    Add-WindowsFeature Web-Scripting-Tools
    set-executionpolicy unrestricted
    Import-Module WebAdministration           #eigenlijk al eens geimport

    $SiteAppPool = ".NET v4.5"                  
    $SiteName = "demosite"                      

    New-WebSite -Name $SiteName -Port 80 -PhysicalPath "C:\inetpub\wwwroot"

## Add opensource website (SmartStore)

Hier bepalen we de map waar de website files terecht komen en waarnaar ze gekopieerd worden in de VM 

    [string]$sourceDirectory  = "C:\vagrant\resources\SmartStore\*"
    [string]$destinationDirectory = "C:\inetpub\wwwroot"
    Copy-item -Force -Recurse -Verbose $sourceDirectory -Destination $destinationDirectory

Voeg schrijf permissies toe voor de site root folder

    $sharepath = "C:\inetpub\wwwroot\smartstore.net"
    $Acl = Get-ACL $SharePath
    $AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("everyone","FullControl","ContainerInherit,Objectinherit","none","Allow")
    $Acl.AddAccessRule($AccessRule)
    Set-Acl $SharePath $Acl

Bij IIS de ApplicationPool Identity aanpassen naar "LocalSystem" voor een connectie te maken met SQL via de windows preset.

    $pool = Get-Item IIS:\AppPools\DefaultAppPool
    $pool.processModel.identityType = "LocalSystem"
    $pool | set-item


### Gebruikte links / referenties  
IIS installeren: https://www.solvps.com/blog/installing-iis-powershell-windows-vps/  
Sql server installen: https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-2017   
Chocolatey: https://chocolatey.org/  
Opensource website: http://docs.smartstore.com/  
IIS forums: https://forums.iis.net/  
ASP.NET forums: https://forums.asp.net/  
Forum: https://superuser.com/  
mRemoteNG (remote connection manager):https://mremoteng.org/  



