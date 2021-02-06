@echo off

echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|             Windows 10 VS Code Raspberry Pi                |"
echo "|             Remote Deployment and Debugging                |"
echo "|                      Setup Script                          |"
echo "|                                                            |"
echo "|                  Uno Platform Version                      |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "| This script will automatically create SSH keys,            |"
echo "| copy the keys to the specified Raspberry Pi,               |"
echo "| download and configure cwrsync.                            |"
echo "|                                                            |"
echo "| It will also create a new Uno Platform application named   |"
echo "| <Hostname of your raspberry pi>_unotest.                   |"
echo "|                                                            |"
echo "| It will automatically create the launch.json, tasks.json   |"
echo "| and workspace.code-workspace files                         |"
echo "|                                                            |"
echo "| Created By: Pete Gallagher                                 |"
echo "| Version:    1.0                                            |"
echo "| Date:       06/02/2021                                     |"
echo "| Twitter:    @pete_codes                                    |"
echo "|                                                            |"
echo "--------------------------------------------------------------"

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|             Setting Pi Host Name and User Name             |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

set /p pihostname="Enter Raspberry Pi Host Name e.g. raspberrypi:"
set /p piusername="Enter Raspberry Pi User Name e.g. pi:"

echo Raspberry Pi Host Name Set to %pihostname%
echo Raspberry Pi User Name Set to %piusername%

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|              Setup Passwordless SSH Debugging?             |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

set /p setupSSH="Would you like to setup passwordless SSH Debugging for your Raspberry Pi? (y/n)"

echo Setup SSH Set to %setupSSH%

IF /I "%setupSSH%"=="y" (

    echo(
    echo "--------------------------------------------------------------"
    echo "|                                                            |"
    echo "|                    Creating SSH Keys                       |"
    echo "|                                                            |"
    echo "--------------------------------------------------------------"
    echo(

    if not exist c:\users\%username%\.ssh\id_rsa ssh-keygen -f "c:\\users\\%username%\\.ssh\\id_rsa" -t rsa -N ""

    echo(
    echo "--------------------------------------------------------------"
    echo "|                                                            |"
    echo "|               Trusting Remote Raspberry Pi                 |"
    echo "|                                                            |"
    echo "--------------------------------------------------------------"
    echo(

    ssh-keyscan -H %pihostname% >> c:\users\%username%\.ssh\known_hosts

    echo(
    echo "--------------------------------------------------------------"
    echo "|                                                            |"
    echo "|                   Creating SSH Directory                   |"
    echo "|                                                            |"
    echo "|                 (Enter your login password)                |"
    echo "|                                                            |"
    echo "--------------------------------------------------------------"
    echo(

    ssh pi@%pihostname% -oStrictHostKeyChecking=no "mkdir -p ~/.ssh"

    echo(
    echo "--------------------------------------------------------------"
    echo "|                                                            |"
    echo "|              Copying SSH Keys to Raspberry Pi              |"
    echo "|                                                            |"
    echo "|                 (Enter your login password)                |"
    echo "|                                                            |"
    echo "--------------------------------------------------------------"
    echo(

    type c:\Users\%username%\.ssh\id_rsa.pub | ssh -oStrictHostKeyChecking=no pi@%pihostname% "cat >> ~/.ssh/authorized_keys"

    echo(
    echo "--------------------------------------------------------------"
    echo "|                                                            |"
    echo "|     Downloading Visual Studio Debugger on Raspberry Pi     |"
    echo "|                                                            |"
    echo "--------------------------------------------------------------"
    echo(

    ssh pi@%pihostname% "cd ~/ && curl -sSL https://aka.ms/getvsdbgsh | /bin/sh /dev/stdin -v latest -l ~/vsdbg"

    echo(
    echo "--------------------------------------------------------------"
    echo "|                                                            |"
    echo "|            Downloading and Configuring cwRsync             |"
    echo "|                                                            |"
    echo "--------------------------------------------------------------"
    echo(

    if not exist "c:\cwrsync\rsync.exe" (

        mkdir c:\home\%USERNAME%\.ssh
        cd c:\home
        curl --output cwrsync.zip https://itefix.net/dl/free-software/cwrsync_6.2.1_x64_free.zip && tar -xf cwrsync.zip
        rename bin cwrsync
        move cwrsync c:\
        copy %userprofile%\.ssh\* c:\home\%username%\.ssh
        icacls c:\home /setowner %username% /R
        icacls c:\home /inheritance:r /grant:r "%username%:(OI)(CI)F" /T
    )

)

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|               Installing Uno Preview Templates             |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

cd c:/
dotnet new --install Uno.ProjectTemplates.Dotnet::3.5.0-dev.270

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|               Creating a .NET Uno Application              |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

dotnet new unoapp -o %pihostname%_unotest -ios=false -android=false -macos=false -wasm=false -skia-wpf=false -st=false 
cd %pihostname%_unotest

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|                 Creating .vscode Directory                 |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

mkdir .vscode
cd .vscode

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|              Creating workspace.code-workspace             |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

echo { >> workspace.code-workspace
echo 	"folders": [ >> workspace.code-workspace
echo 		{ >> workspace.code-workspace
echo 			"path": ".." >> workspace.code-workspace
echo 		} >> workspace.code-workspace
echo 	], >> workspace.code-workspace
echo 	"settings": { >> workspace.code-workspace
echo 		"piUserName": "%piusername%", >> workspace.code-workspace
echo     	"piHostName": "%pihostname%" >> workspace.code-workspace
echo 	} >> workspace.code-workspace
echo } >> workspace.code-workspace

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|                   Creating launch.json                     |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

echo { >> launch.json
echo     // Use IntelliSense to find out which attributes exist for C# debugging >> launch.json
echo     // Use hover for the description of the existing attributes >> launch.json
echo     // For further information visit https://github.com/OmniSharp/omnisharp-vscode/blob/master/debugger-launchjson.md >> launch.json
echo     "version": "0.2.0", >> launch.json
echo     "configurations": [ >> launch.json
echo          { >> launch.json
echo              "name": ".NET Core Launch (console)", >> launch.json
echo              "type": "coreclr", >> launch.json
echo              "request": "launch", >> launch.json
echo              "preLaunchTask": "build", >> launch.json
echo              // If you have changed target frameworks, make sure to update the program path. >> launch.json
echo              "program": "${workspaceFolder}/${workspaceFolderBasename}.Skia.Gtk/bin/Debug/net5.0/${workspaceFolderBasename}.Skia.Gtk.dll", >> launch.json
echo              "args": [], >> launch.json
echo              "cwd": "${workspaceFolder}", >> launch.json
echo              // For more information about the 'console' field, see https://aka.ms/VSCode-CS-LaunchJson-Console >> launch.json
echo              "console": "internalConsole", >> launch.json
echo              "stopAtEntry": false >> launch.json
echo          }, >> launch.json
echo          { >> launch.json
echo              "name": ".NET Core Attach", >> launch.json
echo              "type": "coreclr", >> launch.json
echo              "request": "attach", >> launch.json
echo              "processId": "${command:pickProcess}" >> launch.json
echo          }, >> launch.json
echo          { >> launch.json
echo              "name": ".NET Core Launch (remote)", >> launch.json
echo              "type": "coreclr", >> launch.json
echo              "request": "launch", >> launch.json
echo              "preLaunchTask": "RaspberryPiDeploy", >> launch.json
echo              "program": "~/./dotnetdebug.sh", >> launch.json
echo              "args": ["dotnet /home/${config:piUserName}/${workspaceFolderBasename}/${workspaceFolderBasename}.Skia.Gtk.dll"], >> launch.json
echo              "cwd": "/home/pi/${workspaceFolderBasename}", >> launch.json
echo              "stopAtEntry": false, >> launch.json
echo              "console": "internalConsole", >> launch.json
echo              "pipeTransport": { >> launch.json
echo                  "pipeCwd": "${workspaceFolder}/${workspaceFolderBasename}.Skia.Gtk", >> launch.json
echo                  "pipeProgram": "ssh", >> launch.json
echo                  "pipeArgs": [ >> launch.json
echo                      "${config:piUserName}@${config:piHostName}" >> launch.json
echo                  ], >> launch.json
echo                  "debuggerPath": "/home/pi/vsdbg/vsdbg" >> launch.json
echo              } >> launch.json
echo          } >> launch.json
echo      ] >> launch.json
echo } >> launch.json

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|                   Creating tasks.json                      |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

echo { >> tasks.json
echo     "version": "2.0.0", >> tasks.json
echo     "tasks": [ >> tasks.json
echo         { >> tasks.json
echo             "label": "build", >> tasks.json
echo             "command": "dotnet", >> tasks.json
echo             "type": "process", >> tasks.json
echo             "args": [ >> tasks.json
echo                 "build", >> tasks.json
echo                 "${workspaceFolder}/${workspaceFolderBasename}.Skia.Gtk/${workspaceFolderBasename}.Skia.Gtk.csproj", >> tasks.json
echo                 "/property:GenerateFullPaths=true", >> tasks.json
echo                 "/consoleloggerparameters:NoSummary" >> tasks.json
echo             ], >> tasks.json
echo             "problemMatcher": "$msCompile" >> tasks.json
echo         }, >> tasks.json
echo         { >> tasks.json
echo             "label": "publish", >> tasks.json
echo             "command": "dotnet", >> tasks.json
echo             "type": "process", >> tasks.json
echo             "args": [ >> tasks.json
echo                 "publish", >> tasks.json
echo                 "${workspaceFolder}/${workspaceFolderBasename}.Skia.Gtk/${workspaceFolderBasename}.Skia.Gtk.csproj", >> tasks.json
echo                 "/property:GenerateFullPaths=true", >> tasks.json
echo                 "/consoleloggerparameters:NoSummary" >> tasks.json
echo             ], >> tasks.json
echo             "problemMatcher": "$msCompile" >> tasks.json
echo         }, >> tasks.json
echo         { >> tasks.json
echo             "label": "watch", >> tasks.json
echo             "command": "dotnet", >> tasks.json
echo             "type": "process", >> tasks.json
echo             "args": [ >> tasks.json
echo                 "watch", >> tasks.json
echo                 "run", >> tasks.json
echo                 "${workspaceFolder}/${workspaceFolderBasename}.Skia.Gtk/${workspaceFolderBasename}.Skia.Gtk.csproj", >> tasks.json
echo                 "/property:GenerateFullPaths=true", >> tasks.json
echo                 "/consoleloggerparameters:NoSummary" >> tasks.json
echo             ], >> tasks.json
echo             "problemMatcher": "$msCompile" >> tasks.json
echo         }, >> tasks.json
echo         { >> tasks.json
echo             "label": "RaspberryPiPublish", >> tasks.json
echo             "command": "sh", >> tasks.json
echo             "type": "shell", >> tasks.json
echo             "dependsOn": "build", >> tasks.json
echo             "windows": { >> tasks.json
echo                 "command": "cmd", >> tasks.json
echo                 "args": [ >> tasks.json
echo                     "/c", >> tasks.json
echo                     "\"dotnet publish ${workspaceFolder}/${workspaceFolderBasename}.Skia.Gtk/${workspaceFolderBasename}.Skia.Gtk.csproj -r linux-arm -o ${workspaceFolderBasename}.Skia.Gtk\\bin\\linux-arm\\publish --no-self-contained\"" >> tasks.json
echo                 ], >> tasks.json
echo                 "problemMatcher": [] >> tasks.json
echo             } >> tasks.json
echo         }, >> tasks.json
echo         { >> tasks.json
echo             "label": "RaspberryPiDeploy", >> tasks.json
echo             "type": "shell", >> tasks.json
echo             "dependsOn": "RaspberryPiPublish", >> tasks.json
echo             "presentation": { >> tasks.json
echo                 "reveal": "always", >> tasks.json
echo                 "panel": "new" >> tasks.json
echo             }, >> tasks.json
echo             "windows": { >> tasks.json
echo                 "command": "c:\\cwrsync\\rsync -rvuz --rsh=\"c:\\cwrsync\\ssh\" --chmod=700 ${workspaceFolderBasename}.Skia.Gtk/bin/linux-arm/publish/ ${config:piUserName}@${config:piHostName}:/home/${config:piUserName}/${workspaceFolderBasename}/" >> tasks.json
echo             }, >> tasks.json
echo             "problemMatcher": [] >> tasks.json
echo         } >> tasks.json
echo     ] >> tasks.json
echo } >> tasks.json

echo(
echo "--------------------------------------------------------------"
echo "|                                                            |"
echo "|                Opening Project in VS Code                  |"
echo "|                                                            |"
echo "--------------------------------------------------------------"
echo(

cd c:\%pihostname%_unotest\.vscode

code workspace.code-workspace