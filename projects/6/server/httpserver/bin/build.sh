#! /bin/bash

COMPILE_TIME=`date +"%Y-%m-%d %H:%M:%S"`
PLATFORM=`uname -mrs`

set -x
go build -ldflags "-X  \"main.COMPILE_TIME=$COMPILE_TIME\"  \
        -X \"main.PLATFORM=$PLATFORM\"  "  monkserver.go
set +x