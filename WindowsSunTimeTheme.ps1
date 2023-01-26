# Get the current location of the machine
$ipInfo = Invoke-RestMethod -Uri "https://ipinfo.io/json"
$lat = $ipInfo.lat
$lon = $ipInfo.lon

# Get the current time
$now = (Get-Date).ToUniversalTime()
Write-Output "Now:      $now"

# Get the sunrise and sunset times for the current location
$apiUrl = "https://api.sunrise-sunset.org/json?lat=$lat&lng=$lon&formatted=0"
$response = Invoke-RestMethod -Uri $apiUrl

# Parse the response to get the sunrise and sunset times
$sunrise = [datetime]::ParseExact($response.results.sunrise, "MM/dd/yyyy HH:mm:ss", $null)
$sunset  = [datetime]::ParseExact($response.results.sunset,  "MM/dd/yyyy HH:mm:ss", $null)

Write-Output "Sunrise:  $sunrise"
Write-Output "Sunset:   $sunset"

# Check if it is currently day or night
if($now -ge $sunrise -and $now -lt $sunset) {
    # It is currently day - switch to light mode
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 1
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme    -Value 1
} else {
    # It is currently night - switch to dark mode
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme    -Value 0
}

# Get the path of the script
$scriptPath = $MyInvocation.MyCommand.Path
$schedule = (Get-Date).AddMinutes(5)

#Check if the next event is sunrise or sunset
if ($now -ge $sunrise -and $now -lt $sunset) {
	# Next event is sunset
	$schedule = $sunset.AddMinutes(5)
} else {
	#Next event is sunrise
	$schedule = $sunrise.AddDays(1).AddMinutes(5)
}

# Check if the task already exists
if (Get-ScheduledTask -TaskName "Sunrise Sunset Task") {
    # Task already exists - remove it
    Unregister-ScheduledTask -TaskName "Sunrise Sunset Task" -Confirm:$false
}

# Define properties for new scheduled task
# Scheduling requires PowerShell 7
$action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-file $scriptPath"
$trigger = New-ScheduledTaskTrigger -Once -At $schedule
$settings = New-ScheduledTaskSettingsSet

# Schedule new task
Register-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -TaskName "Sunrise Sunset Task" -Description "Runs script one minute after the next sunset or sunrise"