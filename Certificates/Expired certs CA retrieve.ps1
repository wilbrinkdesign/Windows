<#
	.DESCRIPTION
	Get expired certificates from CA (PKI environment).
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	Dependencies: PSPKI PS Module

	.EXAMPLE
	PS> <script_name>.ps1 -Server <server> -Template <template_oid> -Days <days>
#>

Param(
	[Parameter(Mandatory=$True)][string]$Server,
	[Parameter(Mandatory=$True)][string]$Template,
	[Parameter(Mandatory=$True)][int]$Days
)

If ((Get-Module -ListAvailable -Name PSPKI)) # If PS module PSPKI is installed, continue
{
	Write-Host "Loading PSPKI PS module..." -ForegroundColor Yellow
	Import-Module PSPKI

	Write-Host "Checking expired ($Days days) certificates on: $Server" -ForegroundColor Yellow
	$Expired_Certs = Get-IssuedRequest -CertificationAuthority $Server -Property "Request.RawRequest" | Where-Object { $_.CertificateTemplate -match $Template -and (Get-Date $_.NotAfter -Format "yyyy-MM-dd") -eq (Get-Date (Get-Date).AddDays($Days) -Format "yyyy-MM-dd") }
	
	Foreach ($Cert in $Expired_Certs)
	{
		If ($Cert.CommonName)
		{
			$Name = $Cert.CommonName
			$Date = Get-Date $Cert.NotAfter -UFormat "%A %d %B %Y"

   			$Bytes = [System.Convert]::FromBase64String($Cert.'Request.RawRequest')
			$SAN = (New-Object System.Security.Cryptography.X509CertificateRequests.X509CertificateRequest (,$Bytes) | select -ExpandProperty Extensions).AlternativeNames.Value

			Write-Host "Expired certificate within $Days days: $Name (SAN: $($SAN -join ', ')), $Date" -ForegroundColor Yellow
		}
	}
}
Else
{
	Write-Host "PowerShell module not installed: PSPKI" -ForegroundColor Red
}