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