#!/bin/bash

# KEYWORDS
USERNAME="username"
XAUTHKEY="authkey"
DOMAINNAME="domainname"
SERVERNAME="servername"
TARGETNAME="targetname"
TTL="60"

echo "Dozens Alias IP Address setter version 0.1"

# Get Global IP address
GLOBALIP=$(dig +short $TARGETNAME)
echo "Your Target IP Address is $GLOBALIP"$'\n'

# auth initialization
echo "auth initialization start."
MYKEY=$(curl -s http://dozens.jp/api/authorize.json -H X-Auth-User:$USERNAME -H X-Auth-Key:$XAUTHKEY |sed 's/[{"}:]//g' | sed 's/auth_token//')
echo "Your key is : $MYKEY"$'\n'

# Get wikiserver id
echo "Serching $SERVERNAME record..."
LINENUMBER=$(echo $(expr $(curl -s http://dozens.jp/api/record/$DOMAINNAME.json -H X-Auth-Token:$MYKEY | tr "," "\n" | grep -n $SERVERNAME | sed 's/[a-z":.]//g') - 1)"p")

RECORDID=$(curl -s http://dozens.jp/api/record/$DOMAINNAME.json -H X-Auth-Token:$MYKEY | tr "," "\n" | sed -n $LINENUMBER | sed -e 's/[a-z,",{,},:,.,\[]//g')
echo "$SERVERNAME record id is $RECORDID""."$'\n'

# Set IP Address
echo "Recode update in progress..."
RESULT=$(curl -s -d "{\"prio\":\"\", \"content\":\"$GLOBALIP\", \"ttl\":\"$TTL\"}" http://dozens.jp/api/record/update/$RECORDID.json -H X-Auth-Token:$MYKEY -H "Host: dozens.jp" -H "Content-Type:application/json" | sed -e 's/\[/\[ /g' -e 's/\]/ \]/g' -e 's/},{/} {/g' | tr " " "\n" | grep $RECORDID)
echo "Dozens server says : $RESULT"$'\n'
echo "Script is done!"$'\n'