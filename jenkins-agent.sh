#!/bin/bash
yum install fontconfig java-17-openjdk  -y         ##In agent need to install java open jdk ###

##terraform install at server ###  to load terraform command there 

yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

##node modules##

dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
yum install zip -y

iAM credentials rules also required here becuase it will configure with aws amazon console that why 