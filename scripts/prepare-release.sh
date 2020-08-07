#!/bin/bash -u

git diff HEAD~..HEAD -- package-lock.json | grep -q '"version":'

if [ $? = 0 ]; then
  echo start release flow

  # setup git
  git config user.name "8398a7"
  git config user.email "8398a7@gmail.com"

  tag=$(git diff HEAD~..HEAD -- package-lock.json | grep version | tail -n 1 | cut -d'"' -f4)

  # release flow
  git checkout v3
  git merge origin/master
  npm install
  npm run release
  git add -A
  git commit -m '[command] npm run release'
  git remote add github "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
  git push github v3

  # push tag
  git tag $tag
  git push github --tags
fi
