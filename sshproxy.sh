#!/bin/sh

docker run -it -v $1:/root/.ssh -e SSH=$2 proxytunnel

