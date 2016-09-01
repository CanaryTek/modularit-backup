modularit-backup Cookbook
==========================

Sets up backup server and clients for a ModularIT infraestructure
The backup system is based in SafeKeep

Requirements
------------

Basically an RHEL/CentOS/Fedora server

Attributes
----------

Read the files, they are well documented (I hope)

Usage
-----

1. Install a server, applying `recipe[modularit-backup::server]`

2. On the clients, include `recipe[modularit-backup::client]`

3. Define backup targets based on provided template /etc/safekeep/backup.d/backup.template

4. Deploy SSH keys from the server to the clients using safekeep

  safekeep --keys --deploy

5. Run backups

  safekeep --server

6. Check for backups

  safekeep --list

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
