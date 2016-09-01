# Cookbook Name:: modularit-backup
# Recipe:: client
#
# Configures a safekeep backup client

## Needed packages
[ "safekeep-client"].each do |pkg|
	package pkg
end

## Rasca alarm links
["CheckBackup"].each do |check|
	rasca_check check do
	  priority "Urgent"
  end
end

# Client script to make a timestamp on backup completion
file "/usr/sbin/safekeep-client-script.sh" do
	action :create
	content <<EOF
#! /bin/sh
#
# Safekeep client script
# API:  $1 = Step, $2 = Safekeep ID, $3 = Backup Root Directory

case $1 in
'STARTUP') ;;
'PRE-SETUP') ;;
'POST-SETUP') ;;
'POST-BACKUP')
    logger "safekeep: Backup OK"
    touch /var/lib/modularit/data/lastbackups/safekeep
    ;;
'POST-SCRUB') ;;
esac

exit 0

EOF
  mode "0755"
end

