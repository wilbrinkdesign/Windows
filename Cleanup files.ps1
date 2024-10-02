<#
	.DESCRIPTION
	Cleanup files that are no longer necessary, for example, old log files.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
 
	.PARAMETER Directory
	The directory that houses the old files.

	.PARAMETER Recursive
	If you want to delete files recursively.

	.PARAMETER Filter
	Filter on the name or a specific file extension.

	.PARAMETER Age
	How old the files must be in order to delete them.

	.PARAMETER WhatIf
	Use this parameter if you want to know what would happen, what the output of this script would be like.

	.EXAMPLE
	PS> <script_name>.ps1 -Directory "<folder>" -Recursive -Filter "ext1|ext2|ext3" -Age <days>
	PS> <script_name>.ps1 -Directory "<folder>" -Recursive -Filter "ext1|ext2|ext3" -Age <days> -WhatIf
#>

[CmdletBinding(SupportsShouldProcess)]
Param(
	[Parameter(Mandatory)][string]$Directory,
	[switch]$Recursive,
	[Parameter(Mandatory)][string]$Filter,
	[Parameter(Mandatory)][int]$Age
)

If ($Recursive) { $Recurse = @{ Recurse = $True } }

If (Test-Path $Directory)
{
	Write-Host "Deleting files..." -ForegroundColor Yellow
	Write-Host "Directory: $Directory" -ForegroundColor Yellow
	Write-Host "Filter: $Filter" -ForegroundColor Yellow
	Write-Host "Older than: $Age" -ForegroundColor Yellow
	Write-Host ""
	$Files = Get-ChildItem $Directory @Recurse | Where-Object { $_.Name -match $Filter -and $_.LastWriteTime -lt ((Get-Date).AddDays(-$Age)) }
	$Files | Remove-Item
}
Else
{
	Write-Host "Directory not found: $Directory" -ForegroundColor Red
}