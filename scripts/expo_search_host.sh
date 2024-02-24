#!/bin/bash
TOKEN_FILE="$HOME/ansible/scripts/expo_token"
API_URL="https://expo.berylia.org/api"

# Make sure password is stored in 600 mode file format user:xxxx\npass:xxxx
CR14="$HOME/.ssh/cr14_pass"

! which jq >/dev/null 2>&1 && echo jq not installed && exit 1  
[ -z ${TOKEN+x} ] && [ -f $TOKEN_FILE ] && export TOKEN=$(cat $TOKEN_FILE)
[ -z ${TOKEN+x} ] && ~/ansible/scripts/expo_get_token.sh "$CR14"
[ -z ${TOKEN+x} ] && echo Could not get token && exit 1 
[ -z "$1" ] && echo "No host(s) specified" && exit 1

### GET SYSTEMS WITH FILTERS

json='
{
"variables":{
  "limit": 500,
  "sort": [
    {
      "by": "expo_id",
      "order": "asc"
    }
  ],
  "search": "__HOSTS__",
  "filters": {
    "availability_status": [
      "OK", "WARNING", "CRITICAL", "UNKNOWN"
    ],
    "has_services": [
      true,
      false
    ],
    "os": [],
    "team_name": ["blue"],
    "zones": []
  }
},
"query":"query Systems($limit: Int, $sort: [QuerySortArgsInput!], $search: String, $filters: SystemQueryFiltersInput) {
    systems(limit: $limit, sort: $sort, search: $search, filters: $filters) {
      _id
      expo_id
      hostname
      hostname_common
      description
      has_services
      team
      team_name
      domain
      zones
      os
      ansible_role
      network_interfaces {
        network_id
        cloud_id
        domain
        fqdn
        egress
        connection
        addresses {
          mode
          connection
          address
          address_without_subnet
          subnet
          gateway
        }
      }
      availability_status
      availability_change_time
      service_checks {
        availability_id
        availability_status
        availability_change_time
        availability_check_output
        service_name
        source_network_id
        special
        protocol
        ip
        port
      }
    }
  }"
}
'

### RUN QUERY
echo ${json/__HOSTS__/"$1"} | curl "$API_URL" \
  --insecure \
  -H 'Content-Type: application/json' -H 'Accept: application/json' \
  -H "Authorization: Bearer ${TOKEN}" \
  --data-binary @- | jq
