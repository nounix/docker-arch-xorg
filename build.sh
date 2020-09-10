#!/bin/bash

BASE_DIR="$(dirname "$(readlink -f "$0")")"

docker build -t arch-dev --build-arg USER=$USER --build-arg DISABLE_CACHE="$(date)" $BASE_DIR
