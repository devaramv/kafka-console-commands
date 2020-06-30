#To start kafka and zookeeper in windows local

Edit log.dirs to your local path in config/server.properties 
Edit dataDir to the local path configured in config/zookeeper.properties


#Command to start zookeeper in local windows machine

cd C:/kafka_2.11-2.4.0
zookeeper-server-start.bat config/zookeeper.properties
 
 
#After the above two steps are successful start kafka

cd C:/kafka_2.11-2.4.0
kafka-server-start.bat config/server.properties 

#Below are the commands to check if the zookeeper and kafka are running or not

ps -ef | grep "zoo"
ps -ef | grep "kafka" 

#commands to start and stop zookeeper

cd C:/kafka_2.11-2.4.0

kafka-server-stop 
zookeeper-server-stop.bat
