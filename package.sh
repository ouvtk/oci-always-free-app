#!/bin/bash
set -euo pipefail

echo "Needs a zip archiver and a docker compose."

# Attempt to support an old and a new convention for a docker-compose plugin.
if command -v docker-compose &> /dev/null
then
    docker-compose -f app/docker-compose.yml up
else
    docker compose -f app/docker-compose.yml up
fi

EXECUTABLE_PATH=app/_build/the-app
# No errors were caught before, checking if the application is built.
if [ ! -f "$EXECUTABLE_PATH" ]
then
    echo "Looks like the application wasn't built."
    exit
fi

# Packaging everything into a zip file.
ARCHIVE_NAME=oci-always-free-app.zip
zip -r $ARCHIVE_NAME *.tf scripts $EXECUTABLE_PATH