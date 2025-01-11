<#
	.DESCRIPTION
	Install Zabbix agent with specific HostMetadata.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	Dependencies:
		- zabbix_agent2-<version>-windows-amd64-openssl.msi
		- PSK (pre-shared keys)
	
	.LINK
	https://www.zabbix.com/documentation/current/en/manual/installation/install_from_packages/win_msi

	.EXAMPLE
	PS> <script_name>.ps1 -Server <name> -Type "Prod"
#>

Param(
	[string]$AgentMSI = "zabbix_agent2-windows-amd64-openssl.msi", # Working directory
	[string]$AgentConfig = "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf",
	[Parameter(Mandatory=$True)][string]$Server,
	[string]$HostMetadata = "windows",
 	[string]$Type = "",
	[string]$PSKName = "",
	[Parameter(Mandatory=$True)][string]$PSKPassword
)

# Check type server: Prod/Test/Develop
switch -Regex ($Type)
{
	"test|dev" { $HostMetadata += ",windows-test" }
	default { $HostMetadata += ",windows-prod" }
}

# Check if server is domain joined or not
If ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain -eq $True) { $HostMetadata += ",windows-domain" } Else { $HostMetadata += ",windows-nondomain" }

$HostMetadata += ",windows-$(Get-Date -Format 'yyyyMMddHHmm')"

# Zabbix install
If (Test-Path "$PSScriptRoot\$AgentMSI")
{
	Write-Host "Installing Zabbix Agent with HostMetadata: $HostMetadata" -ForegroundColor Yellow
	Get-Service "*Zabbix*" | Stop-Service
	Start-Process msiexec.exe -Wait -ArgumentList "/i $PSScriptRoot\$AgentMSI /qb SERVER=$Server SERVERACTIVE=$Server HOSTNAME=$env:COMPUTERNAME HostMetadata=$HostMetadata TLSPSKIDENTITY=$PSKName TLSPSKVALUE=$PSKPassword TLSCONNECT=psk TLSACCEPT=psk TIMEOUT=30 ALLOWDENYKEY=AllowKey=system.run[*]"

	Write-Host "Restarting service Zabbix Agent..." -ForegroundColor Yellow
	Get-Service "*Zabbix*" | Restart-Service
}
Else
{
	Write-Host "Zabbix Agent MSI installer not found: $PSScriptRoot\$AgentMSI" -ForegroundColor Red
}