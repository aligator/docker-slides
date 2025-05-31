#!/usr/bin/env sh

cp /run-original.sh /srv/app/run.sh
sed -i "s/\${SOURCE_PROTOCOL}/${SOURCE_PROTOCOL}/g" /srv/app/run.sh
sed -i "s/\${SOURCE_HOST}/${SOURCE_HOST}/g" /srv/app/run.sh
sed -i "s/\${SOURCE_PORT}/${SOURCE_PORT}/g" /srv/app/run.sh 


rm -rf /repos
mkdir /repos
git init --bare /repos/docker-slides.git
touch /repos/docker-slides.git/git-daemon-export-ok

cd app
git init
git config user.email "me@aligator.dev"
git config user.name "aligator"
git add .
git commit -m "init"
git push --force /repos/docker-slides.git master
rm -rf .git
cd ..

exec "$@"