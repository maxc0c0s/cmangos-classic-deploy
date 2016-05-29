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
if [ -z $CMANGOS_VERSION ]
then
  echo 'You need to specify the $CMANGOS_VERSION environment variable, which is the cmangos/mangos-classic version'
  exit
fi
DEPLOY_FILE="deploy.sh"
if [ ! -f $BUILD_ROOT/$DEPLOY_FILE ]
then
  echo "$DEPLOY_FILE not found"
  exit
fi

echo "******************Compiling*************************"

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
#git clone git://github.com/classicdb/database.git $CLASSIC_DB_DIR
# Since i added a way to specify DB_HOST in InstallFullDB.sh i will use my fork and create a pull request...back to main if it is merged.
git clone git@github.com:maxc0c0s/database.git $CLASSIC_DB_DIR
cd $CLASSIC_DB_DIR
git reset --hard $COMMIT_DB
cd $BUILD_ROOT

BUILD_DIR="$BUILD_ROOT/build"
BIN_DIR="$BUILD_ROOT/cmangos"
mkdir -p $BUILD_DIR
mkdir -p $BIN_DIR

cd $BUILD_DIR
cmake $CMANGOS_DIR -DCMAKE_INSTALL_PREFIX=$BIN_DIR -DPCH=0 -DDEBUG=0
make
make install
cd $BUILD_ROOT

tar -cvzf cmangos-classic-${CMANGOS_VERSION}.tar.gz cmangos
DATABASE_DIR="$BUILD_ROOT/database"
mkdir -p $DATABASE_DIR
cp -R $CMANGOS_DIR $DATABASE_DIR/cmangos-classic
mv $CLASSIC_DB_DIR $DATABASE_DIR/
mv $ACID_DIR $DATABASE_DIR/
cd $BUILD_ROOT
tar -cvzf cmangos-classic-database-${CMANGOS_VERSION}.tar.gz database
CONFIGS_DIR="$BUILD_ROOT/configs"
mkdir -p $CONFIGS_DIR
cp $CMANGOS_DIR/src/mangosd/mangosd.conf.dist.in $CONFIGS_DIR/mangosd.conf
cp $CMANGOS_DIR/src/realmd/realmd.conf.dist.in $CONFIGS_DIR/realmd.conf
cp $CMANGOS_DIR/src/game/AuctionHouseBot/ahbot.conf.dist.in $CONFIGS_DIR/ahbot.conf
cd $BUILD_ROOT
tar -cvzf cmangos-classic-configs-${CMANGOS_VERSION}.tar.gz configs

echo "*******************Deploying**********************"
$BUILD_ROOT/${DEPLOY_FILE}

exec $@
