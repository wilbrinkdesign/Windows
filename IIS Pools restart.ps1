Import-Module WebAdministration
Get-ChildItem IIS:\AppPools | Where-Object State -eq "Stopped" | Start-WebAppPool