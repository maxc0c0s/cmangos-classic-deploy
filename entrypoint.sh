#!/bin/bash

if [ -z $COMMIT]
then
  echo 'You need to specify the $COMMIT environment variable, which is the desired cmangos/mangos-classic commit sha.'
  exit
fi

echo "TODO Compiling"
git clone https://github.com/cmangos/mangos-classic.git /tmp/mangos-classic
cd /tmp/mangos-classic
git reset --hard $COMMIT

echo "TODO Deploying"

exec $@
