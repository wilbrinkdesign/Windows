<#
	.DESCRIPTION
	Strip the names of files.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	.PARAMETER Folder
	This is the source path where the files resign that you want to rename.

	.PARAMETER Recurse
	Activate this switch if there are any files in subfolders.

	.PARAMETER Pattern
	The pattern is a regular expression. Everything you provide, will be stripped down.

	.EXAMPLE
	PS> <script_name>.ps1 -Folder <path> -Pattern "prefix1|prefix2"
#>

Function Rename-Files
{
	[alias("rename")]
	Param(
		[string]$Folder,
		[switch]$Recurse,
		[string]$Pattern = "IMG-|IMG_|VID-"
	)

	# Check folder path
	If (!(Test-Path -Path $Folder))
	{
		Do
		{
			$Folder = Read-Host "Where are the files that you want to rename? Provide the path"
		} Until ((Test-Path -Path $Folder) -eq $True)
	}

	If ($Recurse) { $Recurse_Param = @{ "Recurse" = $True } } # Use the -Recurse parameter for Get-ChildItem if the switch was used

	Write-Host "Renaming files in '$Folder' with regex: $Pattern" -ForegroundColor Yellow
	Get-ChildItem -Path $Folder -File @Recurse_Param | Rename-Item -NewName { $_.Name -replace $Pattern }
}