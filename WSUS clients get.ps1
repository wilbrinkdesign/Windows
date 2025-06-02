<#
	.DESCRIPTION
	Get all WSUS clients sorted by group.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
#>

Write-Host "WSUS module loading..." -ForegroundColor Yellow
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$WSUS = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer()
$WSUS_Groups = ($WSUS.GetComputerTargetGroups()).Name
$WSUS_Target_Groups = $WSUS_Groups | Where-Object { $_ -notmatch "Unassigned Computers|All Computers" }

Foreach ($Group in $WSUS_Target_Groups)
{
	Write-Host "Loop through WSUS groupp: $Group" -ForegroundColor Yellow
	Foreach ($Server in ((Get-WsusComputer -ComputerTargetGroups "$Group")))
	{
		Write-Host "Get info about: $($Server.FullDomainName)" -ForegroundColor Yellow
		$List = New-Object -TypeName PSObject
		$List | Add-Member -NotePropertyName Server -NotePropertyValue ($Server).FullDomainName
		$List | Add-Member -NotePropertyName IP -NotePropertyValue ($Server).IPAddress.IPAddressToString
		$List | Add-Member -NotePropertyName OS -NotePropertyValue ($Server).OSDescription
		$List | Add-Member -NotePropertyName Group -NotePropertyValue $Group
		
		[array]$Complete_List += $List
	}
}

$Complete_List | Out-GridView