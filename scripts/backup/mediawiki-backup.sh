#!/bin/bash

# script to dump mysql db and backup to remote server with rclone

# add $wgReadOnly to prevent wiki edits while backup is occuring
docker exec -it mediawiki sh -c "echo "$wgReadOnly = 'Dumping Database, Access will be restored shortly';" >> /var/www/html/LocalSettings.php"

# dump db to dated file
docker exec -it mediawiki-mysql sh -c "mysqldump -h localhost -u rt -p --default-character-set=binary > "/home/backups/sql-backup.$(date +%F_%R)" "

# remove $wgReadOnly to allow for wiki edits
docker exec -it mediawiki sh -c "sed "/$wgReadOnly = 'Dumping Database, Access will be restored shortly';/d" > /var/www/html/LocalSettings.php"

# scp backup from container to docker host
RECENT=$(ls -lrt /home/backups/ | awk '/sql*/ { f=$NF }; END { print f }');
docker cp mediawiki-mysql:/home/backup/${RECENT} /home/rt/backups/${RECENT}

# scp most recent backup file to pc
RECENT=$(ssh rt@docker ls -lrt /home/rt/backups/ | awk '/sql*/ { f=$NF }; END { print f }');
scp rt@docker:/home/rt/backups/${RECENT} /home/rusty/mediawik-backups/${RECENT};
