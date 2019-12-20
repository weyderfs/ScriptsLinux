#!/bin/bash

#Cleaning EC2
INSTANCES=$(aws ec2 describe-instances --filters  "Name=instance-state-name,Values=stopped" "Name=tag-value,Values=rundeck-teradata" --query 'Reservations[].Instances[].[InstanceId]' --output text)

for x in $INSTANCES;  do echo  aws ec2 terminate-instances --instance-ids $x --output text; done

#Cleaning Volumes left by EC2 terminated
VOLUMES=$(aws ec2 describe-volumes --filters "Name=status,Values=available" "Name=tag-value,Values=rundeck-teradata" --query 'Volumes[].[VolumeId]' --output text)

for x in $VOLUMES;  do echo  aws ec2 delete-volume --volume-id $x --output text; done

#Cleaning Security groups from EC2 Terminated
AWSSG=$(aws ec2 describe-security-groups --filters Name=group-name,Values=terraform-* Name=tag:Product,Values=rundeck-teradata --query "SecurityGroups[*].{ID:GroupId}" --output text)

for x in $AWSSG;  do aws ec2 delete-security-group --group-id $x --output text; done
