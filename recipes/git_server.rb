# Cookbook Name:: modularit-backup
# Recipe:: git_server
#
# Configures a Git backup server with gitolite

# We use the same SSH key for git backups and for gitolite admin, so a server MUST be also a client
include_recipe "modularit-backup::git_client"

case node['platform']
when "debian", "ubuntu"
  include_recipe 'apt'
when "centos","redhat"
  include_recipe 'yum'
  include_recipe "yum::epel"
end

# Install packages
packages = node['gitolite']['packages'].split
packages.each do |pkg|
  package pkg do
    action :install
  end
end

#case node['platform']
#when "centos","redhat"
#  bash "Workaround for http://tickets.opscode.com/browse/COOK-1210" do 
#    code <<-EOH
#      echo 0 > /selinux/enforce
#    EOH
#  end
#end

# FIXME: We can not use git_ssh_key from attribute because until resources are executed, it will not be available
# Until we find a better way, we copy public key
execute "Copy gitolite admin key" do
  cwd "/root"
  command "cp /root/.ssh/git-backup.pub /var/lib/gitolite/#{node['rasca']['node_name']}.pub"
  creates "/var/lib/gitolite/#{node['rasca']['node_name']}.pub'"
end

execute "Initialize gitolite" do
  cwd "/root"
  command "su - gitolite -c 'gl-setup -q /var/lib/gitolite/#{node['rasca']['node_name']}.pub'"
  creates "/var/lib/gitolite/repositories/gitolite-admin.git"
  only_if { ::File.exists?("/var/lib/gitolite/#{node['rasca']['node_name']}.pub") }
end

# FIXME: use SSH
bash "Clone gitolite-admin repo" do
  cwd "/root"
  code "GIT_SSH=/root/bin/gitbackup.sh git clone gitolite@xenc.canarytek.com:gitolite-admin"
  creates "/root/gitolite-admin"
end

# Git push. triggered on data change
bash "git-push" do
  cwd "/root/gitolite-admin"
  code "git add . && git commit -m'autocommit' && GIT_SSH=/root/bin/gitbackup.sh git push origin master"
  action :nothing
end

# Get all nodes 
if node['gitolite']['multi_environment_git_backup']
  nodes = search(:node, "#{node['gitolite']['host_search']} AND NOT role:#{node['gitolite']['skip_role']}")
else
  nodes = search(:node, "#{node['gitolite']['host_search']} AND chef_environment:#{node.chef_environment} AND NOT role:#{node['gitolite']['skip_role']}")
end

# Sort by name to provide stable ordering
nodes.sort! {|a,b| a.name <=> b.name }

# Main config file
template "/root/gitolite-admin/conf/gitolite.conf" do
  source 'gitolite_conf.erb'
  variables( 
    :nodes => nodes
  )
  notifies :run, "bash[git-push]"
end

# Public keys
nodes.each do |n|
  if n.has_key?("modularit_backup") && n["modularit_backup"].has_key?("git_ssh_key")
    file "/root/gitolite-admin/keydir/#{n["rasca"]["node_name"]}.pub" do
      content n["modularit_backup"]["git_ssh_key"]
      notifies :run, "bash[git-push]"
    end
  end
end

# Add gitolite server public key if ot does not exist
execute "copy gitolite server key" do
  cwd "/root"
  command "cp /root/.ssh/git-backup.pub /root/gitolite-admin/keydir/#{node['rasca']['node_name']}.pub"
  creates "/root/gitolite-admin/keydir/#{node['rasca']['node_name']}.pub"
end
