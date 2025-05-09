<#
	.DESCRIPTION
	Add date to the metadata of pictures.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	Dependencies: ExifTool

    Check current metadata date: exiftool -DateTimeOriginal -s3 <file>

	.LINK
	https://exiftool.org/
#>

Param(
	[Parameter(Mandatory=$True)][string]$Folder
)

$Files = Get-ChildItem $Folder -Recurse

Foreach ($File in $Files)
{
    Try
    {
        Write-Host "Checking: $($File.Name)" -ForegroundColor Yellow
        $Name = $($File.Name).Substring(0, 8)
        $Date = [datetime]::ParseExact($Name, "yyyyMMdd", $null)
        $File_Date = Get-Date $Date -Format "yyyy:MM:dd HH:mm:Ss"

        Write-Host "Add date $File_Date to metadata of file: $($File.Name)" -ForegroundColor Green
        exiftool "-DateTimeOriginal=$File_Date" "-DateTimeDigitized=$File_Date" "-overwrite_original" "$($File.FullName)"
    } Catch {}
}