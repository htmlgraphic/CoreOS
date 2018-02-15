OPS is a collection of CoreOS and Docker files to simplify the deployment of multiple web services on Digital Ocean. The docker build processes can be used on any provider. Each component is divided into the following folders:

* [**CoreOS**](https://github.com/htmlgraphic/CoreOS) - Scripts used for the loading of services into Fleet on CoreOS
* [**Docker**](https://github.com/htmlgraphic/Docker) - Build scripts the creation of my different types of servers. 
    * Apache Web Server
    * Data Container
    * [Postfix Mail Server](https://github.com/htmlgraphic/Postfix)
    * MySQL server
    * [OpenVPN Server](https://github.com/htmlgraphic/OpenVPN-Server)

## Quick Start
```bash
    $ git clone git@github.com:htmlgraphic/CoreOS.git && cd CoreOS
    $ make
    $ make token
    $ make node
```

## Creating a cluster
Creating nodes for the CoreOS cluster is as simple as typing the `make node`.
* Before running the make process, set the (Digital Ocean Key - Read & Write) **DO_TOKEN** environment variable and the **SSH key ID** (ssh_keys) in the script `create_node_var.sh`. 

    **Example:** `export DO_TOKEN=xyzabc123` add this to either your ~/.zshrc OR ~/.bashrc file to create when the terminal is launched.
* New discovery URLs can be generated at https://discovery.etcd.io/new This process will be handled for you via the creation process if you have an existing cluster simply add the etcd token to `.discovery-token`.

* Current variables set during box creation:
    * name - what is the droplet called? A valid domain name is possible as Digital Ocean will add a reverse DNS lookup
    * backup - boolean, Enable automated backups - [more info](https://www.digitalocean.com/community/tutorials/digitalocean-backups-and-snapshots-explained)
    * region - where should this droplet be created
    * size - 512mb, 1gb, 2gb - issue a CURL request to understand your size options - [more info](https://developers.digitalocean.com/#list-all-sizes)
    * private_networking - boolean
    * image - what version of CoreOS: **coreos-stable** **coreos-beta** **coreos-alpha**
    * user_data - this is where the `cloud-config.yaml` comes into play
    * ssh_keys - CoreOS **only** uses a key for login and the username is **core**. You will need to add one to your DO account - [more info](https://developers.digitalocean.com/#ssh-keys) 

## Accessing the cluster
You may now verify that the cluster has clustered by SSHing into a node.
* SSH into a node as the core user with the -A flag (to forward the SSH agent): `ssh -A core@<node_public_ip>`
* On the node, run `fleetctl list-machines` to verify that the nodes have discovered each other.

It may also be preferred to install fleetctl on your local machine and connect remotely:
* Run `ssh-add` to ensure your SSH key is added to the ssh agent
* Run `fleetctl --tunnel=<node_public_ip> list-machines`
* You may set the `FLEETCTL_TUNNEL` environment variable to skip setting the `--tunnel` flag

## Deploying apps
It's important that the unit files (*.service) is accessible to the fleetctl command. If the files are on your local computer, use a tunneled fleetctl connection to load the unit files.

* Upload the service file with `fleetctl submit name.service`
* List unit files with `fleetctl list-unit-files`
* Finally, start the units with `fleetctl start name.service`
* List loaded units with `fleetctl list-units`



