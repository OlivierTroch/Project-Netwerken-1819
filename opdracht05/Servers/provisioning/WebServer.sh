#! /usr/bin/bash
#
# Provisioning script for WebServer

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
#Database configuration
source ${PROVISIONING_SCRIPTS}/config.sh

#------------------------------------------------------------------------------
# Provision server
#------------------------------------------------------------------------------

info "Starting server specific provisioning tasks on ${HOSTNAME}"

#system update
info "Updating system..."
#yum update -y

info "Installing required software"
#httpd
yum install -y httpd
systemctl start httpd
systemctl enable httpd

#mariadb
yum install -y mariadb mariadb-server
systemctl start mariadb
systemctl enable mariadb
## mariadb post-install setup
info "Configuring database to your preferences..."

if ! mysql -u root --password=${ROOT_PASS} -e "use demodb;" ;then

	### set root password
	mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$ROOT_PASS');"

# 	### drop the anonymous users
	mysql -u root --password=${ROOT_PASS} -e "DROP USER ''@'localhost';"

	### drop the demo database
	mysql -u root --password=${ROOT_PASS} -e "DROP DATABASE test;"

	### create drupal db
    mysqladmin -u root --password=${ROOT_PASS} create ${NAME_DB}
    info "create user"
 	mysql -u root --password=${ROOT_PASS} -e "CREATE USER '${DRUPAL_NAME}'@'localhost' IDENTIFIED BY '${DRUPAL_PASS}';"
 	info "grant privileges"
 	mysql -u root --password=${ROOT_PASS} -e "GRANT ALL PRIVILEGES ON ${NAME_DB}.* TO '${DRUPAL_NAME}'@'localhost';"
 	info "flush privileges"
 	mysql -u root --password=${ROOT_PASS} -e "FLUSH PRIVILEGES;"
 	#restart mariadb
	systemctl restart mariadb
fi


#php (5.6)
if ! php --version; then
	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
	yum install -y yum-utils
	yum-config-manager --enable remi-php56
	yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-xml php-pear php-fpm php-mbstring
	systemctl restart httpd
fi


# install rsync
yum install -y rsync
# sync directory aanmaken
mkdir /home/data

# ssh setup
ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
# manueel invoeren
#ssh-copy-id -i /root/.ssh/id_rsa.pub 192.168.10.4	

#change system time to Belgium
mv /etc/localtime /etc/localtime.backup
ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime

# execute drupal script
chmod +x /vagrant/provisioning/LAMPdrupal.sh
sh /vagrant/provisioning/LAMPdrupal.sh