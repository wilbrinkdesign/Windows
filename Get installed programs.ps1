<#
	.DESCRIPTION
	Get all installed programs.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
#>

$Apps_WMI = Get-WmiObject -Class Win32_Product | Where-Object Name -ne $null
$Apps_Reg = @(
	"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
	"HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
	"HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
	"HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)
$Apps_RegKey = Get-ChildItem $Apps_Reg | Get-ItemProperty | Where-Object DisplayName -ne $null

$Complete_List = @()

Foreach ($App_WMI in $Apps_WMI)
{
	$List = New-Object -TypeName PSObject
	$List | Add-Member -NotePropertyName Name -NotePropertyValue $App_WMI.Name
	$List | Add-Member -NotePropertyName Version -NotePropertyValue $App_WMI.Version

	$Complete_List += $List
}

Foreach ($App_RegKey in $Apps_RegKey)
{
	$List = New-Object -TypeName PSObject
	$List | Add-Member -NotePropertyName Name -NotePropertyValue $App_RegKey.DisplayName
	$List | Add-Member -NotePropertyName Version -NotePropertyValue $App_RegKey.DisplayVersion

	$Complete_List += $List
}

$Complete_List | Sort-Object Name -Unique