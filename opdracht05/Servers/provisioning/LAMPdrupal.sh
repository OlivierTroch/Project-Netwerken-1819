#! /usr/bin/bash
#
# Provisioning script for srvLAMP

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't mask errors in piped commands
set -o pipefail

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Location of provisioning scripts and files
export readonly PROVISIONING_SCRIPTS="/vagrant/provisioning/"
# Location of files to be copied to this server
export readonly PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/files/${HOSTNAME}"

#------------------------------------------------------------------------------
# "Imports"
#------------------------------------------------------------------------------

# # Utility functions
source ${PROVISIONING_SCRIPTS}/util.sh
# Actions/settings common to all servers
source ${PROVISIONING_SCRIPTS}/common.sh
#Drupal configuration
source ${PROVISIONING_SCRIPTS}/config.sh


#install drush
if ! drush version; then
	info "Setting up drupal (and prerequisites: drush) for your LAMP server"
	yum install -y wget unzip
	wget -nc https://github.com/drush-ops/drush/releases/download/8.2.1/drush.phar
	cp -r -n drush.phar /bin/drush
	chmod +x /bin/drush
fi


#drupal
if [ ! -d drupal-8.6.12 ]; then
	wget -nc http://ftp.drupal.org/files/projects/drupal-8.6.12.zip
	unzip -n drupal-8.6.12.zip
  	rm -r /var/www/html
	cp -r -n drupal-8.6.12 /var/www/html
	cd /var/www/html/sites/default/
	cp -p -n default.settings.php settings.php
	chmod 666 settings.php
	mkdir files
	chmod 777 files

	cd /var/www/html
	# default drupal login: admin; password: admin (set in config.sh)
	drush site-install --db-url=mysql://${DRUPAL_NAME}:${DRUPAL_PASS}@localhost:3306/demodb --yes --account-name=${DRUPAL_LOGIN} --account-pass=${DRUPAL_PASSWORD}

	#drupal 8; disable aggregate css and js to load site properly
	#(documentatie: default wordt er geprobeerd om alle css en js te bundelen in 1 file 
	#om het sneller te doen laden, maar dit zorgt voor bugs)
	drush -y config-set system.performance css.preprocess 0
	drush -y config-set system.performance js.preprocess 0

	#overwrite old httpd.conf with preset file
	cp -f /vagrant/provisioning/httpd.conf /etc/httpd/conf/httpd.conf

	#restart apache
	systemctl restart httpd
fi

info "Sucessfully configured your LAMP server!"