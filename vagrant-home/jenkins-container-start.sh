#!/bin/bash

if [ -z  "`docker network inspect net_hosting | grep net_hosting`" ]; then 
	docker network create net_hosting
fi

# start docker from my image
docker run --net net_hosting  -dit --restart=always -p 8080:8080 -p 50000:50000 \
--volume /data/jenkins_home:/var/jenkins_home \
--name jenkins jenkins/jenkins:2.73-slim