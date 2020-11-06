#!/bin/bash

echo -e "\e[1m----------------------------------------"
echo -e "\e[1m       Dot Net 5 Installer"
echo -e "\e[1m----------------------------------------"
echo ""
echo -e "\e[1mPete Codes / PJG Creations 2020"
echo ""
echo -e "Latest update 01/10/2020"
echo ""
echo "This will install the following;"
echo ""
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"
echo "- Dot Net 5.0.100 - RC2 - 20479.15"
echo "- ASP.NET 5.0.000 - RC1 - 20475.17"
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
wget https://download.visualstudio.microsoft.com/download/pr/068ebc6e-4a1d-45ec-a766-733a142f2839/e0da4c731c943ca2b267c15edb565108/dotnet-sdk-5.0.100-rc.2.20479.15-linux-arm.tar.gz

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m       Getting ASP.NET 5 Runtime"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

wget https://download.visualstudio.microsoft.com/download/pr/d28b2c72-92f7-44fd-b673-f7c24275f513/694228a9541d905bda4417156a9617df/aspnetcore-runtime-5.0.0-rc.2.20475.17-linux-arm.tar.gz

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

tar -xvf dotnet-sdk-5.0.100-rc.2.20479.15-linux-arm.tar.gz -C /opt/dotnet/

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m    Extracting ASP.NET 5 Runtime"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

tar -xvf aspnetcore-runtime-5.0.0-rc.2.20475.17-linux-arm.tar.gz -C /opt/dotnet/

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

if grep -q 'export DOTNET_ROOT=' ~/.bashrc;  then
  echo 'Already added link to .bashrc'
else
  echo 'Adding Link to .bashrc'
  echo 'export DOTNET_ROOT=/opt/dotnet' >> ~/.bashrc
fi

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


