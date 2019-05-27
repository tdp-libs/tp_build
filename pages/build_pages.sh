#!/bin/bash

set -e

SOURCES_DIR=$1
TEMPLATE=$2

export WINDOW_TITLE="aaa"
export PAGE_TITLE="bbb"

for var in "${@:3}"
do
  filename=$(basename -- "$var")
  extension="${filename##*.}"
  filename="${filename%.*}"

  if [ $extension = "html" ]; then
    tmp=`cat "$var"`
    eval $filename=\$tmp
    export $filename
  fi
done

/home/tom/Desktop/mo ${TEMPLATE} -u > result.html

