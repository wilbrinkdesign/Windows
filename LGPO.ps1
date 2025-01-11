<#
	.DESCRIPTION
	Implementing our own policy and security settings for the local GPO.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info

	Dependencies: LGPO.exe

	Before you start, you need to know how the local GPO settings look like. For this you must first edit the local GPO by 'gpedit.msc'.
	Then you can export the GPO settings with this command: LGPO.exe /b <folder>
	Your security settings are stored in 'GptTmpl.inf'.
	To get your policy settings, you can use this command: LGPO.exe /parse /m <folder>\DomainSysvol\GPO\Machine\registry.pol >> <file.txt>

	The GPO settings in this script are examples, please make it your own!

	.LINK
	https://www.microsoft.com/en-us/download/confirmation.aspx?id=55319
	https://brookspeppin.com/2018/11/04/modify-local-gpo-examples/

	.EXAMPLE
	PS> <script_name>.ps1 -LGPOTool <lgpo.exe>
#>

Param(
	[Parameter(Mandatory=$True)][string]$LGPOTool
)

$Inf_Sec_Policy = "
[Unicode]
Unicode=yes
[System Access]
MinimumPasswordAge = 0
MaximumPasswordAge = 365
MinimumPasswordLength = 12
PasswordComplexity = 1
PasswordHistorySize = 24
LockoutBadCount = 10
ResetLockoutCount = 30
LockoutDuration = -1
AllowAdministratorLockout = 0
[Privilege Rights]
SeDenyRemoteInteractiveLogonRight = 
SeDenyNetworkLogonRight = 
[Registry Values]
MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\InactivityTimeoutSecs=4,3600
[Version]
signature=`"`$CHICAGO$`"
Revision=1
"

$Txt_Policy = "
Computer
SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
ConsentPromptBehaviorAdmin
DWORD:5

Computer
SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
LocalAccountTokenFilterPolicy
DWORD:1

Computer
SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services
fPromptForPassword
DELETE

Computer
SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services
fDisableCdm
DELETE

Computer
SOFTWARE\Policies\Microsoft\Windows\DeviceGuard
*
DELETEALLVALUES

Computer
SOFTWARE\Policies\Microsoft\Windows\EventLog\Application
MaxSize
DWORD:2097088

Computer
SOFTWARE\Policies\Microsoft\Windows\EventLog\Security
MaxSize
DWORD:2097088

Computer
SOFTWARE\Policies\Microsoft\Windows\EventLog\System
MaxSize
DWORD:2097088

Computer
SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services
DisablePasswordSaving
DWORD:1
"

$Inf_Sec_Policy | Out-File "C:\Windows\Temp\Sec_Policy_Edits.inf" -Encoding ASCII
$Txt_Policy | Out-File "C:\Windows\Temp\Policy_Edits.txt" -Encoding ASCII

If (Test-Path -Path $LGPOTool)
{
	Write-Host "Implementing our own policy and security settings..." -ForegroundColor Yellow
	Start-Process $LGPOTool -ArgumentList "/t C:\Windows\Temp\Policy_Edits.txt"
	Start-Process $LGPOTool -ArgumentList "/s C:\Windows\Temp\Sec_Policy_Edits.inf"
}
Else
{
	Write-Host "Policy settings not applied, LGPO.exe not found: $LGPOTool" -ForegroundColor Red
}