# WindowsSunTimeTheme
## Description

WindowsSunTimeTheme is a simple PowerShell script, that automatically switches between dark and light mode in Windows. It does that by using two apis to [first](https://ipinfo.io/json) obtain the location of the machine executing the script and [then](https://api.sunrise-sunset.org/json) using that information to obtain the sunrise and sunset times for that location. Then, depending on whether it is daytime or nighttime, the theme is set accordingly.

If you experience any issues regarding the script, please open an issue on the [GitHub repository](https://github.com/Lukas-LLS/WindowsSunTimeTheme/issues) 
> **Note:** The script assumes that you have PowerShell 7 installed. If you have not installed it, the script and the commands might not work as intended.
## Installation

For the script to function properly, it must be added to the auto start directory in windows. This can be accomplished by the following command.
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lukas-LLS/WindowsSunTimeTheme/master/WindowsSunTimeTheme.ps1" -OutFile "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WindowsSunTimeTheme.ps1"
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

If you see an error at line 46, you can disregard it.
It is intended to happen either if the script is executed for the first time or when no new task was scheduled.

---

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

---

If upon machine restart the script does open in notepad instead of executing in PowerShell, you need to change the default program that is used when start .ps1 files
This can be achieved by the following steps.
1. Press WIN + R
2. Enter shell:startup
3. Right click on the script file
4. In the menu that opens, select *open with*
5. Select the PowerShell executable (If it is not listed go to the executable file selection in the bottom of the menu. The usual path of the executable is "C:\Program Files\PowerShell\7\pwsh.exe")
6. Finally select *always*
