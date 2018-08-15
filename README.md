# bicycle
What is this? It's not a Satellite, but you don't need a Satellite. 

This is a simple Ansible based service to provide operations capabilities such as provisioning, life cycle management and troubleshooting for Red Hat Enterprise Linux. Ment to be used with Ansible Tower and Red Hat Insights but can be used without that.

# Contribution
Feel free to contribute if you think this is useful :)

# Installing Bicycle

## Installing the Bicycle server
The Bicycle is where you keep yum repositories and kickstart files. If you do not need a GUI or the ability to centrally see which server needs what updates - then you only need to install this.
```
git clone https://github.com/mglantz/bicycle 
cd bicycle/provisioning
vi provisioning.yml
ansible-playbook -i ./provisioning-inventory ./provisioning.yml --private-key=/path/to/private_key.pem -u root
```

## Getting advanced capabilities (GUI & Errata management)
* If you want a supported GUI for Bicycle, install Ansible Tower (https://docs.ansible.com/ansible-tower/latest/html/quickinstall/index.html) or AWX (https://github.com/ansible/awx).

* If you want advanced errata management where you can see which server is missing what update and much more, get Red Hat Insight ( https://access.redhat.com/products/red-hat-insights#getstarted ). 

# Managing Bicycle from the GUI
This is if you are running Ansible Tower or AWX. Just import the playbooks into an Ansible Tower or AWX project and create job templates for the playbooks. Automation and instructions for this will come later. For now, look for details in the command line section below.

## Managing errata and troubleshooting
Integrate Ansible Tower or AWX with Red Hat Insights: https://docs.ansible.com/ansible-tower/latest/html/userguide/insights.html

# Managing Bicycle from a command line
Before starting to operate your Bicycle, update manage/bicycle-inventory with the correct IP address to your Bicycle.

## Synchronize a yum repository to your Bicycle
Below playbook will synchronize a yum repository from the network/internet to /var/www/html/repo-id. The repository will become available via http://bicycle/repo-id.
```
cd bicycle/manage
ansible-playbook -i ./bicycle-inventory reposync.yml --private-key=/path/to/private.pem -u root \
--extra-vars "repo=repository-id"
```

## Clone yum repository
To copy an an already synced yum repository or to synchronize any two yum repositories from A to B, use this playbook.
```
cd bicycle/manage
ansible-playbook -i ./bicycle-inventory repoclone.yml --private-key=/path/to/private.pem -u root \
--extra-vars "from_repo=repository-id to_repo=repository-id"
```

## Create or update a kickstart
To create or update a kickstart file, use this playbook. Created kickstart files will be made available via http://bicycle/kickstart-name. For help on creating a kickstart file, please visit https://access.redhat.com/labs/kickstartconfig/
```
cd bicycle/manage
cp templates/kickstart-example.j2 templates/my-kickstart.j2
vi templates/my-kickstart.j2
ansible-playbook -i ./bicycle-inventory kickstart.yml --private-key=/path/to/private.pem -u root \
--extra-vars "ks-name=filename ks-template=filename.j2"
```

# Run arbitrary remote commands on servers
Use Ansible: http://www.ansible.com, https://www.ansible.com/products/tower or https://github.com/ansible/awx

