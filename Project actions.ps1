<#
	.DESCRIPTION
	Start a project for a logo or website, copy files, rename files and zip project.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	- This script will start a project.
	- This script will copy files.
	- This script will rename files.
	- This script will zip your project.

	If you work with logos, there is a predefined directory structure:
	.AI files => <dir>\Logo\Files\AI
	.EPS files => <dir>\Logo\Files\EPS
	.PDF files => <dir>\Logo\Files\PDF
	.SVG files => <dir>\Logo\Files\SVG
	.PNG files => <dir>\Logo\Files\PNG
	.JPG files => <dir>\Logo\Files\JPEG

	.EXAMPLE
	PS> project
	PS> Project-Start
	PS> Project-CopyFiles
	PS> Project-RemovePrefix
	PS> Project-Zip

	The alias names above become available if you create a profile.ps1 file, for example: C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
	Then add the following to this script (edit your own script en data locations):

	. "<script_name>.ps1"

	Function project
	{
		Project-Start -Source <source>
	}

	Now every time you start PowerShell, you can run the function names, and this will fire up this script :)
#>

Function Project-Start
{
	Param(
		[string]$Source
	)

	# Check for the source
	If (!(Test-Path -Path $Source))
	{
		Do
		{
			$Source = Read-Host "Where are your projects stored? Provide the path"
		} Until ((Test-Path -Path $Source) -eq $True)
	}

	Do
	{
		$Project_Name = Read-Host "Enter the name of the project"
	} Until ((Test-Path -Path "$Source\$Project_Name") -eq $False)

	# Different kinds of file extensions we are going to use, also to create the folders with
	$Extensions = @("AI", "EPS", "PDF", "SVG", "PNG", "JPEG")

	# Create al the folders we are going to need
	Write-Host "Creating folders in: $Source\$Project_Name" -ForegroundColor Yellow
	Foreach ($Extension in $Extensions)
	{
		New-Item -Path "$Source\$Project_Name\Logo\Files\$Extension" -ItemType "Directory" | Out-Null
	}
	New-Item -Path "$Source\$Project_Name\Website" -ItemType "Directory" | Out-Null
	New-Item -Path "$Source\$Project_Name\Mockups" -ItemType "Directory" | Out-Null

	# Start explorer and open the project
	explorer.exe "$Source\$Project_Name"
}

Function Project-CopyFiles
{
	Param(
		[string]$Source,
		[string]$Destination
	)

	# Check for the source
	If (!(Test-Path -Path $Source))
	{
		Do
		{
			$Source = Read-Host "Where did you save your logo files? Provide the path"
		} Until ((Test-Path -Path $Source) -eq $True)
	}

	# Check for the destination
	If (!(Test-Path -Path $Destination))
	{
		Do
		{
			$Destination = Read-Host "Where is your logo project stored? Provide the path"
		} Until ((Test-Path -Path $Destination) -eq $True)
	}

	# De different file extensions with their paths
	$Extensions_Paths = @{
		"AI" = "$Destination\Logo\Files\AI"
		"EPS" = "$Destination\Logo\Files\EPS"
		"PDF" = "$Destination\Logo\Files\PDF"
		"SVG" = "$Destination\Logo\Files\SVG"
		"PNG" = "$Destination\Logo\Files\PNG"
		"JPG" = "$Destination\Logo\Files\JPEG"
	}

	# Copy the files from source to the destination
	Foreach ($Extension in $Extensions_Paths.GetEnumerator())
	{
		$Files = Get-ChildItem $Source -Recurse | Where-Object { $_.GetType().Name -eq "FileInfo" -and $_.FullName -like "*$($Extension.Name)*" }

		Foreach ($File in $Files)
		{
			$File | Copy-Item -Destination $Extension.Value
			Write-Host "File copied: $File => $($Extension.Value)" -ForegroundColor Green
		}

		If (!$Files)
		{
			Write-Host "No files available for extension: $($Extension.Name)" -ForegroundColor Yellow
		}
	}

	# Start explorer and open the folder
	explorer.exe "$Destination"
}

Function Project-RemovePrefix
{
	Param(
		[string]$Source
	)

	# Check for the source
	If (!(Test-Path -Path $Source))
	{
		Do
		{
			$Source = Read-Host "Where are your logos stored that you want to rename (remove prefix)? Provide the path"
		} Until ((Test-Path -Path $Source) -eq $True)
	}

	# Get all logo files
	$Files = Get-ChildItem $Source -Recurse | Where-Object { $_.GetType().Name -eq "FileInfo" -and $_.FullName -match "AI|EPS|PDF|SVG|PNG|JPG" }

	# Rename files
	Foreach ($File in $Files)
	{
		$File | Rename-Item -NewName { (($_.FullName) -replace "([^_]+_)", "") }
		Write-Host "Prefix stripped: $File" -ForegroundColor Green
	}

	If (!$Files)
	{
		Write-Host "No files available for stripping prefix: $Source" -ForegroundColor Yellow
	}

	# Start explorer and open the folder
	explorer.exe "$Source"
}

Function Project-Zip
{
	Param(
		[string]$Source
	)

	# Check for the source
	If (!(Test-Path -Path $Source))
	{
		Do
		{
			$Source = Read-Host "Where is your project stored that you want to zip? Provide the path"
		} Until ((Test-Path -Path $Source) -eq $True)
	}

	# Create random name for our files
	$Random = Get-Random

	# Test if logo files exist and then create a .ZIP file
	If ((Test-Path -Path "$Source\Logo\Files") -and ((Get-ChildItem -Path "$Source\Logo\Files" -ErrorAction SilentlyContinue).Count -ge 1))
	{
		$Files_Logo = "$Source\$($Random)_Logo.zip"
		Get-ChildItem -Path "$Source\Logo\Files" | Compress-Archive -DestinationPath $Files_Logo -Force
		Write-Host "Logo zipped: $Files_Logo" -ForegroundColor Green
	}
	Else
	{
		Write-Host "Source didn't exist or there were no files available for export: $Source\Logo\Files" -ForegroundColor Yellow
	}

	# Test if website files exist and then create a .ZIP file
	If ((Test-Path -Path "$Source\Website") -and ((Get-ChildItem -Path "$Source\Website" -ErrorAction SilentlyContinue).Count -ge 1))
	{
		$Website_Files = "$Source\$($Random)_Website.zip"
		Get-ChildItem -Path "$Source\Website" | Compress-Archive -DestinationPath $Website_Files -Force
		Write-Host "Website zipped: $Website_Files" -ForegroundColor Green
	}
	Else
	{
		Write-Host "Source didn't exist or there were no files available for export: $Source\Website" -ForegroundColor Yellow
	}

	# Test if mockup files exist and then create a .ZIP file
	If ((Test-Path -Path "$Source\Mockups") -and ((Get-ChildItem -Path "$Source\Mockups" -ErrorAction SilentlyContinue).Count -ge 1))
	{
		$Mockup_Files = "$Source\$($Random)_Mockups.zip"
		Get-ChildItem -Path "$Source\Mockups" | Compress-Archive -DestinationPath $Mockup_Files -Force
		Write-Host "Mockups zipped: $Mockup_Files" -ForegroundColor Green
	}
	Else
	{
		Write-Host "Source didn't exist or there were no files available for export: $Source\Mockups" -ForegroundColor Yellow
	}

	# Start explorer and open the folder
	explorer.exe "$Source"		
}