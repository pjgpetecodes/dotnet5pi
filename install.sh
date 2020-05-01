#!/bin/bash

echo -e "\e[1m----------------------------------------"
echo -e "\e[1m       Dot Net Core Installer"
echo -e "\e[1m----------------------------------------"
echo ""
echo -e "\e[1mPete Codes / PJG Creations 2020"
echo ""
echo -e "Latest update 01/05/2020"
echo ""
echo "This will install the following;"
echo ""
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"
echo "- Dot Net 5.0.100 - Preview 3 - 20216-6"
echo "- ASP.NET 5.0.0 - Preview 3 - 20215-14"
echo "- Blazor Preview 5 2016.8"
echo ""
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"
echo -e "Any suggestions or questions, email \e[1;4mpete@pjgcreations.co.uk"
echo -e "\e[0mSend me a tweet \e[1;4m@pete_codes"
echo -e "\e[0mTutorials on \e[1;4mhttps://www.petecodes.co.uk"
echo ""
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

if [[ $EUID -ne 0 ]]; then
   echo -e "\e[1;31mThis script must be run as root" 
   exit 1
fi

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m           Performing Updates"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

read -p "Do you wish to do perform a system update and upgrade first? " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Performing System Update and Upgrade"
    echo ""
    apt-get -y update
    apt-get -y upgrade
fi

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m         Installing Dependencies"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

apt-get -y install libunwind8 gettext

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m     Getting Dot Net 5 Binaries"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

cd ~/
wget https://download.visualstudio.microsoft.com/download/pr/58276f20-1ff1-49e7-afbd-fcc6a20acf56/18aacff58da12a91e691036be7ef8063/dotnet-sdk-5.0.100-preview.3.20216.6-linux-arm.tar.gz

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m       Getting ASP.NET 5 Runtime"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

wget https://download.visualstudio.microsoft.com/download/pr/ffbb2903-bd07-47e0-aa7d-9264c942cc38/9937a6b2cf97e16f878f4f3feb874479/aspnetcore-runtime-5.0.0-preview.3.20215.14-linux-arm.tar.gz

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m       Creating Main Directory"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

if [[ -d /opt/dotnet ]]; then
    echo "/opt/dotnet already  exists on your filesystem."
else
    echo "Creating Main Directory"
    echo ""
    mkdir /opt/dotnet
fi

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m    Extracting Dot NET 5 Binaries"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

tar -xvf dotnet-sdk-5.0.100-preview.3.20216.6-linux-arm.tar.gz -C /opt/dotnet/

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m    Extracting ASP.NET 5 Runtime"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

tar -xvf aspnetcore-runtime-5.0.0-preview.3.20215.14-linux-arm.tar.gz -C /opt/dotnet/

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m    Link Binaries to User Profile"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

ln -s /opt/dotnet/dotnet /usr/local/bin

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m    Make Link Permanent"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

if grep -q 'export DOTNET_ROOT=/opt/dotnet' ~/.bashrc;  then
  echo 'Already added link to .bashrc'
else
  echo 'Adding Link to .bashrc'
  echo 'export DOTNET_ROOT=/opt/dotnet' >> ~/.bashrc
fi

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m          Get Blazor Templates"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

dotnet new -i Microsoft.AspNetCore.Components.WebAssembly.Templates::3.2.0-rc1.20223.4

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m          Run dotnet --info"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

dotnet --info

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m              ALL DONE!"
echo ""
echo -e "\e[0mGo ahead and run \e[1mdotnet new console \e[0min a new directory!"
echo ""
echo ""
echo -e "Let me know how you get on by tweeting me at \e[1;5m@pete_codes"
echo ""
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"


