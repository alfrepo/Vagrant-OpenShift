#!/bin/bash -e

#rm -r /data/openldap

docker rm -f openldap-phpldapadmin-service
docker rm -f openldap-service
#docker rm -f openldap-backup
  
