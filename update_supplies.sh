#!/bin/bash

BASEDIR=$(cd $(dirname $0) && pwd)
docker run -it --rm -v "$BASEDIR":/usr/src/myapp -w /usr/src/myapp supply rake supplies
