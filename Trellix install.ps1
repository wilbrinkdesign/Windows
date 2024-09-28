<#
	.DESCRIPTION
	Install Trellix agent with tags/custom properties.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	Dependencies: FramePkg.exe

	.LINK
	https://docs.trellix.com/nl-NL/bundle/agent-5.6.x-installation-guide/page/GUID-5BA40056-3E60-4ABE-863F-9DDEBCFD5C0C.html
	
	.EXAMPLE
	PS> <script_name>.ps1 -Server <server> -TrellixInstaller FramePkg.exe
#>

Param(
	[Parameter(Mandatory=$True)][string]$Server,
	[Parameter(Mandatory=$True)][string]$TrellixInstaller,
	[string]$Tag
)

While (-not (Test-Connection $Server -ErrorAction SilentlyContinue)) # Als de server bereikbaar is, ga dan verder
{
	Write-Host "Trellix server not available: $Server" -ForegroundColor Red
	Write-Host "Make sure the Trellix server is available. New check will be in 60 seconds..." -ForegroundColor Red
	Start-Sleep -Seconds 60
}

$Tags_Scan_Days = @("Mo", "Tu", "We", "Th", "Fd", "Sa", "Su")
$Tag_Day = Get-Random -InputObject $Tags_Scan_Days

Write-Host "Trellix agent install with tags: $Tag, $Tag_Day" -ForegroundColor Yellow
Start-Process $TrellixInstaller -ArgumentList "/INSTALL=AGENT /Customprops1=$Tag /Customprops2=$Tag_Day /Silent" -Wait

Do {
	Write-Host "$(Get-Date -Format HH:mm): Updating Trellix..." -ForegroundColor Yellow
	$Updating = Get-Process msiexec -ErrorAction SilentlyContinue
	Start-Sleep -Seconds 60
} Until (!$Updating)