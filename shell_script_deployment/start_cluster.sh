#!/bin/bash

#Varaibles declaration
installation_directory=/usr/local
spark_version=spark-2.4.0
hadoop_version=2.7

#start the spark cluster
su - root << EOF
cd $installation_directory/$spark_version-bin-hadoop$hadoop_version
./sbin/start-all.sh
EOF




