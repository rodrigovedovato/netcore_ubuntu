#!/bin/bash

cecho(){
    RED="\033[1;31m"
    GREEN="\033[1;32m"
    YELLOW="\033[1;33m"
	BLUE="\033[1;34m"
    NC="\033[0m" # No Color

    printf "${!1}${2} ${NC}\n"
}

UBUNTU_VERSION=$(lsb_release -r | egrep -o "[0-9]{2}.[0-9]{2}")

wget -q https://packages.microsoft.com/config/ubuntu/$UBUNTU_VERSION/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt-get -q install -y apt-transport-https
sudo apt-get -q update

cecho "BLUE" "These are the available .NET Core SDK versions to be installed on your system"

IFS=$'\r\n' GLOBIGNORE='*' command eval 'VERSIONS=($(apt-cache search dotnet-sdk- | egrep -o "dotnet-sdk-(\S|\.)+"))'

for key in ${!VERSIONS[*]}; do
	cecho "BLUE" "[$key] - ${VERSIONS[$key]}"
done

read -p "Please choose the version you wish to install: " SDK_VERSION

VERSION=${VERSIONS[$SDK_VERSION]}

cecho "GREEN" "Installing $VERSION"

sudo apt-get -q install -y $VERSION

if [ $? -eq 0 ]; then
	rm packages-microsoft-prod.deb

	cecho "GREEN" "$VERSION successfully installed"
else
    cecho "YELLOW" "Hmm.. something is not right! Let me try something.."
	source netcoresdk_simple_fallback.sh
fi