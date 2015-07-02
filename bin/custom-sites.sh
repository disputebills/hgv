#!/bin/bash
#
# This script is invoked by the vagrant provisioner and runs inside the vagrant instance.
# It provisions the default WordPress install and those based on the YML configuration files found in hgv_data/config/.
#
# This script can be run at command line:
# $ vagrant ssh
# $ sudo /bin/bash /vagrant/bin/custom-sites.sh
#
ANS_BIN=`which ansible-playbook`

if [[ -z $ANS_BIN ]]
    then
    echo "Whoops, can't find Ansible anywhere. Aborting run."
    echo
    exit
fi

# More continuous scroll of the ansible standard output buffer
export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true

shopt -s nullglob
for file in /vagrant/provisioning/default-install.yml /vagrant/hgv_data/config/*.yml
do
    echo "### Provisioning $file ###"
    $ANS_BIN /vagrant/provisioning/wordpress.yml -i'127.0.0.1,' --extra-vars="@$file"
done

echo