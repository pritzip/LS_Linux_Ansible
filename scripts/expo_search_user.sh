#!/bin/bash
TOKEN_FILE="$HOME/ansible/scripts/expo_token"
API_URL="https://expo.berylia.org/api"

# Make sure password is stored in 600 mode file format user:xxxx\npass:xxxx
CR14="$HOME/.ssh/cr14_pass"

! which jq >/dev/null 2>&1 && echo jq not installed && exit 1  
[ -z ${TOKEN+x} ] && [ -f $TOKEN_FILE ] && export TOKEN=$(cat $TOKEN_FILE)
[ -z ${TOKEN+x} ] && ~/ansible/scripts/expo_get_token.sh "$CR14"
[ -z ${TOKEN+x} ] && echo Could not get token && exit 1 
[ -z "$1" ] && echo "No user(s) specified" && exit 1


### GET CREDENTIALS WITH FILTERS
json='
{
  "variables":{
    "limit": 100,
    "filters": {
      "readonly": [ false ]
    },
    "search": "__USERS__",
    "sort": [
      {
        "by": "realm",
        "order": "desc"
      }
    ]
  },
  "query":"query Credentials($limit: Int, $filters: CredentialQueryFiltersInput, $sort: [QuerySortArgsInput!], $search: String) {
    credentials(limit: $limit, filters: $filters, sort: $sort, search: $search) {
      _id
      realm
      readonly
      email
      department
      display_name
      username
      password
      domain
      description
      team
      has_services
      services {
        uri
        description
        systems
        uris
      }
      updated_time
    }
  }"
}
'

### RUN QUERY
echo ${json/__USERS__/"$1"} | curl "$API_URL" \
  --insecure \
  -H 'Content-Type: application/json' -H 'Accept: application/json' \
  -H "Authorization: Bearer ${TOKEN}" \
  --data-binary @- | jq
