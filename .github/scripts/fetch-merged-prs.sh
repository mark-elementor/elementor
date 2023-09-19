#!/bin/bash

echo "PR Title,PR Link,PR Owner,Jira Task URL" > merged_prs.csv

INPUT_BRANCH=$1
RELEASE_DATE=$2
GITHUB_TOKEN=$3
PAGE=1

while : ; do
  response=$(curl -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/elementor/elementor/pulls?state=closed&base=$INPUT_BRANCH&per_page=100&page=$PAGE")

	echo "$response"

  echo "$response" | jq -r --arg RELEASE_DATE "$RELEASE_DATE" '
    def construct_jira_url(tid):
      if tid | test("^[A-Za-z]{2,4}-\\d{4,6}$") then "https://elementor.atlassian.net/browse/" + tid
      elif tid | test("^\\d{4,6}$") then "https://elementor.atlassian.net/browse/ED-" + tid
      else "" end;

    .[]
    | select(.merged_at != null and .merged_at > $RELEASE_DATE)
    | {
        title: (.title | gsub(" \\[([A-Za-z]{2,4}-)?\\d{4,6}\\]"; "")),
        url: .html_url,
        login: .user.login,
        task_id: (.title | match("\\[([A-Za-z]{2,4}-)?\\d{4,6}\\]") | .string | gsub("\\[|\\]"; ""))
      }
    | [ .title, .url, .login, (construct_jira_url(.task_id)) ]
    | @csv
  ' >> merged_prs.csv

  [[ ! $(echo "$response" | grep -Fi Link | grep '<[^>]*>; rel="next"') ]] && break

  ((PAGE++))
done
