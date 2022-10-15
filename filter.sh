#!/usr/bin/env bash

source token
GITHUB_ORG=magma
GITHUB_REPO=magma
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

# list last commit from all users
for AUTHOR in ${GITHUB_MEMBERS}
do
  COMMITS=$(curl -s \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  https://api.github.com/repos/${GITHUB_ORG}/${GITHUB_REPO}/commits?author=${AUTHOR})
  COMMIT_DATE=$(echo ${COMMITS} | jq '.[0].commit.author.date' -r)
  COMMIT_URL=$(echo ${COMMITS} | jq '.[0].html_url' -r)
  echo "${COMMIT_URL} | ${COMMIT_DATE} | ${AUTHOR}"

done
