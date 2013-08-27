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
      node.set["modularit_backup"]=Hash.new
    end
    if File.exists?("/root/.ssh/git-backup.pub")
      node.set["modularit_backup"]["git_ssh_key"]=File.read("/root/.ssh/git-backup.pub")
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

# Check if a remote git url is defined
git_url=nil
if node['modularit'].has_key?("git_backup_baseurl")
  git_url=node['modularit']["git_backup_baseurl"]
end

# GitChk object file
rasca_object "GitChk" do
  check "GitChk"
if git_url
  content <<EOF
# Run alert with option --info to see the format
/etc:
  :proactive: :commit
  :git_backup_url: "#{git_url}#{node['rasca']['node_name']}_etc"
EOF
else
  content <<EOF
# Run alert with option --info to see the format
/etc:
  :proactive: :commit
EOF
end

end
