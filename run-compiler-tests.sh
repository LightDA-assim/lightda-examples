#!/bin/sh

set -e

LOCAL_REPO_DIR=/Users/jhaiduce/Development/repositories

docker build -t lightda-examples-src -f Dockerfile.src .
docker build -t lightda-examples-dependency-repos -f Dockerfile.repos $LOCAL_REPO_DIR
docker build --progress=plain compiler-tests/gcc/10.2.0
