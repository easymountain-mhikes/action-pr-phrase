#!/bin/sh
phrase pull
git diff --quiet
if [ "$?" != "0" ]
then
  echo "New Phrase strings to commit..."
  git checkout -b phrase/update
  git config user.name github-actions
  git config user.email github-actions@github.com
  git add --all
  git commit --message "DO-OO feat: update phrase" --no-verify
  git push origin phrase/update --no-verify
  gh pr create -B main -H phrase/update --title 'DO-OO feat: Update Phrase strings' --body 'Created by Github action'
else
  echo "No new Phrase strings!"
fi