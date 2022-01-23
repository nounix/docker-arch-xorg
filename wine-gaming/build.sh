#!/bin/bash

BASE_DIR="$(dirname "$(readlink -f "$0")")"

docker build -t wine-gaming $BASE_DIR
