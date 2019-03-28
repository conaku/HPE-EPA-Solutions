#!/bin/bash
#Variable declaration
#default spark webui port is 8080
scala_version=2.11.8
spark_version=spark-2.4.0
hadoop_version=2.7
installation_directory=/usr/local
spark_webui_port=$2
spark_master_IP=$1
java_home=/usr/lib/jvm/java-1.8.0-openjdk
#set the java home according to the version installed in system

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
scala -version || wget http://downloads.lightbend.com/scala/$scala_version/scala-$scala_version.rpm 
scala -version || yum install -y scala-$scala_version.rpm

#download the latest version of spark
ls /root/$spark_version-bin-hadoop$hadoop_version.tgz 
if [[ $? -ne 0 ]]
then 
   cd /root
   wget http://www-us.apache.org/dist/spark/$spark_version/$spark_version-\
bin-hadoop$hadoop_version.tgz 
   echo 'spark tar downloaded to the root directory'
else
   echo 'Spark tar file already downloaded'
fi 

#Push the tgz spark file to slave machines
for (( i=4; i<$3+4; i++))
do
 scp /root/$spark_version-bin-hadoop$hadoop_version.tgz ${!i}:/root/
done

#untar the file
tar xvf /root/$spark_version-bin-hadoop$hadoop_version.tgz -C $installation_directory

#Edit the ~/.bash_profile file
echo "export PATH=$PATH:$installation_directory/$spark_version-bin-hadoop$hadoop_version/bin" >> ~/.bash_profile
source ~/.bash_profile

#Spark Master configuration
cd $installation_directory/$spark_version-bin-hadoop$hadoop_version
cp ./conf/spark-env.sh.template ./conf/spark-env.sh
chmod 777 ./conf/spark-env.sh
echo "SPARK_MASTER_WEBUI_PORT=$spark_webui_port" >> ./conf/spark-env.sh
echo "export SPARK_MASTER_HOST='$spark_master_IP'" >> ./conf/spark-env.sh
echo "export JAVA_HOME=$java_home" >> ./conf/spark-env.sh
#add the java path according to your environment

#Add the slaves to the slaves file in master machine configuration
cp ./conf/slaves.template ./conf/slaves
chmod 777 ./conf/slaves
sed -i '/localhost/d' ./conf/slaves
echo '' >> ./conf/slaves
j=0
for (( i=4; i<$3+4; i++ ))
do
   echo ${!i} >> ./conf/slaves
   echo "The slave  ${!i} added to the slaves file"
done


