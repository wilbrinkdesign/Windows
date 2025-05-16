### Set timezone

```powershell
Set-WinHomeLocation -GeoID 176
Set-TimeZone -Id "W. Europe Standard Time"
Tzutil /s "W. Europe Standard Time"
Set-WinSystemLocale nl-NL
```

### SSH from Windows to Linux

```powershell
ssh-keygen
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add <ssh_private_key>
type <ssh_public_key> | ssh <user>@<host> "cat >> .ssh/authorized_keys"
```

### Hide a .ZIP folder in an image

1. Zip your folder: <folder.zip>
2. Download an image: <picture.jpg>
3. Run the command below:

```cmd
copy /b <folder.zip>+<picture.jpg> mysecretphoto.jpg
```

### Start logging

```powershell
# Log example: C:\Scripts\Log\202409291131.log
Try { Start-Transcript -Path "${PSScriptRoot}\Log\$(Get-Date -Format "yyyMMddhhmm").log" | Out-Null } Catch {}

# Log example: C:\Scripts\script.ps1.log
Try { Start-Transcript -Path "${PSCommandPath}.log" | Out-Null } Catch {}
```

### Stop logging

```powershell
Try { Stop-Transcript | Out-Null } Catch {}
```

### Edit pagefile

```powershell
# Set pagefile to auto
$Pagefile = Get-WmiObject Win32_ComputerSystem
$Pagefile.AutomaticManagedPagefile = $false
$Pagefile.Put()

# Place pagefile on E:\ drive
$Pagefile_E_Drive = Get-WmiObject Win32_PagefileSetting
$Pagefile_E_Drive.Name = "E:\pagefile.sys"
$Pagefile_E_Drive.Caption = "E:\pagefile.sys"
$Pagefile_E_Drive.Description = "’pagefile.sys’ @ E:\"
$Pagefile_E_Drive.SettingID ="pagefile.sys @ E:"
$Pagefile_E_Drive.put()

# Delete pagefile on C:\ drive
$Pagefile_C_Drive = Get-WmiObject Win32_PagefileSetting | Where-Object { $_.Name -eq "C:\pagefile.sys" }
$Pagefile_C_Drive.delete()
```

### Create scheduled task with PS script and run as SYSTEM and trigger on a daily basis

```powershell
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass `"<script.ps1>`""
$Trigger = New-ScheduledTaskTrigger -Daily -At 11PM
$User = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
$Task = New-ScheduledTask -Description "<description>" -Action $Action -Principal $User -Trigger $Trigger
Register-ScheduledTask "<name>" -InputObject $Task
```

### Create scheduled task with PS script and run as SYSTEM and trigger on event id

```powershell
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass `"<script.ps1>`""
$Class = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger
$Trigger = New-CimInstance -CimClass $Class -ClientOnly
$Trigger.Enabled = $true
$Trigger.Subscription = "<QueryList><Query Id='0' Path='System'><Select Path='System'>*[System[Provider[@Name='Microsoft-Windows-WAS'] and EventID=5002]]</Select></Query></QueryList>"
$User = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
$Task = New-ScheduledTask -Description "<description>" -Action $Action -Principal $User -Trigger $Trigger
Register-ScheduledTask "<name>" -InputObject $Task
```

### Examples for proxies for SYSTEM account

```powershell
bitsadmin /Util /SetIEProxy localsystem AUTODETECT
bitsadmin /util /setieproxy localsystem MANUAL_PROXY <proxy>:<port> ""
```

### Run PowerShell code in Task Schedular

1. Program/script: powershell.exe
2. Arguments: -Command &{ <ps_code> }

### Run PowerShell script in Task Schedular

1. Program/script: powershell.exe
2. Arguments: -ExecutionPolicy Bypass -File <ps1_file>

### Search for recently updated files

```powershell
# All files
Get-ChildItem "<pad>" -File -Recurse | Where-Object { $_.LastWriteTime -ge (Get-Date).AddHours(-1) } | fl FullName, LastWriteTime

# Specific log files
Get-ChildItem "<pad>\*.log" -File -Recurse | Where-Object { $_.LastWriteTime -ge (Get-Date).AddHours(-1) } | fl FullName, LastWriteTime
```

### First, enable System Protection on C drive

```cmd
rstrui.exe /offline:C:\windows=active
```

### 2nd, create a scheduled task for daily shadow copies

```powershell
$Action = New-ScheduledTaskAction -Execute "cmd" -Argument "/c wmic shadowcopy call create ClientAccessible,'C:\'"
$Trigger = @(
	$(New-ScheduledTaskTrigger -At 10PM -Daily),
	$(New-ScheduledTaskTrigger -At 20PM -Daily),
	$(New-ScheduledTaskTrigger -AtLogOn)
)
$User = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
$Task = New-ScheduledTask -Description "Shadow copy" -Action $Action -Principal $User -Trigger $Trigger
Register-ScheduledTask "Shadow copy" -InputObject $Task
```

### Search for certificates in the Windows certificate store with a specific name

```powershell
Get-ChildItem Cert: -Recurse | Where-Object Subject -like "*<naam>*"
```

### Search for certificates in the Windows certificate store with a specific date

```powershell
Get-ChildItem Cert: -Recurse | Where-Object NotAfter -like "*10/??/2023*" | fl Subject, NotAfter
```