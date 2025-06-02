<#
	.DESCRIPTION
	Set a certificate for the WinRM HTTPS listener so you can remote manage the Windows server securely.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
#>

$FQDN = [System.Net.Dns]::GetHostByName($env:COMPUTERNAME).HostName
$Cert = Get-ChildItem -Path Cert:\LocalMachine\My\ | Where-Object { $_.Subject -like "CN=$FQDN*" -and $_.NotAfter -gt (Get-Date) } | Sort-Object NotAfter -Descending | Select-Object -First 1
$HTTPSListener = Try { Get-WSManInstance winrm/config/listener -SelectorSet @{Transport='HTTPS'; Address='*'} } Catch {}

Function New-SelfSignedCert
{
	Write-Host "Create self-signed cert..." -ForegroundColor Yellow
	$Cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $FQDN
}

Function Activate-HTTPSListener
{
	If (!(Test-WSMan $FQDN))
	{
		Write-Host "Enable remote PowerShell..." -ForegroundColor Yellow
		Enable-PSRemoting -SkipNetworkProfileCheck -Force
	}

	If (!$HTTPSListener)
	{
		Write-Host "Create new HTTPS listener and bind cert..." -ForegroundColor Yellow
		New-WSManInstance winrm/config/listener -SelectorSet @{Transport='HTTPS'; Address='*'} -ValueSet @{Hostname=$FQDN;CertificateThumbprint=$Cert.Thumbprint} | Out-Null
	} 
	Else
	{
		Write-Host "Use existing HTTPS listener and bind cert..." -ForegroundColor Yellow
		Set-WSManInstance winrm/config/listener -SelectorSet @{Transport="HTTPS"; Address="*"} -ValueSet @{Hostname=$FQDN;CertificateThumbprint=$Cert.Thumbprint} | Out-Null
	}

	If (!(Get-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -ErrorAction SilentlyContinue))
	{
		Write-Host "Creating firewall rule: Windows Remote Management (HTTPS-In)" -ForegroundColor Yellow
		New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP
	}

	Write-Host "Restart WinRM..." -ForegroundColor Yellow
	Restart-Service WinRM -Force
}

If ($Cert.Thumbprint)
{
	If ($HTTPSListener)
	{
		If ($Cert.Thumbprint -eq $HTTPSListener.CertificateThumbprint)
		{
			Write-Host "HTTPS listener already active and configured. Nothing to do." -ForegroundColor Green
			Break
		}
		Else
		{
			Write-Host "HTTPS listener already active and configured, but with an other cert. Bind new cert to existing HTTPS listener..." -ForegroundColor Yellow
			Activate-HTTPSListener
		}
	}
	Else
	{
		Write-Host "HTTPS listener not configured. Bind cert to HTTPS listener..." -ForegroundColor Yellow
		Activate-HTTPSListener
	}
}
Else
{
	If ($HTTPSListener)
	{
		Write-Host "No valid cert found, but the HTTPS listener is already configured. Creating self-singed cert and bind to HTTPS listener..." -ForegroundColor Yellow
	}
	Else
	{
		Write-Host "No valid cert found and no active HTTPS listener. Creating self-singed cert and bind to HTTPS listener..." -ForegroundColor Yellow
	}

	New-SelfSignedCert
	Activate-HTTPSListener
}