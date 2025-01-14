#!/bin/bash

failed=false

echo "Checking containers..."
for service in $(docker-compose config --service)
do
    container="silverline-services-docker_$service_1 "
	if [ -z `docker-compose ps -q $service` ] || [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q $service)` ]; then
	  echo "$service: not running."
	  failed=true
	else
	  echo "$service: running."
	fi

done

# echo -e "\nChecking runtime..."
# if ! screen -list | grep -q "slruntime1"; then
#     echo "Runtime session not found!"
#     exit 1 
# fi


# if [[ $() -ge 2 ]]; then
# 	echo "Multiple runtimes found!"
# 	echo "Run restart again!"
# 	killall screen
# 	exit 1
# fi

# rtsessionl_log=~/silverline/applauncher-runtime/rtsession.log
# screen -S slruntime1 -X hardcopy $rtsessionl_log
# if ! cat $rtsessionl_log | grep "Runtime registration done"; then
# 	echo "Could not find runtime register msg (note this detection might fail if runtime logged a lot of messages since registration)"
# 	exit 1 
# fi

if [ "$failed" = true ] ; then
    exit 1
fi

exit 0
