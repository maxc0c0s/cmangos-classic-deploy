#!/bin/bash

BUILD_ROOT="/tmp"

if [ -z $COMMIT_CMANGOS ]
then
  echo 'You need to specify the $COMMIT_CMANGOS environment variable, which is the desired cmangos/mangos-classic commit sha.'
  exit
fi
if [ -z $COMMIT_ACID ]
then
  echo 'You need to specify the $COMMIT_ACID environment variable, which is the desired ACID-Scripts/Classic commit sha.'
  exit
fi
if [ -z $COMMIT_DB ]
then
  echo 'You need to specify the $COMMIT_DB environment variable, which is the desired classicdb/database commit sha.'
  exit
fi

echo "TODO ******************Compiling*************************"

CMANGOS_DIR="$BUILD_ROOT/mangos-classic"
cd $BUILD_ROOT
git clone https://github.com/cmangos/mangos-classic.git $CMANGOS_DIR
cd $CMANGOS_DIR
git reset --hard $COMMIT_CMANGOS
cd $BUILD_ROOT

ACID_DIR="$BUILD_ROOT/acid"
git clone git://github.com/ACID-Scripts/Classic.git $ACID_DIR
cd $ACID_DIR
git reset --hard $COMMIT_ACID
cd $BUILD_ROOT

CLASSIC_DB_DIR="$BUILD_ROOT/classicdb"
git clone git://github.com/classicdb/database.git $CLASSIC_DB_DIR
cd $CLASSIC_DB_DIR
git reset --hard $COMMIT_DB
cd $BUILD_ROOT

BUILD_DIR="$BUILD_ROOT/build"
BIN_DIR="$BUILD_ROOT/bin"
mkdir -p $BUILD_DIR
mkdir -p $BIN_DIR

cd $BUILD_DIR
cmake $CMANGOS_DIR -DCMAKE_INSTALL_PREFIX=$BIN_DIR -DPCH=0 -DDEBUG=0
make
make install
cd $BUILD_ROOT

tar -cvzf cmangos-classic-0.18.48.tar.gz bin
mkdir -p /tmp/configs
cp mangos-classic/src/mangosd/mangosd.conf.dist.in configs/mangosd.conf
cp mangos-classic/src/realmd/realmd.conf.dist.in configs/realmd.conf
cp mangos-classic/src/game/AuctionHouseBot/ahbot.conf.dist.in configs/ahbot.conf
tar -cvzf cmangos-classic-configs-0.18.48.tar.gz configs

echo "TODO Deploying"

exec $@
