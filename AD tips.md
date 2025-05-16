### Copy group members/member of

```powershell
# Copy the group members from 1 group to another
Add-ADGroupMember -Identity "<group_new>" -Members (Get-ADGroupMember -Identity "<group_old>" -Recursive)

# Copy the group members from 1 user to another user
Get-ADUser "<user_old>" -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Add-ADGroupMember -Members "<user_new>"

# Copy the 'Member Of' from 1 group to another group
Add-ADPrincipalGroupMembership -Identity "<group_new>" -MemberOf (Get-ADPrincipalGroupMembership "<group_old>") 
```

### Edit LDAP attributes

```powershell
# Get the last 3 characters from the phonenumber and place this in the 'ipPhone' LDAP attribute
Get-ADUser -Filter {telephonenumber -like "<tel>*"} -Properties * | ForEach-Object {
	Set-ADUser -Identity $_ -replace @{ipphone = "$($_.telephonenumber.substring(8,3))"}
}

# Replace characters for 'mobile' LDAP attribute
Get-ADUser -Filter {mobile -like "*"} -Properties * | ForEach-Object {
    $mobile = $_.mobile -replace "\+31", "0" -replace "\s", "" -replace "\(0\)", "" -replace "06-", "06"
	Set-ADuser -Identity $_ -replace @{mobile = $mobile}
}

# Edit the 'department' LDAP attribute for some users that match a specific department
Get-ADUser -Filter {department -like "<department_old>"} | ForEach-Object { Set-ADUser -Identity $_.SamAccountName -department "<department_new>" }
```

```powershell
# Get expiration date from AD users
Get-ADUser -Properties sn, AccountExpirationDate -Filter * -SearchBase "<dn_container>" | fl sn, samaccountname, @{Name='AccountExpiration'; Expression={if ($null -eq $_.AccountExpirationDate) { 'Never Expires' } else { $_.AccountExpirationDate }}}

# Get last logon from AD users
Get-ADUser -Properties * -Filter * | Select @{Name="LastLogonTimestamp";Expression={[datetime]::FromFileTime($_.'LastLogonTimestamp')}}, @{Name="LastLogon";Expression={[datetime]::FromFileTime($_.'LastLogon')}}, @{Name="AccountExpirationDate";Expression={[datetime]::FromFileTime($_.'AccountExpirationDate')}}, @{Name="PwdLastSet";Expression={[datetime]::FromFileTime($_.'PwdLastSet')}}, samaccountname, mail 
```