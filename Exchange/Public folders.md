### Get Public Folders

```powershell
Get-OrganizationConfig | fl publicfoldersenabled
```

### Create master hierachy for Public Folders

```powershell
New-Mailbox -PublicFolder -Name MasterHierachy
```

### Add permissions to Public Folders

```powershell
Add-PublicFolderClientPermission "\<folder>\<name>" -User "<group>" -AccessRights Reviewer
```

### Get Public Folders permissions

```powershell
Get-PublicFolder "\<folder>\<name>" | Get-PublicFolderClientPermission
```