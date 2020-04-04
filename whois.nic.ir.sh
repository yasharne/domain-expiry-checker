#!/bin/bash
# Author: Yashar Nesabian (yasharne)

DOMAINS="snapp.ir"
WHOIS_URL="whois.nic.ir"
EXPIRY_TEXT="expire-date"

declare -A RESULT

for d in $DOMAINS 
do
    WHOIS_OUTPUT=$(whois -h $WHOIS_URL $d)
    if [[ "$WHOIS_OUTPUT" == *"$EXPIRY_TEXT"* ]]
    then
        EXPIRY=$(date -d $(echo "$WHOIS_OUTPUT" | grep "$EXPIRY_TEXT" | awk '{print $2}') +%s)
    else
        EXPIRY=0
    fi
    REMAIN_TO_EXPIRE=$(expr $EXPIRY - $(date +%s))
    RESULT[$d]=$REMAIN_TO_EXPIRE
done
JSONOUTPUT=''
COUNTER=0
for x in "${!RESULT[@]}" 
do 
    TMP="\""$x"\": "${RESULT[$x]}""
    JSONOUTPUT="${JSONOUTPUT}${TMP}"
    let "COUNTER+=1"
    if [ ${#RESULT[@]} -ne $COUNTER ]
    then
        JSONOUTPUT="${JSONOUTPUT},"
    fi
    
done
echo  '{"labels": {"whois": "'$WHOIS_URL'"}, "results": {'$JSONOUTPUT'}}'
exit 0