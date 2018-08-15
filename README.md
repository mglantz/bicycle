# bicycle
What is this? It's not a Satellite, but you don't need a Satellite.

# Installing Bicycle
```
git clone https://github.com/mglantz/bicycle 
cd bicycle/provisioning
vi provisioning.yml
ansible-playbook -i ./provisioning-inventory ./provisioning.yml --private-key=/path/to/private_key.pem -u root
```

# Managing Bicycle
Before starting to operate your Bicycle, update manage/bicycle-inventory with the correct IP address.

## Synchrone a yum repository from the network
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
To create or update a kickstart file, use this playbook. Created kickstart files will be made available via http://bicycle/kickstart-name.
```
cd bicycle/manage
cp templates/kickstart-example.j2 templates/my-kickstart.j2
vi templates/my-kickstart.j2
ansible-playbook -i ./bicycle-inventory kickstart.yml --private-key=/path/to/private.pem -u root \
--extra-vars "ks-name=filename ks-template=filename.j2"
```

