### Get expiration date from AD users

```powershell
Get-ADUser -Properties sn, AccountExpirationDate -Filter * -SearchBase "<dn_container>" | fl sn, samaccountname, @{Name='AccountExpiration'; Expression={if ($null -eq $_.AccountExpirationDate) { 'Never Expires' } else { $_.AccountExpirationDate }}}
```

### Get last logon from AD users

```powershell
Get-ADUser -Properties * -Filter * | Select @{Name="LastLogonTimestamp";Expression={[datetime]::FromFileTime($_.'LastLogonTimestamp')}}, @{Name="LastLogon";Expression={[datetime]::FromFileTime($_.'LastLogon')}}, @{Name="AccountExpirationDate";Expression={[datetime]::FromFileTime($_.'AccountExpirationDate')}}, @{Name="PwdLastSet";Expression={[datetime]::FromFileTime($_.'PwdLastSet')}}, samaccountname, mail 
```

### Get creation date from AD users

```powershell
Get-ADUser -Filter * -SearchBase "<dn_container>" -Properties * | Where-Object { $_.createTimeStamp -gt "<date>" -and $_.enabled -eq $True } | Select-Object mail 
```