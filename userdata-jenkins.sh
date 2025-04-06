#!/bin/bash
sudo yum update -y
sudo yum install -y wget maven git java-17-openjdk
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install -y jenkins
sudo hostnamectl set-hostname Jenkins
sudo systemctl daemon-reload 
sudo systemctl enable --now jenkins