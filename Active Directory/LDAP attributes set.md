### Empty attribute

```powershell
Get-ADUser -Properties info | Set-ADuser -Clear info
```

### Fill attribute with existing attribute

```powershell
Get-ADUser -Filter {telephonenumber -like "<tel>*"} -Properties * | ForEach-Object {
	Set-ADUser -Identity $_ -replace @{ipphone = "$($_.telephonenumber.substring(8,3))"} 
}
```

### Replace characters for specific attribute (mobile)

```powershell
Get-ADUser -Filter {mobile -like "*"} -Properties * | ForEach-Object {
    $mobile = $_.mobile -replace "\+31", "0" -replace "\s", "" -replace "\(0\)", "" -replace "06-", "06"
	Set-ADuser -Identity $_ -replace @{mobile = $mobile}
}
```

### Edit AD users with specific department

```powershell
Get-ADUser -Filter {department -like "<department_old>"} | ForEach-Object { Set-ADUser -Identity $_.SamAccountName -department "<department_new>" }
```