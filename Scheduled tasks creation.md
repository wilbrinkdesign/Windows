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