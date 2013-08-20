modularit-backup Cookbook
==========================

Sets up a backup server for a ModularIT infraestructure

It configures two different services for two types of backups

  * Gitolite for Git backups (configs, etc)
  * sFTP for duplicity backups (data)

Connection to both services are authenticated using the client's modularit-name as usename and the SSH public key exported by the client hosts

Requirements
------------

Basically an RHEL/CentOS/Fedora server

Attributes
----------

Read the files, they are well documented (I hope)

Usage
-----

#### modularit-backup::default

Once the cobbler server is up and running, you can install a new ModularIT base system with the following command:

    koan --server 192.168.122.163 --virt --virt-name=test1 --profile=modularit-base-x86_64

Import CentOS 6 using rsync:

    cobbler import --path=rsync://rsync.cica.es/CentOS/6/os --name=centos6-x86_64 --arch=x86_64

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Kuko Armas <kuko@canarytek.com>
