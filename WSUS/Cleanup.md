### Cleanup whole WSUS

```powershell
Get-WsusServer | Invoke-WsusServerCleanup -CleanupObsoleteUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates -CleanupUnneededContentFiles
```

### Decline superseded updates

```powershell
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
$updates = $wsus.GetUpdates() | Where { $_.IsSuperseded -eq 'True' }
$updates.Decline($True)
```

### Decline Preview updates

```powershell
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
$updates = $wsus.GetUpdates() | Where { $_.Title -like '*Preview of*' }
$updates.Decline($True)
```

### Delete drivers

```powershell
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
$wsus.GetUpdates() | Where { $_.UpdateClassificationTitle -eq 'Drivers' } | ForEach-Object { $wsus.DeleteUpdate($_.Id.UpdateId.ToString()); Write-Host $_.Title removed }
```