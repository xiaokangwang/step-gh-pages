#!/bin/sh

# confirm environment variables
if [ ! -n "$WERCKER_GH_PAGES_DO_NOT_USE_TOKEN" ]
then
  fail "missing option \"token\", aborting"
fi

# use repo option or guess from git info
if [ -n "$WERCKER_GH_PAGES_DO_NOT_USE_REPO" ]
then
  repo="$WERCKER_GH_PAGES_DO_NOT_USE_REPO"
elif [ 'github.com' == "$WERCKER_GIT_DOMAIN" ]
then
  repo="$WERCKER_GIT_OWNER/$WERCKER_GIT_REPOSITORY"
else
  fail "missing option \"repo\", aborting"
fi

info "using github repo \"$repo\""

# remote path
remote="https://$WERCKER_GH_PAGES_DO_NOT_USE_TOKEN@github.com/$repo.git"

info $remote

# if directory provided, cd to it
if [ -d "$WERCKER_GH_PAGES_DO_NOT_USE_BASEDIR" ]
then
  cd $WERCKER_GH_PAGES_DO_NOT_USE_BASEDIR
fi

# remove existing commit history
rm -rf .git

# generate cname file
if [ -n $WERCKER_GH_PAGES_DO_NOT_USE_DOMAIN ]
then
  echo $WERCKER_GH_PAGES_DO_NOT_USE_DOMAIN > CNAME
fi


# setup branch
branch="gh-pages"
if [[ "$repo" =~ $WERCKER_GIT_OWNER\/$WERCKER_GIT_OWNER\.github\.(io|com)$ ]]; then
	branch="master"
fi


# init repository
git init

git config user.email "pleasemailus@wercker.com"
git config user.name "werckerbot"

git add .
git commit -m "deploy from $WERCKER_STARTED_BY"
result="$(git push -f https://$WERCKER_GH_PAGES_DO_NOT_USE_TOKEN@github.com/$repo.git master:$branch)"

if [[ $? -ne 0 ]]
then
  warning "$result"
  fail "failed pushing to github pages"
else
  success "pushed to github pages"
fi
