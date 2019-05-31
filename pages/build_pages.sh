#!/bin/bash

set -e

SOURCES_DIR=$1
TEMPLATE=$2
ROOT_URL=$3

export WINDOW_TITLE="aaa"
export PAGE_TITLE="bbb"
export ROOT_URL

for var in "${@:4}"
do
  filename=$(basename -- "$var")
  extension="${filename##*.}"
  filename="${filename%.*}"

  if [ $extension = "html" ]; then
    tmp=`cat "$var"`
    eval $filename=\$tmp
    export $filename
  fi

  if [ $extension = "md" ]; then
    tmp=`pandoc "$var"`
    eval $filename=\$tmp
    export $filename
  fi

done

mo ${TEMPLATE} -u > result1.html
mo result1.html -u > result2.html
mv result2.html result.html
