#!/bin/bash

# create an own image
docker build --tag schajtan/jenkins -f ./jenkins-dockerfile.txt .