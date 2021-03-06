maintainer        "CanaryTek"
name              "modularit-backup"
maintainer_email  "kuko@canarytek.com"
license           "Apache 2.0"
description       "Installs and configure a ModularIT Backup server with safekeep"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"
recipe            "modularit-backup", "Installs and configures backup server "

%w{apt yum rasca}.each do |recipe|
  depends recipe
end

%w{redhat centos}.each do |os|
  supports os
end
