#!/bin/bash

INPUT_RELEASE=$1
GITHUB_TOKEN=$2

RELEASE_DATE=$(curl -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/elementor/elementor/releases/tags/$INPUT_RELEASE" | jq -r '.published_at')
echo "name=RELEASE_DATE::$RELEASE_DATE"
