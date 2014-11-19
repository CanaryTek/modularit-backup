# Author:: Kuko Armas
# Cookbook Name:: modularit-backup
# Attribute:: gitolite

case node['platform_family']
when 'debian'
  default['gitolite']['packages'] = 'gitolite'
when 'rhel','fedora'
  default['gitolite']['packages'] = 'gitolite'
else
  default['gitolite']['packages'] = 'gitolite'
end

# Host search to use to get the list of hosts allowed to use gitolite for git backup
default['gitolite']['host_search'] = "node_name:*"
# If set to true, include hosts in ANY environment in the previous search. If false, include hosts in same environment as gitolite server
default['gitolite']['multi_environment_git_backup'] = false
# Role to skip from gitolite allowed hosts
default['gitolite']['skip_role']  = 'skip_git_backup'
