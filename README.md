# WindowsSunTimeTheme
## Description

WindowsSunTimeTheme is a simple PowerShell script, that automatically switches between dark and light mode in Windows. It does that by using two apis to [first](https://ipinfo.io/json) obtain the location of the machine executing the script and [then](https://api.sunrise-sunset.org/json) using that information to obtain the sunrise and sunset times for that location. Then, depending on whether it is daytime or nighttime, the theme is set accordingly.

If you experience any issues regarding the script, please open an issue on the [GitHub repository](https://github.com/Lukas-LLS/WindowsSunTimeTheme/issues) 
> **Note:** The script assumes that you have PowerShell 7 installed. If you have not installed it, the script and the commands might not work as intended.
## Installation

For the script to function properly, it must be added to the auto start directory in windows. This can be accomplished by the following command.
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lukas-LLS/WindowsSunTimeTheme/master/WindowsSunTimeTheme.ps1" -OutFile "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WindowsSunTimeTheme.ps1" -Force
```
After executing this command, you have to restart your machine to order for the script to be started.
If you do not want to restart your machine, you can also use the following command to start it manually for the first time.
```powershell
pwsh -File "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WindowsSunTimeTheme.ps1"
```
## Uninstallation

To uninstall the script, it has to be removed from the auto start directory and the already scheduled task needs to be deleted. This can be achieved by the following commands.
```powershell
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WindowsSunTimeTheme.ps1"
if (Get-ScheduledTask -TaskName "Sunrise Sunset Task") {
    Unregister-ScheduledTask -TaskName "Sunrise Sunset Task" -Confirm:$false
}
```
## Troubleshooting

If you get an error message like the following, you have to change the execution policy of your user profile.
```
.\WindowsSunTimeTheme.ps1: File C:\Users\...\WindowsSunTimeTheme.ps1 cannot be loaded because running scripts is disabled on this system. For more information, see about_Execution_Policies at https://go.microsoft.com/fwlink/?LinkID=135170.
```
To enable the execution of scripts, you must run the following command.
> **Note:** This command disables signing checks and warnings for all scripts.
> If you choose to execute this command, you should check every future script you run on your profile.
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```