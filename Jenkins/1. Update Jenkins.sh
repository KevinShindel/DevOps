#!/bin/bash

cd /usr/share/java/
sudo service jenkins stop
sudo mv jenkins.war jenkins.war.old
sudo wget https://get.jenkins.io/war-stable/2.332.2/jenkins.war
sudo service jenkins start
