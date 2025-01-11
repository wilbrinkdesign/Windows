### Get FSMO roles

```cmd
netdom query fsmo
```

### Move FSMO roles

```powershell
# Gracefully
Move-ADDirectoryServerOperationMasterRole -Identity <domain_controller> -OperationMasterRole 0,1,2,3,4

# Seize
Move-ADDirectoryServerOperationMasterRole -Identity <domain_controller> -OperationMasterRole 0,1,2,3,4 -Force
```