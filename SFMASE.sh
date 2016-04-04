#!/bin/bash

ADMINMAIL='destination@domain.com'
DATE=$(date +'%Y%m%d')
FILENAME="SFMASE_$DATE.log"
PINGPROGRAM='/usr/lib64/nagios/plugins/check_tcp'
MAILPROGRAM='/bin/mail'

while read IP;
do
  IP="`cut -d\| -f 1 hosts.txt`"
  PING=$($PINGPROGRAM -H $IP -p 80)
  HOUR=$(date +'%H:%M:%S')
  if [[ -n $PING ]] ;
    then echo "$HOUR - $IP - OK" >> $FILENAME ;
    else
      echo "$HOUR - $IP - FAIL" >> $FILENAME;
      echo "$IP - is DOWN ($DATE $HOUR)" | $MAILPROGRAM -s "$IP is DOWN" $ADMINMAIL
  fi
  //
done < hosts.txt

