#!/bin/bash

# Description:
# This script will install Cassandra DB 
# Cassandra version is 3.11.4
# Cassandra will be installed on the spark master, so this script takes a IP address of spark master as a parameter
# If Cassandra has to be installed on some other machine, then the label in the jenkinsfile has to be taken care accordingly

# Cassandra repo URL
CASSANDRA_REPO_URL=https://www.apache.org/dist/cassandra/redhat/311x/

# Create a Repo file for Cassandra installation
cd /root
touch /etc/yum.repos.d/cassandra.repo
cd /etc/yum.repos.d
echo '[cassandra-3.11.4]' >> cassandra.repo
echo 'name=Apache Cassandra' >> cassandra.repo
echo "baseurl=$CASSANDRA_REPO_URL" >> cassandra.repo

#Install Cassandra DB
yum -y install cassandra

#Edit the cassandra.yaml file for setting the IPAddress instead of localhost or loopback address
sed -i "s/listen_address: localhost/listen_address: $1/g" /etc/cassandra/conf/cassandra.yaml
sed -i "s/rpc_address: localhost/rpc_address: $1/g" /etc/cassandra/conf/cassandra.yaml
sed -i 's/- seeds: "127.0.0.1"/- seeds: '$1'/g' /etc/cassandra/conf/cassandra.yaml


#start and enable the cassandra DB
systemctl daemon-reload
systemctl start cassandra
systemctl enable cassandra
