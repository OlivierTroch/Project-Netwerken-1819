#Installation IIS
echo "Installing IIS"
Install-windowsFeature -name Web-Server -includemanagementTools
Set-ExecutionPolicy Bypass -Scope Process -Force;
$IISFeatures = "Web-App-Dev", "Web-Asp-Net45", "Web-Net-Ext45", "Web-ISAPI-Ext", "Web-ISAPI-Filter", "Web-Http-Redirect"
Install-WindowsFeature -Name $IISFeatures

#Delete default IIS website
echo "Deleting the default IIS website..."
 
import-module webadministration
Stop-WebSite 'Default Web Site'
Remove-Website 'Default Web Site'
 
echo "Default website deleted."

echo "IIS installation completed"

#Install chocolatey
echo "Installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
echo "Finished chocolatey installation"

#Install webdeploy for IIS
echo "Installing webdeploy to launch your webserver"
choco install webdeploy -y
echo "Finished installing webdeploy"

#staat in commentaar omdat windowsbox alle versies van sql server al had staan
#echo "Installing SQL Server 2017"
#Install SQL Server 2017 Express
#choco install sql-server-express -y

#Install server manager

#OPKUIS mogen volgende 2 lijnen weg?
Import-Module ServerManager
Add-WindowsFeature Web-Scripting-Tools

set-executionpolicy unrestricted

#OPKUIS deze import is bovenaan al 'ns gebeurd
Import-Module WebAdministration
$SiteAppPool = ".NET v4.5"                  # Application Pool Name
$SiteName = "demosite"                        # IIS Site Name

New-WebSite -Name $SiteName -Port 80 -PhysicalPath "C:\inetpub\wwwroot\smartstore.net"

#Add opensource website to root directory
echo "Adding opensource website"

[string]$sourceDirectory  = "C:\vagrant\resources\SmartStore\*"
[string]$destinationDirectory = "C:\inetpub\wwwroot"
Copy-item -Force -Recurse -Verbose $sourceDirectory -Destination $destinationDirectory

#Add write permissions for site root folder
$sharepath = "C:\inetpub\wwwroot\smartstore.net"
$Acl = Get-ACL $SharePath
$AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("everyone","FullControl","ContainerInherit,Objectinherit","none","Allow")
$Acl.AddAccessRule($AccessRule)
Set-Acl $SharePath $Acl

#Change ApplicationPool Identity for SQL connection through built-in Windows
$pool = Get-Item IIS:\AppPools\DefaultAppPool
$pool.processModel.identityType = "LocalSystem"
$pool | set-item

