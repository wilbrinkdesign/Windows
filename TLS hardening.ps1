<#
	.DESCRIPTION
	Enable or disable TLS hardening.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	.PARAMETER WhatIf
	You can add the WhatIf parameter to this script so you can see what will happen if you run this script in production

	.EXAMPLE
	PS> <script_name>.ps1 -StrongCrypto:$false
 	PS> <script_name>.ps1 -StrongCrypto:$false -WhatIf
#>

[CmdletBinding(SupportsShouldProcess)]
Param(
	[boolean]$StrongCrypto = $True
)

$Protocol_Key = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
$Reg_dotNET_x86 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319"
$Reg_dotNET_x64 = "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"

If ($StrongCrypto -eq $True) # Only allow strong crypto
{
	$TLS_Protocols = @{ "TLS 1.2" = 1; "TLS 1.1" = 0; "TLS 1.0" = 0; "SSL 2.0" = 0 }
	$TLS_dotNET = 1
}
Else # Allow weak crypto
{
	$TLS_Protocols = @{ "TLS 1.2" = 1; "TLS 1.1" = 1; "TLS 1.0" = 1; "SSL 2.0" = 1 }
	$TLS_dotNET = 0
}

Foreach ($Protocol in $TLS_Protocols.GetEnumerator())
{
	# Create main key for client/server
	New-Item $Protocol_Key"\$($Protocol.Name)\$Type" -Force

	# Set TLS keys
	If ($Protocol.Value -eq 0) { $Protocol_Disabled_By_Default = 1 } Else { $Protocol_Disabled_By_Default = 0 }
	New-ItemProperty -Path $Protocol_Key"\$($Protocol.Name)\Server" -Name Enabled -Value $Protocol.Value -PropertyType DWORD -Force
	New-ItemProperty -Path $Protocol_Key"\$($Protocol.Name)\Server" -Name DisabledByDefault -Value $Protocol_Disabled_By_Default -PropertyType DWORD -Force
	New-ItemProperty -Path $Protocol_Key"\$($Protocol.Name)\Client" -Name Enabled -Value $Protocol.Value -PropertyType DWORD -Force
	New-ItemProperty -Path $Protocol_Key"\$($Protocol.Name)\Client" -Name DisabledByDefault -Value $Protocol_Disabled_By_Default -PropertyType DWORD -Force
}

# Set .NET keys
New-ItemProperty -Path $Reg_dotNET_x86 -Name SystemDefaultTlsVersions -Value $TLS_dotNET -PropertyType DWORD -Force
New-ItemProperty -Path $Reg_dotNET_x86 -Name SchUseStrongCrypto -Value $TLS_dotNET -PropertyType DWORD -Force
New-ItemProperty -Path $Reg_dotNET_x64 -Name SystemDefaultTlsVersions -Value $TLS_dotNET -PropertyType DWORD -Force
New-ItemProperty -Path $Reg_dotNET_x64 -Name SchUseStrongCrypto -Value $TLS_dotNET -PropertyType DWORD -Force
