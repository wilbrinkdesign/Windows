### Approve WSUS updates

```powershell
Get-WsusUpdate -Classification Critical -Approval Unapproved -Status Any | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
Get-WsusUpdate -Classification Security -Approval Unapproved -Status Any | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
Get-WsusUpdate -Classification WSUS -Approval Unapproved -Status Any | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
Get-WsusUpdate -Classification All -Approval Unapproved -Status Any | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
```

### Auto approve WSUS updates

```powershell
$Updates = Get-WsusUpdate -Approval Approved -Status Any | Where-Object { $_.update.title -notlike "*Feature*" }

$Groups = @("<group1>", "<group2>")

Foreach ($Group In $Groups)
{
	$Updates | Approve-WsusUpdate -Action Install -TargetGroupName $Group
}
```