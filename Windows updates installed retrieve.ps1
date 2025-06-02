<#
	.DESCRIPTION
	Get all installed Windows Updates.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
#>

Foreach ($Hotfix in (Get-HotFix)) # Loop through all Windows updates with 'Get-Hotfix'
{
	$List = New-Object -TypeName PSObject
	$List | Add-Member -NotePropertyName Update -NotePropertyValue $Hotfix.HotFixID
	$List | Add-Member -NotePropertyName Date -NotePropertyValue $Hotfix.InstalledOn

	[array]$Windows_Updates += $List
}

$Update_Session = New-Object -ComObject Microsoft.Update.Session
$Update_Search = $Update_Session.CreateupdateSearcher()
$Updates = @($Update_Search.Search("IsInstalled=1").Updates)

Foreach ($Update in $Updates) # Loop through all Windows updates with 'Microsoft.Update.Session'
{
	If ($Update.Title) # If update has title
	{
		$List = New-Object -TypeName PSObject
		$List | Add-Member -NotePropertyName Update -NotePropertyValue $Update.Title
		$List | Add-Member -NotePropertyName Date -NotePropertyValue $Update.LastDeploymentChangeTime

		[array]$Windows_Updates += $List
	}
}

$Windows_Updates | Sort-Object Update -Unique | Out-GridView