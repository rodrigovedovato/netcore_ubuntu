#!/bin/sh

UBUNTU_VERSION=$(lsb_release -r | egrep -o "[0-9]{2}.[0-9]{2}")

wget -q https://packages.microsoft.com/config/ubuntu/$UBUNTU_VERSION/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt-get -q install -y apt-transport-https
sudo apt-get update

echo "These are the available .NET Core SDK versions to be installed on your system"

IFS=$'\r\n' GLOBIGNORE='*' command eval  'VERSIONS=($(apt-cache search dotnet-sdk-))'

for key in "${!VERSIONS[@]}"
do
	echo "($key) - ${VERSIONS[$key]}"
done

read -p "Please choose the version you wish to install (eg. 1)" SDK_VERSION

VERSION=$VERSIONS[SDK_VERSION]



echo "Installing .NET Core SDK"

sudo apt-get -q install -y dotnet-sdk-2.2

INSTALL_STATUS=$?
