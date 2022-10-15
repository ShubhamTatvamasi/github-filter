#!/usr/bin/env bash

source token
GITHUB_ORG=magma
DEFAULT_MEMBERS_PER_PAGE=30

# list all members from the github organization
PAGE=1
while true; do

  MEMBERS=$(curl -s \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/orgs/${GITHUB_ORG}/members?page=${PAGE})
  
  NEW_MEMBERS=$(echo ${MEMBERS} | jq '.[].login' -r)
  GITHUB_MEMBERS="${GITHUB_MEMBERS} ${NEW_MEMBERS}"

  TOTAL_MEMBERS=$(echo ${MEMBERS} | jq '. | length')
  if [[ ${TOTAL_MEMBERS} -lt ${DEFAULT_MEMBERS_PER_PAGE} ]]; then
    break
  fi
  ((PAGE++))

done


for i in ${GITHUB_MEMBERS}
do
   echo "$i"
done


