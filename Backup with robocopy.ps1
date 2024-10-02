<#
	.DESCRIPTION
	Backup your data to your Bitlocker enabled drive with the Robocopy mirror function.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	- This script will backup your data to a Bitlocker enabled drive.
	- The Robocopy mirror function will be used, so be carefull!
	- A folder with todays date will be created on the Bitlocker enabled drive where the backup will be stored.
	- Certain files and folders will be excluded from this backup.

	.EXAMPLE
	PS> <script_name>.ps1 -DataDirectory <data_folder>

	You can also create a profile.ps1 file, for example: C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
	Then add the following to this script (edit your own script en data locations):

		. "<script_name>.ps1"

		Function backup
		{
			Backup-Data -DataDirectory <data_folder>
		}

	Now every time you start PowerShell, you can run the 'backup' command, and this will fire up this backup script :)
#>

Function Backup-Data
{
	Param(
		[string]$DataDirectory
	)

	Clear-Host

	# Check if you run this script as Admin
	If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
		Write-Host "Run PowerShell as Admin!" -ForegroundColor Red
		Break
	}

	# Check the data directory
	If (!$DataDirectory) # When the 'DataDirectory' parameter was not used, ask the user for the data directory
	{
		Do { $DataDirectory = Read-Host "Which drive/directory do you want to backup?" } Until ((Test-Path -Path $DataDirectory) -eq $True)
	}
	ElseIf (!(Test-Path $DataDirectory))
	{
		Write-Host "Directory not found: $DataDirectory" -ForegroundColor Red
		Break
	}

	# Get all external drives that are Bitlocker enabled
	Write-Host "Requesting Bitlocker enabled drives..." -ForegroundColor Yellow
	Try { Get-BitLockerVolume | Where-Object { $_.VolumeType -ne "OperatingSystem" } | ForEach-Object { $Bitlocker_Drives += ,$_.MountPoint } } Catch {}

	Clear-Host

	If (!($Bitlocker_Drives).count)
	{
		Write-Host "There are no Bitlocker enabled drives found where we can store the backup :(" -ForegroundColor Red
		Break
	}
	ElseIf (($Bitlocker_Drives).count -gt 1)
	{
		# If there are multiple Bitlocker enabled drives found, show them so that the user can choose
		(Get-BitLockerVolume | Where-Object { $_.VolumeType -ne "OperatingSystem" }).MountPoint
		Write-Host ""
		Do { $Bitlocker_Backup_Location = Read-Host "What is the drive letter where you want to store the backup?" } Until (($Bitlocker_Backup_Location -ne "C:") -and ((Test-Path -Path $Bitlocker_Backup_Location) -eq $True))
	}
	Else
	{
		# Only 1 Bitlocker enabled drive was found, so put this drive in a variable
		$Bitlocker_Backup_Location = $Bitlocker_Drives
	}

	$Data_Drive_Location = "$Bitlocker_Backup_Location\$(Get-Date -Format "yyyy-MM-dd")"

	Clear-Host

	Write-Host "The files in '$DataDirectory' will be copied to: $Data_Drive_Location" -ForegroundColor Yellow

	Write-Host ""
	Write-Host "1. Yes" -ForegroundColor Yellow
	Write-Host "2. No" -ForegroundColor Yellow
	Write-Host ""
	Do { $Continue = Read-Host "Continue?" } While ($Continue -notmatch "^[1-2]$")

	If ($Continue -eq 2)
	{
		Break
	}

	Clear-Host

	Write-Host "'$DataDirectory' will now be copied to: $Data_Drive_Location"  -ForegroundColor Yellow
	robocopy $DataDirectory $Data_Drive_Location /E /R:0 /MIR /A-:SH /XD ".git" ".svn" /XF "desktop.ini"
}