#!/bin/bash

# Description
# This file start the spark cluster services
# Spark Version is 2.4.0

# Varaibles declaration
INSTALLATION_DIRECTORY=/usr/local
SPARK_VERSION=spark-2.4.0
HADOOP_VERSION=2.7
$SPARK_HOME=$INSTALLATION_DIRECTORY/$SPARK_VERSION-bin-hadoop$HADOOP_VERSION

# start the spark cluster
su - root << EOF
$SPARK_HOME/sbin/start-all.sh
EOF




