#!bash
TMP_DB_FILE="/tmp/$$_make.db.txt"
RESULT=""

env -i `which make` -pn -f ../project.inc > $TMP_DB_FILE 2>/dev/null
while read var assign value; do
  if [[ ${var} = $1 ]] && [[ ${assign} = '=' ]]; then
    RESULT+="$value "
    break
  fi
done < $TMP_DB_FILE

rm -f $TMP_DB_FILE

echo $RESULT

