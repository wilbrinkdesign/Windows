<#
	.DESCRIPTION
	Add photos to AD users by SamAccountName.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	Dependencies:
		- ActiveDirectory PS module
		- Location where the pictures for AD users are being stored
		- Resize-Image.ps1 (see link below)

	.LINK
	https://gist.github.com/someshinyobject/617bf00556bc43af87cd
#>

# Variables
$Pic_Dir_Source = ""
$Pic_Dir_Finished = "$Pic_Dir_Source\finished\"
$Pic_Resize_Tool = "$PSScriptRoot\Resize-Image.ps1"
$Pic_Suffix = "temp"
$Pic_Files = Get-ChildItem -Path $Pic_Dir_Source | Where-Object { $_.Name -match ".png|.jpg|.jpeg|.bmp" -and $_.Name -notlike "*$Pic_Suffix*" }

# If PS module ActiveDirectory is installed, continue
If ((Get-Module -ListAvailable -Name ActiveDirectory))
{
	If ((Test-Path $Pic_Dir_Source, $Pic_Resize_Tool) -notcontains $False)
	{
		If (!$Pic_Files) 
		{
			Write-Host "There are no pictures found :(" -ForegroundColor Yellow
		}

		Foreach ($Pic in $Pic_Files)
		{
			Write-Host ""
			Write-Host "Pic found: $Pic, getting info..." -ForegroundColor Yellow
			$SamAccountName = $Pic.Name.Substring(0, $Pic.Name.IndexOf('.'))
			$Pic_Location = $Pic.FullName

			Try 
			{
				Write-Host "Check AD user..." -ForegroundColor Yellow
				If (!($AD_User = Get-ADUser -Filter {samaccountname -eq $SamAccountName}))
				{
					Throw "AD user not found: $SamAccountName"
				}

				Write-Host "Picture is uploading to AD user:" $AD_User.Name -ForegroundColor Yellow
				. $Pic_Resize_Tool
				Add-Type -Assembly System.Drawing # In PowerShell ISE is deze Assembly niet nodig
				Resize-Image -Width 96 -ImagePath $Pic_Location -MaintainRatio -NameModifier $Pic_Suffix
				$Pic_Location_Resized = (Get-ChildItem -Path $Pic_Dir_Source | Where-Object { $_.FullName -match "$SamAccountName" -and $_.FullName -match "$Pic_Suffix" }).FullName
				$AD_Photo_Thumbnail = [byte[]](Get-Content $Pic_Location_Resized -Encoding byte)
				Set-ADUser $SamAccountName -Replace @{thumbnailPhoto=$AD_Photo_Thumbnail;jpegPhoto=$AD_Photo_Thumbnail}
				
				Write-Host "Cleanup files..." -ForegroundColor Yellow
				Do
				{
					Write-Host "$Pic_Location cleanup..." -ForegroundColor Yellow
					Move-Item -Path $Pic_Location -Destination $Pic_Dir_Finished -Force -ErrorAction SilentlyContinue
					Start-Sleep -Seconds 5
				} Until ((Test-Path -Path $Pic_Location) -eq $False)

				Do
				{
					Write-Host "$Pic_Location_Resized cleanup..." -ForegroundColor Yellow
					Remove-Item -Path $Pic_Location_Resized -Force -ErrorAction SilentlyContinue
					Start-Sleep -Seconds 5
				} Until ((Test-Path -Path $Pic_Location_Resized) -eq $False)
			}
			Catch
			{
				Write-Warning $_
			}
		}
	}
	Else
	{
		Write-Host "1 or more directories not found: $Pic_Dir_Source, $Pic_Resize_Tool" -ForegroundColor Red
	}
}
Else
{
	Write-Host "PowerShell module not installed: ActiveDirectory" -ForegroundColor Red
	Write-Host "Command: Install-WindowsFeature RSAT-AD-PowerShell" -ForegroundColor Yellow
}