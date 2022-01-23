#!/bin/bash

xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth nmerge -

docker start -ai wine-gaming
