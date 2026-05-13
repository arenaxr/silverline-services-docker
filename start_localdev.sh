#!/bin/bash

echo -en "\nStarting (Local Dev Mode): \n"
echo -en "\t services..."
docker-compose -f docker-compose.yaml -f docker-compose.localdev.yaml up --build -d 2> /dev/null
echo -en "done.\n\n## Services running:\n\n"
docker-compose -f docker-compose.yaml -f docker-compose.localdev.yaml ps
