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

Important attributes:

- `node['modularit']['git_backup_remoteurl']`: Defines the base URL used for git backup

Usage
-----

#### For Git backups

1. Install a server, applying `recipe[modularit-backup::git_server]`

2. Define the attribute `node['modularit-backup']['git_backup_baseurl']` for all hosts that will use the previous server

3. On the clients, include `recipe[modularit-backup::git_client]`

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
