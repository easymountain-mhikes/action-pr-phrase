#!/bin/sh

PHRASE_BRANCH="phrase/update"

echo "INFO: Getting existing branch"
git checkout -b "$PHRASE_BRANCH" "origin/$PHRASE_BRANCH"
BRANCH_ALREADY_EXISTS=$?
if [ "$BRANCH_ALREADY_EXISTS" != "0" ]
then
  echo "INFO: Branch already exists, check it out"
  git checkout -b "$PHRASE_BRANCH"
fi

phrase pull
git diff --quiet
NO_CHANGES=$?

if [ "$NO_CHANGES" != "0" ]
then
  echo "INFO: New Phrase strings to commit..."
  git config user.name github-actions
  git config user.email github-actions@github.com

  git add --all
  git commit --message "DO-OO feat: update phrase" --no-verify
  git push origin "$PHRASE_BRANCH" --no-verify

  if [ "$BRANCH_ALREADY_EXISTS" = "0" ]
  then
    echo "INFO: Create new Pull Request..."
    gh pr create -B main -H phrase/update --title 'DO-OO feat: Update Phrase strings' --body 'Created by Github action'
  else
    echo "INFO: No need to create Pull Request"
  fi
else
  echo "INFO: No new Phrase strings!"
fi