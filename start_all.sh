#!/bin/bash

echo -en "\nStarting: \n"
echo -en "\t services..."
docker-compose up -d 2> /dev/null
echo -en "done.\n\n## Services running:\n\n"
docker-compose ps
