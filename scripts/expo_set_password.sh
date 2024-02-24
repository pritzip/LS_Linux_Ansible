#!/bin/bash
TOKEN_FILE="$HOME/ansible/scripts/expo_token"
API_URL="https://expo.berylia.org/api"

# Make sure password is stored in 600 mode file format user:xxxx\npass:xxxx
CR14="$HOME/.ssh/cr14_pass"

! which jq >/dev/null 2>&1 && echo jq not installed && exit 1  
[ -z ${TOKEN+x} ] && [ -f $TOKEN_FILE ] && export TOKEN=$(cat $TOKEN_FILE)
[ -z ${TOKEN+x} ] && $HOME/ansible/scripts/expo_get_token.sh "$CR14"
[ -z ${TOKEN+x} ] && echo Could not get token && exit 1 
[ -z "$1" ] && echo No realm specified && exit 1
[ -z "$2" ] && echo No username specified && exit 1
[ -z "$3" ] && echo No password specified && exit 1
! grep -q ";$1;" $HOME/ansible/scripts/expo_realm.db && echo Non existent realm $1 && exit 1
! (grep "$1" $HOME/ansible/Users.csv | grep -q ";$2;") && echo Non existent user $2 && exit 1

### UPDATE CREDENTIAL, realm and username are case sensitive
json='
{
  "variables":{"realm":"__REALM__","username":"__USER__","password":"__PASS__"},
  "query":"mutation UpdateCredentialPassword( $realm: String!, $username: String!, $password: String! ) {
    updateCredentialPassword( realm: $realm, username: $username, password: $password ) {
      realm
      username
      password
      team
      updated_time
    }
  }"
}
'
json=${json/__REALM__/"$1"}
json=${json/__USER__/"$2"}

### RUN QUERY
echo ${json/__PASS__/"$3"} | curl "$API_URL" \
  --insecure \
  -H 'Content-Type: application/json' -H 'Accept: application/json' \
  -H "Authorization: Bearer ${TOKEN}" \
  --data-binary @- | jq
