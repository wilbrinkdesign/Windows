<#
	.DESCRIPTION
	Backup your data with the Robocopy mirror function.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	- This script will backup your data.
	- The Robocopy mirror function will be used, so be careful!
	- A folder with todays date will be created on the destination where the backup will be stored.
	- Certain files and folders will be excluded from this backup.

	.EXAMPLE
	PS> <script_name>.ps1 -Source <source> -Destination <destination>
#>

Param(
	[string]$Source,
	[string]$Destination
)

$Exclude_Dirs = ".git", ".svn"
$Exclude_Files = "desktop.ini", "Personal Vault.lnk"

# Check for the source
If (!(Test-Path -Path $Source))
{
	Do
	{
		$Source = Read-Host "What would you like to backup? Provide the path"
	} Until ((Test-Path -Path $Source) -eq $True)
}

# Check for the destination
If (!(Test-Path -Path $Destination))
{
	Do
	{
		Write-Host ""
		Write-Host "Available drives:" -ForegroundColor Yellow
		(Get-Partition | Where-Object DriveLetter -match "[a-z]").DriveLetter

		Write-Host ""
		$Destination = Read-Host "Where do you want to store the backup? Provide the path"
	} Until ((Test-Path -Path $Destination) -eq $True)
}

$Destination_Full = "$Destination\$(Get-Date -Format "yyyy-MM-dd")"

Write-Host "Backup '$Source' to '$Destination_Full'" -ForegroundColor Yellow
robocopy $Source $Destination_Full /E /R:0 /MIR /A-:SH /XD $Exclude_Dirs /XF $Exclude_Files

Write-Host "Don't forget to make an export from your vault!" -ForegroundColor Yellow