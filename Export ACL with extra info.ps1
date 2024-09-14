$Path = "<dir>"
$Directory = Get-ChildItem $Path -Recurse
$Complete_List = @()

Foreach ($File in $Directory)
{
	$File_Path = $File.FullName
	$File_Owner = ($File_Path | Get-Acl).Owner
	$File_Permissions = ($File_Path | Get-Acl | select -ExpandProperty Access).FileSystemRights
	$File_Members = ($File_Path | Get-Acl | select -ExpandProperty Access).IdentityReference
	$File_Date = $File.LastWriteTime

	$List = New-Object -TypeName PSObject
	$List | Add-Member -NotePropertyName Path -NotePropertyValue $File_Path
	$List | Add-Member -NotePropertyName Owner -NotePropertyValue $File_Owner
	$List | Add-Member -NotePropertyName Permissions -NotePropertyValue $File_Permissions
	$List | Add-Member -NotePropertyName Access -NotePropertyValue $File_Members
	$List | Add-Member -NotePropertyName Date -NotePropertyValue $File_Date

	$Complete_List += $List
}

$Complete_List | Out-GridView