#!/bin/bash


#NOTE that to use this outside of travis, you'll want to export BRANCH=master

set -euo pipefail
export base=$(pwd)

BRANCH=devel

sudo apt-get update
sudo apt-get -qy install bwa make build-essential cmake libncurses-dev ncurses-dev libbz2-dev lzma-dev liblzma-dev \
     curl libssl-dev libtool autoconf automake libcurl4-openssl-dev wget

git clone -b $BRANCH --depth 1 git://github.com/nim-lang/nim nim-$BRANCH/
cd nim-$BRANCH
sh build_all.sh

export PATH=$PATH:$base/nim-$BRANCH/bin/:$base
cd $base
nimble refresh
$base/nim-$BRANCH/bin/nimble install -y
