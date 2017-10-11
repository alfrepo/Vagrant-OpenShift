#!/bin/bash -e

tar -zcvf /tmp/data.tar.gz /data
aws s3 cp /tmp/data.tar.gz "s3://alf-digital-backups/data/"
rm /tmp/data.tar.gz