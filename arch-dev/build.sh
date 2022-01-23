#!/bin/bash

BASE_DIR="$(dirname "$(readlink -f "$0")")"

docker build -t arch-dev --build-arg USER=$USER $BASE_DIR
