# Dot Net 5 with the Raspberry Pi

This is the source code to accompany my talk on Microsoft .Net 5 with the Raspberry Pi.

Talk details, slides and a blog are incoming!

Tested on a Raspberry Pi 3B+ and a Raspberry Pi 4

Any Queries, contact me at;

https://www.petecodes.co.uk/contact/

Pete Gallagher / Pete Codes / PJG Creations 2020

# .Net 5 Installation on a Raspberry Pi

You can install Dot Net 5 on the Raspberry Pi in one command by executing;

```
wget -O - https://raw.githubusercontent.com/pjgpetecodes/dotnet5pi/master/install.sh | sudo bash
```

# Local Install Script

If you've cloned this repo, you can install Dot Net 5 by running the following in the root of the repo;

```
sudo chmod +x install.sh
sudo ./install.sh 

```

# PC Setup

Download the latest version of the .NET framework for your system from here;

https://dotnet.microsoft.com/download/dotnet/5.0

# Remote Deployment and Debugging

If you'd like to be able to write code on your PC and then Deploy and Debug that code directly on a Raspberry Pi, then I've create a one line script to set that up;

```
curl --output remotedebugsetup.bat https://raw.githubusercontent.com/pjgpetecodes/dotnet5pi/master/remotedebugsetup.bat && remotedebugsetup.bat
```

You can read more about this in a blog post here;

http://bit.ly/piremotedeployanddebug


# Setup PC for Remote Deployment and Debugging an Uno Application

If you'd like to be able to Create an Uno Platform Application on your PC and then Deploy and Debug that code directly on a Raspberry Pi, then I've create a one line script to set that up;

```
curl --output remotedebugsetup_uno.bat https://raw.githubusercontent.com/pjgpetecodes/dotnet5pi/master/remotedebugsetup_uno.bat && remotedebugsetup_uno.bat
```

You can read more about this in a blog post here;

http://bit.ly/piremotedeployanddebuguno

# IoT Hub Connection

The 3 IoT Hub Based Examples will require an IoT Hub Device Primary Connection String to work. 

# Deploying from VS Code on Windows

If you want to Deploy from VSCode on a Windows PC, then modify the RaspberryDeployWSL task's ```rsync``` command in the ```.vscode/tasks.json``` files in the various projects to point to your Pi IP Address;

```
"'sshpass -p \"raspberry\" rsync -rvuz $(wslpath '\"'${workspaceFolder}'\"')/bin/linux-arm/publish/ pi@[Enter Your IP Address]:share/${workspaceFolderBasename}/'"
```

Replace the ```[Enter Your IP Address]``` Section with the IP Address of your Pi (No Square Brackets!).

You will also need to change the username (```pi@```) and password (```-p \"raspberry"```) if you have altered those too.

# Debugging from VS Code on Windows

If you want to Debug from VSCode on a Windows PC, then modify the ```.NET Core Launch Console``` task in the ```.vscode/launch.json``` files in the various projects to point to your Pi's Hostname;

```
"pipeArgs": [
    "-pw",
    "raspberry",
    "root@[Your Pi Hostname].local"
],
```

You'll also need to install the VS Debugger;

```
curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -r linux-arm -v latest -l ~/vsdbg
```

You may also need to install curl and zip if they're not already installed;

```
sudo apt-get install curl
```

# Ensuring that projects use .NET 5 and minor versions

Now that we have .NET 6, if you have that installed, new projects will default to that automatically.

To ensure that you create a .NET 5 project (assuming you want to!), create a global.json file with the following contents in the directory you want to create your project;

```
{
  "sdk": {
    "version": "5.0.401",
    "rollForward": "latestMinor"
  }
}
```

It's also best to install the latest 
