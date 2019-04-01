#!/bin/bash

# Description:
# This script will install Zeppelin notebook configured for the spark cluster
# Zeppelin Version is 0.8.1
# Zeppelin will be installed on the spark master 
# This script will take spark master url as a paramter 
# If Zeppelin has to be installed on some other machine, then the label in the Jenkinsfile has to be taken care accordingly

# Varaible declaration
SPARK_URL=$1
ZEPPELIN_VERSION=zeppelin-0.8.1
SPARK_INSTALL_DIRECTORY=/usr/local
SPARK_VERSION=spark-2.4.0
HADOOP_VERSION=2.7
SPARK_HOME=$spark_install_directory/$spark_version-bin-hadoop$hadoop_version
ZEPPELIN_INSTALL_DIRECTORY=/usr/local
ZEPPELIN_DOWNLOAD_URL=http://mirrors.estointernet.in/apache/zeppelin
ZEPPELIN_HOME=$ZEPPELIN_INSTALL_DIRECTORY/$ZEPPELIN_VERSION-bin-all

# Download zeppelin if it doesn't exists
ls /root/$ZEPPELIN_VERSION-bin-all.tgz
if [[ $? -ne 0 ]]
then
   cd /root
   wget $ZEPPELIN_DOWNLOAD_URL/$ZEPPELIN_VERSION/$ZEPPELIN_VERSION-bin-all.tgz
   echo 'Zeppelin Downloaded'
else
   echo 'Zeppelin Already present from the first build'
fi

# untar the zeppelin notebook
tar xvf /root/$ZEPPELIN_VERSION-bin-all.tgz -C $ZEPPELIN_INSTALL_DIRECTORY

# Configure the spark master url for the zeppelin notebook
cp $ZEPPELIN_HOME/conf/zeppelin-env.sh.template $ZEPPELIN_HOME/conf/zeppelin-env.sh
chmod 750 $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export MASTER=$SPARK_URL" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export SPARK_HOME=$SPARK_HOME" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh

# Create logs directory for storing all zeppelin logs
# Create run directory for storing the process IDs
mkdir $ZEPPELIN_HOME/logs
mkdir $ZEPPELIN_HOME/run

# start the zeppelin daemon
$ZEPPELIN_HOME/bin/zeppelin-daemon.sh start &

