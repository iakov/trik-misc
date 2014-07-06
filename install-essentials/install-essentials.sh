# 1. Before running this script update your system with 'apt-get dist-upgrade'
# 2. Make sure there is enough space for temporary files.
# 3. Do not be afraid to proceed manually if script fails.

set -e
set -o xtrace

sudo apt-add-repository -y ppa:ermshiperete/monodevelop
sudo apt-get update
sudo apt-get install etckeeper
sudo sed -i -r -e 's/^(VCS=.*)$/#&/' /etc/etckeeper/etckeeper.conf
sudo sed -i -r -e 's/^#(VCS="git".*)$/\1/' /etc/etckeeper/etckeeper.conf
pushd /etc && sudo etckeeper init && sudo git commit -am  "Initial" && popd

cat ubuntu-packages.list | grep -Ev "^#" | xargs sudo apt-get -y install

SDK=$(mktemp)
wget --verbose -O $SDK http://195.19.241.150/packages/updates/sdk/latest-trik-sdk.sh
echo Running SDK installer from $SDK 
chmod +x $SDK 
$SDK -y -D
rm $SDK


