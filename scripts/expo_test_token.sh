#!/bin/bash
TOKEN_FILE="$HOME/ansible/scripts/expo_token"
KEYCLOAK_URL=https://login.cr14.net/auth/realms/LS22-EXPO/protocol/openid-connect/userinfo
! which jq >/dev/null 2>&1 && echo jq not installed && exit 1  
[ ! -f $TOKEN_FILE ] && echo no token found && exit 1
export TOKEN=$(cat $TOKEN_FILE)
[ -z ${TOKEN+x} ] && echo Could not get token && exit 1 
echo "==============================================================================================="
echo "TESTING TOKEN:"
echo $TOKEN
echo "==============================================================================================="
curl -X GET "$KEYCLOAK_URL" \
-H "Content-Type: application/x-www-form-urlencoded" \
-H "Authorization: Bearer ${TOKEN}" | jq
echo "==============================================================================================="
