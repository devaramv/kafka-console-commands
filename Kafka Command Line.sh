-------------------------------------------------Besic regular Operations in Kafka CLI-------------------------------------

#Note: In kafka you cannot create a topic with a replication factor > number of brokers

# Following command helps creating a kafka topic

kafka-topics --bootstrap-server localhost:9092 --topic first_topic --create --partitions 3 --replication-factor 1

#Following commands will list all the existing topics

kafka-topics --bootstrap-server localhost:9092 --list

#Following command will describe kafka topic information

kafka-topics --bootstrap-server localhost:9092 --topic first_topic --describe

#Following command will delete an existing kafka topic

kafka-topics --bootstrap-server localhost:9092 --topic first_topic --delete 
	
	
-------------------------------------------------Kafka Console Producer CLI-------------------------------------

# Following command will prompt uses to enter messages

kafka-console-producer  --broker-list 127.0.0.1:9092 --topic first_topic

# Following command will prompt uses to enter messages with acknowledgements

kafka-console-producer  --broker-list 127.0.0.1:9092 --topic first_topic --producer-property acks=all



---------------------------------------------Kafka Console Consumer CLI-------------------------------------

# Following command will allow to consume messages from a topic that are producer from the point of time in which the console consumer starts running

kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic


# Following command will allow to consume messages in a kafka topic from the beginning

kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic --from-beginning

Note: when you run the above commands, the order of the messages in this consumer is not "total", the order is per partition.
Because "first_topic" was created with 3 partitions, we saw in the theory lectures that the order is only guaranteed at the 
partition level. if you try with a topic with 1 partition, you will see total ordering 

 

---------------------------------------------Kafka Console Consumers in group mode--------------------------

kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic --group my-first-application


kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic --group my-second-application --from-beginning

#kill the above command after running for a while then start the consumer again. Doing this, kafka-console-consumer will start reading
#messages from the last stored offset. In this case with group id specified even if one uses --from-beginning consumer wont read from
#the beginning

# Also as shown below, if you one uses same groupid for multiple consumers, each consumer reads data from certain paritions. 


kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic --group my-second-application 
kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic --group my-second-application 
kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic --group my-second-application 


#Play with console-producer and console-consumer with multiple different scenario

----------------------------------------------------Kafa Consumer Groups---------------------------------------

#This tool helps to list all consumer groups, describe a consumer group, delete consumer group info, or reset consumer group offsets.

# Following commands lists all the consumergroups 
kafka-consumer-groups --bootstrap-server localhost:9092 --list

#To know more about the consumer group
kafka-consumer-groups --bootstrap-server localhost:9092 --group my-first-application --describe

# Following is the output of consumer group describe.LOG-END-OFFSET indicates if all the messages have been already consumed by the consumer or not. LAG 0
# means that kafka conumer has read all the data from that particulat partition.If LOG-END-OFFSET is >0 which means the consumer with that specific group id is 
# still yet to get caught up that many number of messages from a partition.

# Second table indicates the the partitions with LAG. In this case consumer is yet to consumer 2 messages from partition 0, 2 from partition 1 and 3 from parition 3
  

GROUP                 TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                     HOST            CLIENT-ID
my-second-application first_topic     0          21              21              0               consumer-1-95324702-46f2-45bb-aa31-3eeae710865c /19.53.31.64    consumer-1
my-second-application first_topic     1          20              20              0               consumer-1-95324702-46f2-45bb-aa31-3eeae710865c /19.53.31.64    consumer-1
my-second-application first_topic     2          20              20              0               consumer-1-95324702-46f2-45bb-aa31-3eeae710865c /19.53.31.64    consumer-1



GROUP                 TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
my-second-application first_topic     0          19              21              2               -               -               -
my-second-application first_topic     1          18              20              2               -               -               -
my-second-application first_topic     2          17              20              3               -               -               -



----------------------------------------------------Resetting Kafka Offsets------------------------------------------------

# Following command will reset current offets to 0 (--to-earliest means start from the beginning)

kafka-consumer-groups --bootstrap-server localhost:9092 --topic first_topic --group my-first-application --reset-offsets --to-earliest --execute

kafka-consumer-groups --bootstrap-server localhost:9092 --topic first_topic --group my-first-application --reset-offsets --shift-by -2 --execute

kafka-consumer-groups --bootstrap-server localhost:9092 --group my-first-application --describe

#Before applying --shift-by -2

GROUP                TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                     HOST            CLIENT-ID
my-first-application first_topic     0          21              21              0               consumer-1-51e766ef-06f2-4cf2-a93f-8bfd39cff583 /19.53.31.64    consumer-1
my-first-application first_topic     1          20              20              0               consumer-1-51e766ef-06f2-4cf2-a93f-8bfd39cff583 /19.53.31.64    consumer-1
my-first-application first_topic     2          20              20              0               consumer-1-51e766ef-06f2-4cf2-a93f-8bfd39cff583 /19.53.31.64    consumer-1

kafka-consumer-groups --bootstrap-server localhost:9092 --group my-first-application --describe
#After applying shift-by 2

GROUP                TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
my-first-application first_topic     0          19              21              2               -               -               -
my-first-application first_topic     1          18              20              2               -               -               -
my-first-application first_topic     2          18              20              2               -               -               -


#Note: Updating the offsets needs to done when the consumer is not running





