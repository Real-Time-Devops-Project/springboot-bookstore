#!/bin/sh

set -e 
echo "Setting the configuration file application to start .."
cat /opt/bookstore/application.properties.orig > application.properties
cat /vault/secrets/databaseenv.txt >> application.properties

echo "Starting Bookstore Springboot application ..."
echo "command: java -jar app.jar $@"
exec java -jar app.jar "$@"

