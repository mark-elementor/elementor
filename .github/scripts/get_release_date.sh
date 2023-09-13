#!/bin/bash

RESPONSE=$(curl -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/elementor/elementor/releases/tags/$INPUT_RELEASE")

echo "DEBUG: Full response from API: $RESPONSE" # For debugging

RELEASE_DATE=$(echo "$RESPONSE" | jq -r '.published_at')

echo "DEBUG: Extracted RELEASE_DATE: $RELEASE_DATE" # For debugging

echo "RELEASE_DATE=$RELEASE_DATE" >> $GITHUB_ENV
