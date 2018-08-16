# bicycle, version 0.1
Bicycle is more a concept than a thing. Bicycle is an Ansible based concept to provide operations capabilities such as provisioning, life cycle management and troubleshooting for Red Hat Enterprise Linux. For people who only needs a bicycle and not a satellite. 

Bicycle is ment to be used with Ansible Tower, Red Hat Insights and Red Hat Network subscription service but can be used standalone only using the software which is included in Red Hat Enterprise Linux. As all software can provided by Red Hat as a part of a Red Hat Enterprise Linux subscription - that means you get support for the software from Red Hat Support, but remember you do _NOT_ get Bicycle specific support ;)

Please note that these are early days and you are expected to both understand and bo a lot of things yourself to get this working. As development progresses, things will be put in place automatically for you. 

# Contribution
Feel free to contribute if you think this is useful :)

# Bicycle architecture
Bicycle can run without buying anything extra, CLI only, by only using Ansible core included in Red Hat Enterprise Linux and using Red Hat Network for keeping tabs on subscription. Bicycle can also run with GUI and LCM features, then utilizing Ansible Tower or AWX for GUI and advanced life cycle management capabilities provided by Red Hat Insight.

The full set of features which the Bicycle concept provides are:
* GUI, CLI and RestAPI where all provided and custom automation can be accessed and shared (Ansible Tower or AWX)
* Sync yum repositories to a local server and provide them via http (reposync and createrepo)
* Clone yum repositories to provide your own baselines (rsync, recommended: to VDO enabled disk)
* Provide kickstarts from a local server via http
* Provision new servers on any platform, including Amazon, GCE, Azure, RHEV, OpenStack, Hyper-V, VMware, a.s.o. (Ansible)
* Arbitrary remote commands to provisioned or existing servers (Ansible)
* Advanced LCM features, including deep state errata reporting (if something is disabled, why patch?) and automatic production of Ansible playbooks to patch servers (Red Hat Insight)
* Advanced proactive problem analysis based on over 100,000 known issues and solution. This saves you a lot of time. (Red Hat Insight)

## Bicycle CLI option

 ![Simple architecture](https://github.com/mglantz/bicycle/blob/master/s-architecture.png?raw=true)

## Bicycle GUI and LCM option

 ![Advanced architecture](https://github.com/mglantz/bicycle/blob/master/adv-architecture.png?raw=true)
 
# Prerequisites
Review what architectural option to select first.

## Bicycle CLI option prerequsites
* 1x Red Hat Enterprise Linux subscription
* 1x server, virtual or physical (2 CPU cores, 8 GB of memory is estimated for ~100 managed servers)
* Firewall openings as follows:
```
Network -> Bicycle server, tcp port 80.
Bicycle server -> Managed servers, tcp port 22
Bicycle server -> Red Hat Network (see: https://access.redhat.com/solutions/65300)
Managed servers -> Red Hat Network (see: https://access.redhat.com/solutions/65300)
```

## Bicycle GUI and LCM option prerequsites
* 1x Red Hat Enterprise Linux subscription with Smart Management (this gives you Red Hat Insight)
* 1x Ansible Tower by Red Hat subscription
* 1x server, virtual or physical (2 CPU cores, 8 GB of memory is estimates for ~100 managed servers)
* For Ansible Tower prerequisites see: https://docs.ansible.com/ansible-tower/latest/html/quickinstall/index.html
* Firewall openings as follows:
```
Network -> Bicycle server, tcp port 80.
Ansible tower -> Bicycle server, tcp port 22
Bicycle server -> managed servers, tcp port 22
Bicycle server -> Red Hat Network (see: https://access.redhat.com/solutions/65300)
Managed servers -> Red Hat Network (see: https://access.redhat.com/solutions/65300)
Managed servers -> Red Hat Insight (cert-api.access.redhat.com:443, api.access.redhat.com:443)
```

# Installing Bicycle
The Bicycle is where you keep yum repositories and kickstart files. If you do not need a GUI or the ability to centrally see which server needs what updates a.s.o. - then you only need to install this.

## Installing the Bicycle server on Amazon EC2
Run below playbook to provision a server automatically on Amazon EC2. By default a t2.large instance is used.
```
git clone https://github.com/mglantz/bicycle 
cd bicycle/provisioning
vi provisioning.yml
ansible-playbook -i ./provisioning-inventory ./provisioning.yml --private-key=/path/to/private_key.pem -u root
```

## Manual installation of the Bicycle server
* Install Red Hat Enterprise Linux 7-latest on a server with appropriate specs
* Install and configure required software
```
# yum install httpd httpd-tools createrepo yum-utils
# mkdir /var/www/html
# chmod 755 /var/www/html
# systemctl enable httpd
# systemctl start httpd
# git clone http://github.com/mglantz/bicycle
```

## Installing advanced capabilities (GUI & LCM management)
* If you want a supported GUI for Bicycle, install Ansible Tower (https://docs.ansible.com/ansible-tower/latest/html/quickinstall/index.html) or AWX (https://github.com/ansible/awx).

* If you want advanced Life Cycle Management where you can see which server is missing what update and much more, get Red Hat Insight ( https://access.redhat.com/products/red-hat-insights#getstarted ). 

# Managing Bicycle from the GUI
This is if you are running Ansible Tower or AWX. Just import the playbooks into an Ansible Tower or AWX project and create job templates for the playbooks. Automation and instructions for this will come later. For now, look for details in the command line section below.

## Managing subscriptions, errata and predictive troubleshooting
Red Hat Insight will provide you with information about what server needs to be updated and also generate Ansible playbooks to apply required errata. Integrate Ansible Tower or AWX with Red Hat Insights: https://docs.ansible.com/ansible-tower/latest/html/userguide/insights.html. To run Red Hat Insight you also need to register your servers to Red Hat Network. Do this with the commands below. Please note that we disable any yum repos enabled via Red Hat Network, as we like that to go via Bicycle:
```
subscription-manager register
subscription-manager repos --disable=*
```

## Run arbitrary remote commands on servers
Use Ansible: http://www.ansible.com and https://www.ansible.com/products/tower or https://github.com/ansible/awx. Commands can be run from the command line like such: https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html#parallelism-and-shell-commands.

# Managing Bicycle from a command line
Before starting to operate your Bicycle, update manage/bicycle-inventory with the correct IP address to your Bicycle.

## Synchronize a yum repository to your Bicycle
Below playbook will synchronize a yum repository from the network/internet to /var/www/html/repos/repo-id on Bicycle. The repository will become available via http://bicycle/repos/repo-id. List all available repositories by going to http://bicycle/repos.
```
cd bicycle/manage
ansible-playbook -i ./bicycle-inventory reposync.yml --private-key=/path/to/private.pem -u root \
--extra-vars "repo=repository-id"
```
Example:
```
cd bicycle/manage
ansible-playbook -i ./bicycle-inventory reposync.yml --private-key=/home/user/.ssh/id_rsa -u root \
--extra-vars "repo=rhel-7-server-rpms"
```

## Clone yum repository
To copy an an already synced yum repository or to synchronize any two yum repositories from A to B, use this playbook. The new repository becomes available via http://bicycle/repos/repo-id. The cloning process will delete any files in to_repo which does not exist in from_repo to prevent inconsistent states.
```
cd bicycle/manage
ansible-playbook -i ./bicycle-inventory repoclone.yml --private-key=/path/to/private.pem -u root \
--extra-vars "from_repo=repository-id to_repo=repository-id"
```
Example:
```
cd bicycle/manage
ansible-playbook -i ./bicycle-inventory repoclone.yml --private-key=/home/user/.ssh/id_rsa -u root \
--extra-vars "from_repo=rhel-7-server-rpms to_repo=rhel7-baseline-180120"
```

## Create or update a kickstart
To create or update a kickstart file, use this playbook. Created kickstart files will be made available via http://bicycle/ks/kickstart-name. For help on creating a kickstart file, please visit https://access.redhat.com/labs/kickstartconfig/. To list all available kickstarts visit http://bicycle/ks/
```
cd bicycle/manage
cp templates/kickstart-example.j2 templates/my-kickstart.j2
vi templates/my-kickstart.j2
ansible-playbook -i ./bicycle-inventory kickstart.yml --private-key=/path/to/private.pem -u root \
--extra-vars "ks-name=kickstart-name ks-template=filename.j2"
```

## Run arbitrary remote commands on servers
Use Ansible: http://www.ansible.com and run playbooks from the Bicycle server, or directory from the command line, like such: https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html#parallelism-and-shell-commands

# Subscription management
You get subscription management via Red Hat Network. When registering your system, don't forget to disable any repositories enabled on Red Hat Network afterwards. Eg:
```
subscription-manager register
subscription-manager repos --disable=*
```
For more details on registering a Red Hat system, please see: https://access.redhat.com/solutions/253273
