#!/bin/bash

# Description:
# This file configures the spark slaves
# Spark Version is 2.4.0

#Variable declaration
SCALA_VERSION=2.11.8
SPARK_VERSION=spark-2.4.0
HADOOP_VERSION=2.7
INSTALLATION_DIRECTORY=/usr/local
JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
SCALA_DOWNLOAD_URL=http://downloads.lightbend.com/scala
#give the java home accoridng to your system

#Check for the pre-requisites
yum install -y wget
java -version || yum install -y java-1.8.0-openjdk-devel
if [[ $? -ne 0 ]]
then
   yum install -y java-1.8.0-openjdk-devel
   echo 'Java Installed'
else
   echo 'Java already installed'
fi

cd /root
scala -version || wget $SCALA_DOWNLOAD_URL/$SCALA_VERSION/scala-$SCALA_VERSION.rpm
scala -version || yum install -y scala-$SCALA_VERSION.rpm



#untar the file
tar xvf /root/$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C $INSTALLATION_DIRECTORY

#Edit the ~/.bash_profile file
echo "export PATH=$PATH:$INSTALLATION_DIRECTORY/$SPARK_VERSION-bin-hadoop$HADOOP_VERSION/bin" >> ~/.bash_profile
source ~/.bash_profile
