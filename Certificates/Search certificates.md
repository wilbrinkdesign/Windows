### Search for certificates in the Windows certificate store with a specific name

```powershell
Get-ChildItem Cert: -Recurse | Where-Object Subject -like "*<naam>*"
```

### Search for certificates in the Windows certificate store with a specific date

```powershell
# Search for certificates that expire before october '23
Get-ChildItem Cert: -Recurse | Where-Object NotAfter -like "*10/??/2023*" | fl Subject, NotAfter
```