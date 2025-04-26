<#
	.DESCRIPTION
	Get all permissions (ACLs) for all directories/files.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
#>

Param(
	[Parameter(Mandatory=$True)][string]$Path
)

$Directory = Get-ChildItem $Path -Recurse
$Complete_List = @()

Foreach ($File in $Directory)
{
	$File_Path = $File.FullName
	$File_Owner = ($File_Path | Get-Acl).Owner
	$File_Permissions = ($File_Path | Get-Acl | Select-Object -ExpandProperty Access).FileSystemRights
	$File_Members = ($File_Path | Get-Acl | Select-Object -ExpandProperty Access).IdentityReference
	$File_Date = $File.LastWriteTime

	$List = [PSCustomObject]@{
		Path        = $File_Path
		Owner       = $File_Owner
		Permissions = $File_Permissions
		Access      = $File_Members
		Date        = $File_Date
	}

	$Complete_List += $List
}

$Complete_List | Out-GridView
