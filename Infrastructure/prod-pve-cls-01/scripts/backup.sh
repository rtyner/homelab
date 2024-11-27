#!/bin/bash
date=$(date +%m-%d-%y)

find /root/backups/dump-*.tar.gz -type d -ctime +10 -exec rm -rf {} \;

tar czvf /home/root/backups/dump-${date}.tar.gz /var/lib/vz/dump
scp dump-${date}.tar.gz rt@207.246.116.69:/home/rt/pve1-backups/

