#!/bin/bash

BASEDIR=$(cd $(dirname $0) && pwd)
docker run -it --rm -p 4567:4567 -v "${BASEDIR}":/usr/src/myapp -w /usr/src/myapp supply ruby server.rb
