#!/bin/bash

echo -e "Restarting containers... \n"
docker-compose down 2> /dev/null
docker-compose up -d 2> /dev/null
docker-compose ps

echo -e "\nRestarting runtime...\n"
(cd ~/silverline/applauncher-runtime; ./stop-runtime1.sh; ./start-runtime1.sh 2>&1) > /dev/null

screen -list | grep "slruntime"

echo -e "\nRestart done."
