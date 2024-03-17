#Requires -RunAsAdministrator

# change into project repo folder
#cd \\sacfiles1\home\$($env:UserName[0])\$env:UserName\project\MediPal
# if scripts disabled:
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# install chocolatey
if ( -not[bool](Get-Command -Name choco -ErrorAction SilentlyContinue) ) {
	if ( Test-Path -Path 'C:\ProgramData\chocolatey' ) {
			Remove-Item 'C:\ProgramData\chocolatey'
	}
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# install dependencies
choco install -y vscode
choco install -y git
choco install -y dart-sdk
choco install -y flutter
choco install -y nodejs
choco install -y android-sdk
choco install -y androidstudio
# refesh environmental variables
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
refreshenv

# install firebase
npm install -g firebase-tools
npm fund
dart pub global activate flutterfire_cli

# install vscode extensions
code --install-extension vscjava.vscode-java-pack
code --install-extension Dart-Code.flutter

# android studio components
#cd $env:ANDROID_HOME\tools\bin\
#sdkmanager "platform-tools" "platforms;android-33"

firebase login
#flutterfire configure