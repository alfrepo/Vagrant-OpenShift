#!/bin/bash -e

DATA_FOLDER=/data
TMP_DATA_FOLDER=/tmp/data


# clear previous backups
rm -rf $TMP_DATA_FOLDER
mkdir $TMP_DATA_FOLDER

# iterate data-subfolders. Put each one of it into an own archive.
cd $DATA_FOLDER
find . -maxdepth 1 -mindepth 1 -type d -exec sh -c 'foldername="$(echo {}| cut -c 3- )"; tar -zcvf '$TMP_DATA_FOLDER'/$foldername.tar.gz -C /data $foldername ' \;

# upload archives to s3
aws s3 sync $TMP_DATA_FOLDER "s3://alf-digital-backups/data/"

# remove the temp data
rm -rf "$TMP_DATA_FOLDER"
