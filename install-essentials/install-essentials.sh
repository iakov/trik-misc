# 1. Before running this script update your system with 'apt-get dist-upgrade'
# 2. Make sure there is enough space for temporary files.
# 3. Do not be afraid to proceed manually if script fails.

set -e
set -o xtrace

sudo apt-get -y install --no-install-recommends etckeeper sed git

sudo sed -i -r -e 's/^(VCS=.*)$/#&/' /etc/etckeeper/etckeeper.conf
sudo sed -i -r -e 's/^#(VCS="git".*)$/\1/' /etc/etckeeper/etckeeper.conf
pushd /etc && ( [ -d ".git" ] || sudo etckeeper init) && sudo git commit -am  "Before dist-upgrade" && popd

sudo apt-get -y install software-properties-common wget
sudo apt-add-repository -y ppa:ermshiperete/monodevelop
sudo apt-get update

sudo apt-get dist-upgrade

wget -O - https://github.com/iakov/trik-misc/blob/master/install-essentials/ubuntu-packages.list |\
      grep -Ev "^#" | xargs sudo apt-get -y install --no-install-recommends

sudo apt-get autoremove
sudo apt-get clean

SDK=$(mktemp)
wget --verbose -O $SDK http://195.19.241.150/packages/updates/sdk/latest-trik-sdk.sh
echo Running SDK installer from $SDK 
chmod +x $SDK 
$SDK -y -D
rm $SDK


