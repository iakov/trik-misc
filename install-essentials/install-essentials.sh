#!/bin/bash

# 1.!!! This script is intended to run on clean K/X/L/Ubuntu 14.04. Edit script before running!!! 
# 2. Make sure there is enough space for temporary files.
# 3. Do not be afraid to proceed manually if script fails.

# 
# Install wget (sudo apt-get install -y wget)
# and run
# cd ~ && wget http://bit.ly/trikubuntu1407 && bash trikubuntu1407

#Path for TRIK related sources
TRIKSRC=~/trik-src

EXTRAS=https://raw.githubusercontent.com/iakov/trik-misc/master/install-essentials/extra
FILTER_COMMENTS_CMD="grep -Ev ^#"

set -e
set -o xtrace

sudo apt-get -y install --no-install-recommends etckeeper sed git

sudo sed -i -r -e 's/^(VCS=.*)$/#&/' /etc/etckeeper/etckeeper.conf
sudo sed -i -r -e 's/^#(VCS="git".*)$/\1/' /etc/etckeeper/etckeeper.conf
pushd /etc && ( [ -d ".git" ] || sudo etckeeper init) && sudo git commit -am  "Before dist-upgrade" && popd

sudo apt-get -y install software-properties-common wget
sudo apt-add-repository -y ppa:ermshiperete/monodevelop
sudo add-apt-repository -y ppa:ubuntu-sdk-team/ppa

sudo apt-get update

sudo apt-get -y dist-upgrade

wget -O - $EXTRAS/ubuntu-packages.list | $FILTER_COMMENTS_CMD |\
	 xargs sudo apt-get -y install --no-install-recommends

SDK=$(mktemp)
wget --verbose -O $SDK http://downloads.trikset.com/updates/sdk/latest-trik-sdk.sh
echo Running SDK installer from $SDK 
chmod +x $SDK 
$SDK -y -D

rm $SDK
sudo apt-get autoremove
sudo apt-get clean

mdtool setup ru
mdtool setup ci MonoDevelop.FSharpBinding

cd ~
#for file in $(wget -O - $EXTRAS/extra.files | $FILTER_COMMENTS_CMD )
# do 
#   mkdir -p $(dirname $file)
#   wget -O $file $EXTRAS/$(md5sum <<< $file | cut -f 1 -d ' ')
# done
#

#only $HOME files as for now
cd ~
wget -q -O - $EXTRAS/data.tar | tar xvk --keep-newer-files -C ~ --owner=$USER
# To create backup: sed -nre "s|^ *~/(.*)|\1|p" list | xargs tar u -C ~ -f data.tar
# 


mkdir -p $TRIKSRC
cd $TRIKSRC
git clone http://github.com/trikset/trikRuntime.git
cd trikRuntime
( source /opt/trik-sdk/environment-setup-armv5te-oe-linux-gnueabi && qmake trikRuntime.pro && make -j 2 )
cd ~

