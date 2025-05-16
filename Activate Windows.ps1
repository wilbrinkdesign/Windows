<#
	.DESCRIPTION
	Activate Windows with the GVLK key (Generic Volume License Keys). You have to have Active Directory-based activation in-place or a KMS server to activate against.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	.LINK
	https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys?tabs=server2022%2Cwindows1110ltsc%2Cversion1803%2Cwindows81
#>

Param(
	[Parameter(Mandatory=$True)][ValidateSet("AD","KMS")]$TypeActivation,
	[string]$KMSServer
)

$OS_Version = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName

$Keys = @{
	"Windows Server 2012 R2 Standard" = "D2N9P-3P6X9-2R39C-7RTCD-MDVJX"
	"Windows Server 2016 Standard" = "WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY"
	"Windows Server 2019 Standard" = "N69G4-B89J2-4G8F4-WWYCC-J464C"
	"Windows Server 2022 Standard" = "VDYBN-27WPP-V4HQT-9VMD4-VMK7H"
	"Windows Server 2025 Standard" = "TVRH6-WHNXV-R9WG3-9XRFY-MY832"
}

If (($Keys[$OS_Version] | Measure-Object -Character).Characters -eq 29)
{
	Write-Host "Windows version: $OS_Version, Type: Domain, Key: $($Keys[$OS_Version]), install..." -ForegroundColor Yellow
	If ($TypeActivation -eq "AD")
	{
		cscript C:\Windows\System32\slmgr.vbs /ckms
		cscript C:\Windows\System32\slmgr.vbs /ckms-domain
		cscript C:\Windows\System32\slmgr.vbs /ipk $Keys[$OS_Version]
	}
	Else
	{
		cscript C:\Windows\System32\slmgr.vbs /skms "$($KMSServer):1688"
		cscript C:\Windows\System32\slmgr.vbs /ipk $Keys[$OS_Version]
	}

	cscript C:\Windows\System32\slmgr.vbs /ato
}
Else
{
	Write-Host "Windows key not found. Different kind of Windows? Current version: $OS_Version" -ForegroundColor Red
}