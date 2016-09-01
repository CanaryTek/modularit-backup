# Cookbook Name:: modularit-backup
# Recipe:: server
#
# Configures a backup server with SafeKeep

## Needed packages
[ "safekeep-server"].each do |pkg|
	package pkg
end

## Rasca alarm links
["CheckSafekeep"].each do |check|
	rasca_check check do
	  priority "Urgent"
  end
end
