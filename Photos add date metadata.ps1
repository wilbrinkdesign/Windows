<#
	.DESCRIPTION
	Add date to the metadata of pictures.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	Dependencies: ExifTool

	Check current metadata date: exiftool -DateTimeOriginal -s3 <file>

	.PARAMETER Folder
	This is the source path where the files resign where you want to add the date as metadata.

	.PARAMETER Recurse
	Activate this switch if there are any files in subfolders.

	.PARAMETER DateFormat
	Use this parameter if you're photos have different date formatting then 'yyyyMMdd'.

	.LINK
	https://exiftool.org/

	.EXAMPLE
	PS> <script_name>.ps1 Folder <path> -DateFormat "yyyy-MM-dd"
#>

Param(
	[string]$Folder,
	[switch]$Recurse,
	[string]$DateFormat = "yyyyMMdd"
)

# If ExifTool is not installed, then exit the script
If (!(Get-Command exiftool -ErrorAction SilentlyContinue))
{
	Write-Host "ExifTool not installed: https://exiftool.org/" -ForegroundColor Red
	Break
}

# Check folder path
If (!(Test-Path -Path $Folder))
{
	Do
	{
		$Folder = Read-Host "Where are the files that you want to add the date as metadata? Provide the path"
	} Until ((Test-Path -Path $Folder) -eq $True)
}

If ($Recurse) { $Recurse_Param = @{ "Recurse" = $True } } # Use the -Recurse parameter for Get-ChildItem if the switch was used

$Files = Get-ChildItem $Folder @Recurse_Param

Foreach ($File in $Files)
{
	Try
	{
		Write-Host "Checking: $($File.Name)" -ForegroundColor Yellow
		$Name = $($File.Name).Substring(0, 8)
		$Date = [datetime]::ParseExact($Name, $DateFormat, $null)
		$File_Date = Get-Date $Date -Format "yyyy:MM:dd HH:mm:Ss"

		Write-Host "Add date $File_Date to metadata of file: $($File.Name)" -ForegroundColor Green
		exiftool "-DateTimeOriginal=$File_Date" "-DateTimeDigitized=$File_Date" "-overwrite_original" "$($File.FullName)"
	} Catch {}
}