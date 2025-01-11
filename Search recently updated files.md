### Search for recently updated files

```powershell
# All files
Get-ChildItem "<pad>" -File -Recurse | Where-Object { $_.LastWriteTime -ge (Get-Date).AddHours(-1) } | fl FullName, LastWriteTime

# Specific log files
Get-ChildItem "<pad>\*.log" -File -Recurse | Where-Object { $_.LastWriteTime -ge (Get-Date).AddHours(-1) } | fl FullName, LastWriteTime
```