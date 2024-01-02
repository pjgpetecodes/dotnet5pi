#!/bin/bash

echo -e "\e[1m----------------------------------------"
echo -e "\e[1m            .NET 5 Installer"
echo -e "\e[1m----------------------------------------"
echo ""
echo -e "\e[1mPete Codes / PJG Creations 2024"
echo ""
echo -e "Latest update 02/01/2024"
echo ""

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m Installing .NET for the following user"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

username=$(logname)
echo -e "\e[1m$username\e[0m"

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m     Fetching Latest .NET Versions"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

dotnetver=5.0

sdkfile=/tmp/dotnetsdk.tar.gz
aspnetfile=/tmp/aspnetcore.tar.gz

download() {
    [[ $downloadspage =~ $1 ]]
    linkpage=$(wget -qO - https://dotnet.microsoft.com${BASH_REMATCH[1]})

    matchdl='id="directLink" href="([^"]*)"'
    [[ $linkpage =~ $matchdl ]]
    wget -O $2 "${BASH_REMATCH[1]}"
}

detectArch() {
    arch=arm32
  
    if command -v uname > /dev/null; then
        # machineCpu=$(uname -m)-$(uname -p)
        machineCpu=$(getconf LONG_BIT)

        if [[ $machineCpu == *64* ]]; then
            arch=arm64
        fi
    fi
}

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m        Installation information"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

echo ""
echo "This will install the latest versions of the following:"
echo ""
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"
echo "- .NET SDK $dotnetver"
echo "- ASP.NET Runtime $dotnetver"
echo ""
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"
echo "For the following user:"
echo ""
echo -e "\e[1m$username\e[0m"
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
   echo -e "\e[1;31mThis script must be run as root (sudo $0)" 
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
echo -e "\e[1m           Remove Old Binaries"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

rm -f $sdkfile
rm -f $aspnetfile

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m        Getting .NET SDK $dotnetver"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

[[ "$dotnetver" > "5" ]] && dotnettype="dotnet" || dotnettype="dotnet-core"
downloadspage=$(wget -qO - https://dotnet.microsoft.com/download/$dotnettype/$dotnetver)

detectArch

download 'href="([^"]*sdk-[^"/]*linux-'$arch'-binaries)"' $sdkfile

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m       Getting ASP.NET Runtime $dotnetver"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

download 'href="([^"]*aspnetcore-[^"/]*linux-'$arch'-binaries)"' $aspnetfile

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
echo -e "\e[1m    Extracting .NET SDK $dotnetver"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

tar -xvf $sdkfile -C /opt/dotnet/

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m    Extracting ASP.NET Runtime $dotnetver"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

tar -xvf $aspnetfile -C /opt/dotnet/

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

if grep -q 'export DOTNET_ROOT=' /home/$username/.bashrc;  then
  echo 'Already added link to .bashrc'
else
  echo 'Adding Link to .bashrc'
  echo 'export DOTNET_ROOT=/opt/dotnet' >> /home/$username/.bashrc
fi

echo -e "\e[0m"
echo -e "\e[1m----------------------------------------"
echo -e "\e[1m         Download Debug Stub"
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"

cd ~

wget -O /home/$username/dotnetdebug.sh https://raw.githubusercontent.com/pjgpetecodes/dotnet5pi/master/dotnetdebug.sh
chmod +x /home/$username/dotnetdebug.sh 

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
echo -e "\e[1mNote: It's highly recommended that you perform a reboot at this point!"
echo ""
echo -e "\e[0mGo ahead and run \e[1mdotnet new console \e[0min a new directory!"
echo ""
echo ""
echo ""
echo -e "\e[0mLet me know how you get on by tweeting me at \e[1;5m@pete_codes\e[0m"
echo ""
echo -e "\e[1m----------------------------------------"
echo -e "\e[0m"
