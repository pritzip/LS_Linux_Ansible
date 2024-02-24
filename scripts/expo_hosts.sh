#!/bin/bash
TOKEN_FILE="$HOME/ansible/scripts/expo_token"
API_URL="https://expo.berylia.org/api"

# Make sure password is stored in 600 mode file format user:xxxx\npass:xxxx
CR14="$HOME/.ssh/cr14_pass"

! which jq >/dev/null 2>&1 && echo jq not installed && exit 1  
[ -z ${TOKEN+x} ] && [ -f $TOKEN_FILE ] && export TOKEN=$(cat $TOKEN_FILE)
[ -z ${TOKEN+x} ] && ~/ansible/scripts/expo_get_token.sh "$CR14"
[ -z ${TOKEN+x} ] && echo Could not get token && exit 1 

echo $TOKEN_FILE $TOKEN

json='{ "query":"query Systems { systems { expo_id } }"}'
### RUN QUERY
echo $json | curl "$API_URL" \
  --insecure \
  -H 'Content-Type: application/json' -H 'Accept: application/json' \
  -H "Authorization: Bearer ${TOKEN}" \
  --data-binary @- | jq
