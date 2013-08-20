# Cookbook Name:: modularit-backup
# Recipe:: git_client
#
# Configures a git backup client

# Create git key pair
execute "Create Git SSH key pair" do
  cwd "/root"
  command "ssh-keygen -C '#{node['rasca']['node_name']} git backup' -N '' -f /root/.ssh/git-backup"
  creates "/root/.ssh/git-backup.pub"
end
 
# Export git ssh public key
ruby_block "export_git_ssh_key" do
  block do
    unless node.has_key?("modularit_backup")
      node["modularit_backup"]=Hash.new
    end
    if File.exists?("/root/.ssh/git-backup.pub")
      node["modularit_backup"]["git_ssh_key"]=File.read("/root/.ssh/git-backup.pub")
    end
  end
end

# Git shell to use git-backup private key
file "/root/bin/gitbackup.sh" do
  mode 00755
  content <<EOF
#!/bin/bash
# Wrapper script to use git-backup ssh key to connect to git backup server
ssh -i /root/.ssh/git-backup -o StrictHostKeyChecking=false $1 $2
EOF
end

