#!/bin/bash

TMP_DB_FILE="/tmp/$$_make.db.txt"
RESULT=""

env -i `which make` -pn -f ../tp_build/cmake/parse_dependencies.pri > $TMP_DB_FILE 2>/dev/null
while read var assign value; do
  if [[ ${var} = $1 ]] && [[ ${assign} = '=' ]]; then
    RESULT+="$value "
    break
  fi
done < $TMP_DB_FILE

if [[ -z "${TP_CONFIG}" ]]; then
  PROJECT_INC="../project.inc"
else
  PROJECT_INC="../${TP_CONFIG}"
fi

env -i `which make` -pn -f ${PROJECT_INC} > $TMP_DB_FILE 2>/dev/null
while read var assign value; do
  if [[ ${var} = $1 ]] && [[ ${assign} = '=' ]]; then
    RESULT+="$value "
    break
  fi
done < $TMP_DB_FILE

rm -f $TMP_DB_FILE

echo $RESULT

