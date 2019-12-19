#!/bin/bash
INSTANCES=$(aws ec2 describe-instances --filters  "Name=instance-state-name,Values=stopped" "Name=tag-value,Values=rundeck-teradata" --query 'Reservations[].Instances[].[InstanceId]' --output text)

for x in $INSTANCES;  do echo  aws ec2 terminate-instances --instance-ids $x --output text; done