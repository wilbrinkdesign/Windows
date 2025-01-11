### New version: Get-EventLog

```powershell
Get-Eventlog -LogName <log> -Source <source> | Where-Object { $_.Message -like "*<text>*" }
```

### Old version: Get-WinEvent

```powershell
Get-WinEvent -LogName <log> | Where-Object { $_.Message -like '*<text>*' }
```