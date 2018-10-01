# Bicycle Setup Doc

The idea behind this directedory is to provide roles that get your bicycle server(s) and clients up and running as simply as possible

The role expectes a freshly deployed RHEL7 minimal install and by default will setup a VDO vol on a blank block device - expected to be **sdb**. This can ge changed easily by altering the vsariable

The installation will ensure all necesary packages are installed, fireall ports are opened etc. It will also setup a VDO volume, create a mount point in /var/www/html/repos and mount it, along with the necesary fstab options 


