#!/bin/bash

echo -en "\nStopping: \n"
echo -en "\t services..."
docker-compose down 2> /dev/null
echo -en "done.\n\t runners..."
(docker kill `docker ps | grep 'slruntime-.*-runner' | cut -d" " -f1` 2>&1) > /dev/null 
echo -en "done.\n\n"
