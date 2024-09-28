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