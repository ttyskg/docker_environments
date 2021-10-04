#!/bin/bash

UID=`id -u`
GID=`id -g`

echo "UID=${UID}" >> .env
echo "GID=${GID}" >> .env
