# Documentatie LAMP

Deze documentatie bestaat uit 2 delen:  
1) LAMP server up brengen
2) Documentatie en toelichting van de scripts

# LAMP server up brengen
## VM's aanmaken
We voegen VM's toe in het "vagrant-hosts.yml" bestand (dit staat in dezelfde folder als de "provisioning"-folder:
We geven de server een naam en ip in de provisioning folder (name: srvLAMP
  ip: 192.168.1.35)
De boxfile kan meegegeven worden aan de hand van "box:PATH", indien dit niet gedaan wordt, wordt de standaard boxfile gebruikt (uit de vagrantfile): 

    DEFAULT_BASE_BOX = 'PATH'

Wij verkiezen CentOS boven Fedora, omdat deze zowel door Mr. Bert Van Vreckem als voorbeeld bronnen
het best gedocumenteerd is.

Onze shell scripts voegen we toe in de provisioning map en we geven het dezelfde naam als de server (in ons geval dus srvLAMP.sh)

Er waren al 2 files reeds aanwezig: util.sh (bash functies ) en common.sh (taken die voor ale vms meerdere keren voorkomen).

Alvorens de virtuele server up gebracht wordt / scripts worden uitgevoerd, raden we aan om naam / inlog variabelen aan te passen naar voorkeur. Deze hebben wij gegroepeerd in het (nieuwe) config.sh bestand:


    #mariadb wachtwoord
    readonly ROOT_PASS="test"

    # naam databank drupal
    readonly NAME_DB="demodb"

    #drupal database user
    readonly DRUPAL_NAME="drupal"

    # drupal database wachtwoord
    readonly DRUPAL_PASS="drupalpass"

    # drupal site login
    readonly DRUPAL_LOGIN="admin"

    # drupal site password
    readonly DRUPAL_PASSWORD="admin"

Zoals hierboven te lezen valt, kozen we voor Drupal als content management system, dit wordt later meer toegelicht bij de scripts.

Om de virtuele machine op te starten en de scripts in provision uit te voeren: Ga in PowerShell naar de directory met de "vagrantfile" en typ: 

    vagrant up

Eenmaal de virtuale machine runt, kunnen de scripts opnieuw uitgevoerd worden zonder de vm te hoeven rebooten (na bijvoorbeeld eventuele aanpassingen van de scripts) aan de hand van:

    vagrant provision

Na het succesvol runnen van onze scripts en als de server runt, valt de drupal website te bezoeken, door het IP-adres van de server in te geven in de browser, in ons geval is dit:

    192.168.1.35

# documentatie en toelichting van de scripts
## srvLAMP.sh

We updaten ons systeem automatisch:

    yum update -y

installeren httpd / Apache HyperText Transfer Protocol en automatisch opstarten

    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd

installeren mariadb (database server) en automatisch opstarten

    yum install -y mariadb mariadb-server
    systemctl start mariadb
    systemctl enable mariadb

We checken of er nog geen wachtwoord ingesteld is voor mysql.

    if ! mysql -u root --password=${ROOT_PASS} -e "use demodb;" ;then

 Als dit het geval is, en we dus voor de eerste keer runnen, dan wordt de volgende code uitgevoerd:  
(We zetten een root paswoord, droppen anonieme users, droppen de default database, creëren een drupal databank voor drupal en ten slotte rebooten we deze db)


	mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$ROOT_PASS');"

	mysql -u root --password=${ROOT_PASS} -e "DROP USER ''@'localhost';"

	mysql -u root --password=${ROOT_PASS} -e "DROP DATABASE test;"

    mysqladmin -u root --password=${ROOT_PASS} create ${NAME_DB}
    info "create user"
 	mysql -u root --password=${ROOT_PASS} -e "CREATE USER '${DRUPAL_NAME}'@'localhost' IDENTIFIED BY '${DRUPAL_PASS}';"
 	info "grant privileges"
 	mysql -u root --password=${ROOT_PASS} -e "GRANT ALL PRIVILEGES ON ${NAME_DB}.* TO '${DRUPAL_NAME}'@'localhost';"
 	info "flush privileges"
 	mysql -u root --password=${ROOT_PASS} -e "FLUSH PRIVILEGES;"

	systemctl restart mariadb


Laatste versie van php installeren, als er nog geen php geïnstalleerd is:

    if ! php --version; then

	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
	yum install -y yum-utils
	yum-config-manager --enable remi-php56
	yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-xml php-pear php-fpm php-mbstring
	systemctl restart httpd

    fi

Vervolgens voeren we ons script uit om drupal inorde te brengen ('LAMPdrupal.sh' in dezelfde directory als de andere scripts), nadat we het executable maken:

    chmod +x /vagrant/provisioning/LAMPdrupal.sh
    sh /vagrant/provisioning/LAMPdrupal.sh


## Drupal installeren + Drush
We kozen voor Drupal als content management system omdat dit een flexibele technologie is, die toelaat mensen met mindere kennis toch aan de slag kunnen gaan met de website. Drupal gaat ook goed hand in hand met PHP.

Drush staat voor Drupal Shell, we maken hiervoor gebruik om Drupal acties te kunnen ondernemen aan de hand van scripts. Dit is goed om te automatiseren en tijd te besparen.

Als er nog geen versie van drush op de machine staat, dan installeren we deze (downloaden, unzippen, uitvoeren en uitvoerbaar maken)

    if ! drush version; then

    info "Setting up drupal (and   prerequisites: drush) for your LAMP server"
    yum install -y wget unzip
    wget -nc https://github.com/drush-ops/drush/releases/download/8.2.1/drush.phar
    cp -r -n drush.phar /bin/drush
    chmod +x /bin/drush
        
    fi

We checken of drupal 8.6.12 reeds aanwezig is:

    if [ ! -d drupal-8.6.12 ]; then

Zoniet, dan installeren we dit met volgende code:

	wget -nc http://ftp.drupal.org/files/projects/drupal-8.6.12.zip
	unzip -n drupal-8.6.12.zip
  	rm -r /var/www/html
	cp -r -n drupal-8.6.12 /var/www/html
	cd /var/www/html/sites/default/
	cp -p -n default.settings.php settings.php
	chmod 666 settings.php
	mkdir files
	chmod 777 files

Ga naar volgend pad: '/var/www/html' om met drush instellingen aan te passen

	cd /var/www/html
    
Stel drupal login en passwoord in: (gebruikt variabelen van config.sh)

	drush site-install --db-url=mysql://${DRUPAL_NAME}:${DRUPAL_PASS}@localhost:3306/demodb --yes --account-name=${DRUPAL_LOGIN} --account-pass=${DRUPAL_PASSWORD}


"drupal 8; disable aggregate css and js to load site properly"(https://drupal.stackexchange.com/)

	drush -y config-set system.performance css.preprocess 0
	drush -y config-set system.performance js.preprocess 0

Vervang httpd.conf door onze httpd.conf(aanwezig in provisioning map met scripts) met gewenste instellingen

	cp -f /vagrant/provisioning/httpd.conf /etc/httpd/conf/httpd.conf

Restart apache

	systemctl restart httpd

Einde if (die controlleerde of drupal 8.6.12 aanwezig was)

    fi


## geraadpleegde bronnen:  
LAMP on CentOS: https://hostadvice.com/how-to/how-to-install-lamp-stack-on-centos-7/?fbclid=IwAR21HowalFdaG9DO5BGROT7mxLqC2NACvqKO4RFK1l1pHJDpff_0BQPTFLc  
mysql: https://gist.github.com/Mins/4602864   
Drupal on CentOS 7 with Apache: https://www.atlantic.net/cloud-hosting/how-to-install-drupal-centos-7-apache/   
drush api: http://api.drush.org/  
stackoverflow voor troubleshooting: https://stackoverflow.com/  
Drupal answers: https://drupal.stackexchange.com/  