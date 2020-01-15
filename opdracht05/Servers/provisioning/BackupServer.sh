#! /usr/bin/bash
#
# Provisioning script for BackupServer

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

# install rsync
yum install -y rsync
#sync directory aanmaken
mkdir /home/Backupfolder
mkdir /home/Lesmateriaal
#geef voldoende rechten
chmod 777 /home/Backupfolder
chmod 777 /home/Lesmateriaal

#change system time to Belgium
mv /etc/localtime /etc/localtime.backup
ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime

ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
#manueel invoeren
#ssh-copy-id -i /root/.ssh/id_rsa.pub 192.168.10.3