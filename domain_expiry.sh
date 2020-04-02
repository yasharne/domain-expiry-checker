#!/bin/bash

DOMAINS="snapp.ir"
WHOIS_URL="whois.nic.ir"
# One month
# EXPIRY_ALERT=2592000
EXPIRY_ALERT=30240000

for d in $DOMAINS 
do
    WHOIS_OUTPUT=''
    retry=true
    while [ $retry != false ]
    do
        WHOIS_OUTPUT=$(whois -h $WHOIS_URL $d)
        if [ $? -eq 0 ]
        then
            retry=false
        fi
    done
    EXPIRY=$(date -d $(echo "$WHOIS_OUTPUT" | grep expire-date | awk '{print $2}') +%s)
    REMAIN_TO_EXPIRE=$(expr $EXPIRY - $(date +%s))
    echo $REMAIN_TO_EXPIRE
    if [ $REMAIN_TO_EXPIRE -le $EXPIRY_ALERT ]
    then
        echo "$d is expiring in $(expr $REMAIN_TO_EXPIRE / 86400) days"
    fi
done
