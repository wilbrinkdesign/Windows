### Set product code and server edition

```powershell
dism /online /Set-Edition:ServerDatacenter /ProductKey:<code> /AcceptEula
```

### Set product code and activate

```powershell
cscript C:\Windows\System32\slmgr.vbs /ipk <code>
cscript C:\Windows\System32\slmgr.vbs /ato
```

### Script to activate different types of Windows OS with KMS

```powershell
$OS_Version = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName

$Keys = @{
	"Windows Server 2012 R2 Standard" = "D2N9P-3P6X9-2R39C-7RTCD-MDVJX"
	"Windows Server 2016 Standard" = "WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY"
	"Windows Server 2019 Standard" = "N69G4-B89J2-4G8F4-WWYCC-J464C"
	"Windows Server 2022 Standard" = "VDYBN-27WPP-V4HQT-9VMD4-VMK7H"
}

If (($Keys[$OS_Version] | Measure-Object -Character).Characters -eq 29)
{
	If ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain -eq $True) # Domain
	{
		Write-Host "Windows version: $OS_Version, Type: Domain, Key: $($Keys[$OS_Version]), install..." -ForegroundColor Yellow
		cscript C:\Windows\System32\slmgr.vbs /ckms
		cscript C:\Windows\System32\slmgr.vbs /ckms-domain
		cscript C:\Windows\System32\slmgr.vbs /ipk $Keys[$OS_Version]
	}
	Else # Workgroup
	{
		Write-Host "Windows version: $OS_Version, Type: Workgroup, Key: $($Keys[$OS_Version]), install..." -ForegroundColor Yellow
		cscript C:\Windows\System32\slmgr.vbs /skms <kms:port>
		cscript C:\Windows\System32\slmgr.vbs /ipk $Keys[$OS_Version]
	}

	cscript C:\Windows\System32\slmgr.vbs /ato
}
Else
{
	Write-Host "Windows key not found. Different kind of Windows? Current version: $OS_Version" -ForegroundColor Red
}
```