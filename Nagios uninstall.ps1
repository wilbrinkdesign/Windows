Start-Process -FilePath "C:\Program Files\NSClient++\nscp.exe" -ArgumentList "service --uninstall"
Remove-NetFirewallRule -DisplayName "NSClient++ Monitoring Agent" -Confirm:$false -ErrorAction SilentlyContinue
Get-ChildItem "C:\Program Files\NSClient++" -Recurse | Remove-Item -Recurse -Confirm:$false -Force
Remove-Item "C:\Program Files\NSClient++" -Confirm:$false -Force -ErrorAction SilentlyContinue