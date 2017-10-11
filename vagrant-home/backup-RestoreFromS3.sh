#!/bin/bash

DATA_FOLDER=/data
TMP_BACKUP_FOLDER=/tmp/backup
TMP_BACKUP_UNPACKED_FOLDER=/tmp/backupUnpacked



# clear previous backups
rm -rf "$TMP_BACKUP_FOLDER"
rm -rf "$TMP_BACKUP_UNPACKED_FOLDER"

mkdir "$TMP_BACKUP_FOLDER"
mkdir "$TMP_BACKUP_UNPACKED_FOLDER"

# create data folder if not yet there
mkdir -p "/data"



# download
aws s3 sync "s3://alf-digital-backups$DATA_FOLDER/" $TMP_BACKUP_FOLDER



# # unpack
# cat $TMP_BACKUP_FOLDER/*.tar.gz | tar -xzf - -i --directory $TMP_BACKUP_UNPACKED_FOLDER
for f in $TMP_BACKUP_FOLDER/*.tar.gz; do tar xzf $f --directory $TMP_BACKUP_UNPACKED_FOLDER ; done



# modify access rights
chmod -R 777 $DATA_FOLDER
chmod -R 777 $TMP_BACKUP_FOLDER
chmod -R 777 $TMP_BACKUP_UNPACKED_FOLDER



# remove equally named folders 
# move unpacked folders to data
for d in $(find /tmp/backupUnpacked/ -mindepth 1 -maxdepth 1 -type d)
do

	if [[ -d "$d" && ! -L "$d" ]]; then
	
		dir=${d%*/}
		folder=${dir##*/}
		echo -e "Removing '$DATA_FOLDER/$folder'. \nReplacing by '$folder' \n"
		
		rm -rf "$DATA_FOLDER/$folder"
		mv "$d" "$DATA_FOLDER"
	fi; 

done


# clean up
rm -rf $TMP_BACKUP_FOLDER
rm -rf $TMP_BACKUP_UNPACKED_FOLDER