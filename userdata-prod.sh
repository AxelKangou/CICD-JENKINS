#!/bin/bash
yum update -y
yum install java-11-openjdk-devel -y
sudo hostnamectl set-hostname Prod