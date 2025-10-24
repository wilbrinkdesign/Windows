<#
	.DESCRIPTION
	Install specific Windows Update.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
#>

# Get Windows name and build number
$Windows_Build = (Get-WmiObject -class Win32_OperatingSystem).BuildNumber
$Windows_Name = (Get-WmiObject -class Win32_OperatingSystem).Caption

# Windows builds: https://docs.microsoft.com/en-us/windows/release-health/release-information
$KB_Updates = @{
   "17763" = [PSCustomObject]@{KB="KB5008218";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008218-x64_66e07f2fc23728ca0b8f395df15da52546e45e45.msu"} # 1809 Windows 10
   "18363" = [PSCustomObject]@{KB="KB5008206";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008206-x64_21e0a9eade0fa1885d5c96cd1cf9b12fbc8ef8d9.msu"} # 1909 Windows 10
   "19041" = [PSCustomObject]@{KB="KB5008212";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008212-x64_aef75b014bf6a8b9f858533d9dafb07c6f6fb741.msu"} # 2004 Windows 10
   "19042" = [PSCustomObject]@{KB="KB5008212";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008212-x64_aef75b014bf6a8b9f858533d9dafb07c6f6fb741.msu"} # 20H1 Windows 10
   "19043" = [PSCustomObject]@{KB="KB5008212";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008212-x64_aef75b014bf6a8b9f858533d9dafb07c6f6fb741.msu"} # 21H1 Windows 10
   "22000" = [PSCustomObject]@{KB="KB5008215";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008215-x64_8b19785f2a319bd716c6cee9fbf345cf19f6941b.msu"} # 21H2 Windows 11
}

# Get the update that corresponds to the build number
$KB_Number = $KB_Updates[$Windows_Build].KB
$Download_Link = $KB_Updates[$Windows_Build].URL

# Download and install update
(New-Object System.Net.WebClient).DownloadFile($Download_Link, "$env:TEMP\$KB_Number.msu")
wusa.exe "$env:TEMP\$KB_Number.msu" /quiet /norestart
