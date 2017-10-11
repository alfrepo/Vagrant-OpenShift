#!/bin/bash

DATA_FOLDER=/data
TMP_BACKUP_FOLDER=/tmp/backup
TMP_BACKUP_UNPACKED_FOLDER=/tmp/backupUnpacked



# clear previous backups
rm -rf "$TMP_BACKUP_FOLDER"
rm -rf "$TMP_BACKUP_UNPACKED_FOLDER"

mkdir "$TMP_BACKUP_FOLDER"
mkdir "$TMP_BACKUP_UNPACKED_FOLDER"

# # download
aws s3 sync "s3://alf-digital-backups$DATA_FOLDER/" $TMP_BACKUP_FOLDER

# unpack
cat $TMP_BACKUP_FOLDER/*.tar.gz | tar -xzf - -i --directory $TMP_BACKUP_UNPACKED_FOLDER

# remove equally named folders 
# move unpacked folders to data
for dir in $TMP_BACKUP_UNPACKED_FOLDER/*/
do
    dir=${dir%*/}
	folder=${dir##*/}
    rm -rf $DATA_FOLDER/$folder
	mv $dir $DATA_FOLDER
done

# modify access rights
sudo chmod -R 777 $DATA_FOLDER


# clean up
rm -rf $TMP_BACKUP_FOLDER
rm -rf $TMP_BACKUP_UNPACKED_FOLDER