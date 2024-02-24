#!/bin/bash
TOKEN_FILE="$HOME/ansible/scripts/expo_token"
USERNAME="$1"
PASSWORD="$2"

! which jq >/dev/null 2>&1 && echo jq not installed && exit 1  

if [[ -z "$2" && -f "$1" ]]; then
  USERMAME=$(grep user: $1 | cut -d: -f2)
  PASSWORD=$(grep pass: $1 | cut -d: -f2)
fi  

CLIENT_ID="ls22-expo"

while [[ -z "$USERNAME" || -z "$PASSWORD" ]]; do
  echo "Username or password missing. Please enter them now"
  read -p 'Username: ' USERNAME
  read -sp 'Password: ' PASSWORD
  echo ""
done;

KEYCLOAK_URL=https://login.cr14.net/auth/realms/LS22-EXPO/protocol/openid-connect/token

### GET TOKEN VIA STANDARD FLOW
export TOKEN=$(curl -X POST "$KEYCLOAK_URL" \
  --insecure \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=$USERNAME" \
  --data-urlencode "password=$PASSWORD" \
  -d 'grant_type=password' \
  -d "client_id=$CLIENT_ID" | jq -r '.access_token')

echo $TOKEN>$TOKEN_FILE
