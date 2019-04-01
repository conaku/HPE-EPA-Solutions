#!/bin/bash

# Description:
# This script will install and configure Spark Master
# Spark Version is 2.4.0
# This file takes 2 parameters to configure the spark master, those are spark master IP(1 par) and spark web ui port(2par)

# Variable declaration
# Default spark webui port is 8080
SCALA_VERSION=2.11.8
SPARK_VERSION=spark-2.4.0
HADOOP_VERSION=2.7
INSTALLATION_DIRECTORY=/usr/local
SPARK_WEBUI_PORT=$2
SPARK_MASTER_IP=$1
SCALA_DOWNLOAD_URL=http://downloads.lightbend.com/scala
SPARK_DOWNLOAD_URL=http://www-us.apache.org/dist/spark
SPARK_HOME=$INSTALLATION_DIRECTORY/$SPARK_VERSION-bin-hadoop$HADOOP_VERSION
JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
# set the java home according to the version installed in system

# Check for the pre-requisites
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

# download the latest version of spark
ls /root/$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz 
if [[ $? -ne 0 ]]
then 
   cd /root
   wget $SPARK_DOWNLOAD_URL/$SPARK_VERSION/$SPARK_VERSION-\
bin-hadoop$HADOOP_VERSION.tgz 
   echo 'spark tar downloaded to the root directory'
else
   echo 'Spark tar file already downloaded'
fi 

# Push the tgz spark file to slave machines
while read line
do
 scp /root/$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz $line:/root/
done < /root/slaves

# untar the file
tar xvf /root/$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C $INSTALLATION_DIRECTORY

# Edit the ~/.bash_profile file
echo "export PATH=$PATH:$INSTALLATION_DIRECTORY/$SPARK_VERSION-bin-hadoop$HADOOP_VERSION/bin" >> ~/.bash_profile
source ~/.bash_profile

# Spark Master configuration
cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
chmod 750 $SPARK_HOME/conf/spark-env.sh
echo "SPARK_MASTER_WEBUI_PORT=$SPARK_WEBUI_PORT" >> $SPARK_HOME/conf/spark-env.sh
echo "export SPARK_MASTER_HOST='$SPARK_MASTER_IP'" >> $SPARK_HOME/conf/spark-env.sh
echo "export JAVA_HOME=$JAVA_HOME" >> $SPARK_HOME/conf/spark-env.sh
#add the java path according to your environment

# Add the slaves to the slaves file in master machine configuration
cp /root/scripts/slaves $SPARK_HOME/conf/slaves
chmod 750 $SPARK_HOME/conf/slaves



