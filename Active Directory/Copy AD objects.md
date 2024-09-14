### New AD group gets members from old AD group

```powershell
Add-ADGroupMember -Identity "<group_new>" -Members (Get-ADGroupMember -Identity "<group_old>" -Recursive) 
```

### Old AD user copies group membership to new AD user

```powershell
Get-ADUser "<user_old>" -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Add-ADGroupMember -Members "<user_new>"
```

### Old AD group copies member of to new AD group

```powershell
Add-ADPrincipalGroupMembership -Identity "<group_new>" -MemberOf (Get-ADPrincipalGroupMembership "<group_old>") 
```