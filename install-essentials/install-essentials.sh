#!/bin/bash
# 1. Before running this script update your system with 'apt-get dist-upgrade'
# 2. Make sure there is enough space for temporary files.
# 3. Do not be afraid to proceed manually if script fails.

#Path for TRIK related sources
TRIKSRC=~/trik-src

set -e
set -o xtrace

sudo apt-get -y install --no-install-recommends etckeeper sed git

sudo sed -i -r -e 's/^(VCS=.*)$/#&/' /etc/etckeeper/etckeeper.conf
sudo sed -i -r -e 's/^#(VCS="git".*)$/\1/' /etc/etckeeper/etckeeper.conf
pushd /etc && ( [ -d ".git" ] || sudo etckeeper init) && sudo git commit -am  "Before dist-upgrade" && popd

sudo apt-get -y install software-properties-common wget
sudo apt-add-repository -y ppa:ermshiperete/monodevelop
sudo apt-get update

sudo apt-get -y dist-upgrade

wget -O - https://raw.githubusercontent.com/iakov/trik-misc/master/install-essentials/ubuntu-packages.list |\
      grep -Ev "^#" | xargs sudo apt-get -y install --no-install-recommends

sudo apt-get autoremove
sudo apt-get clean

SDK=$(mktemp)
wget --verbose -O $SDK http://195.19.241.150/packages/updates/sdk/latest-trik-sdk.sh
echo Running SDK installer from $SDK 
chmod +x $SDK 
$SDK -y -D
rm $SDK


mkdir -p $TRIKSRC
cd $TRIKSRC
git clone http://github.com/trikset/trikRuntime.git
cd trikRuntime
( source /opt/trik-sdk/environment-setup-armv5te-oe-linux-gnueabi && qmake trikRuntime.pro && make -j 2 )
cd ~
