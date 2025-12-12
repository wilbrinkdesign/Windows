<#
	.DESCRIPTION
	This script will check certain event ids on for example, a Domain Controller for the last hour.
	
	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
#>

# All possible event ids
$Event_IDs = @{
	4738 = [PSCustomObject]@{Name = "Password never expires"; Recipient = @("name@domain1.com")}
	4625 = [PSCustomObject]@{Name = "Unsuccesaful login"; Recipient = @("name@domain1.com")}
	531 = [PSCustomObject]@{Name = "Login disabled account"; Recipient = @("name@domain1.com")}
	676 = [PSCustomObject]@{Name = "Login disabled account"; Recipient = @("name@domain1.com")}
	681 = [PSCustomObject]@{Name = "Login disabled account"; Recipient = @("name@domain1.com")}
	4624 = [PSCustomObject]@{Name = "Successful login"; Recipient = @("name@domain1.com")}
	4740 = [PSCustomObject]@{Name = "Account lockout"; Recipient = @("name@domain1.com")}
	4728 = [PSCustomObject]@{Name = "Added to privileged group"; Recipient = @("name@domain1.com")}
	4729 = [PSCustomObject]@{Name = "Removed from privileged group"; Recipient = @("name@domain1.com")}
	4724 = [PSCustomObject]@{Name = "Password reset"; Recipient = @("name@domain1.com", "name@domain2.com")}
}

$Privileged_Groups = "Domain Admins|Enterprise Admins|Schema Admins"

$Events = Get-WinEvent -FilterHashtable @{LogName = "Security"; ID = $($Event_IDs.Keys); StartTime = (Get-Date).AddHours(-1)} -ErrorAction SilentlyContinue

# Loop through all events
$Complete_List = @()

Foreach ($Log in $Events)
{
	If ($Log.Id -eq 4738 -and $Log.Message -notmatch "Expire Password") { Continue }
	If ($Log.Id -eq 4624)
	{
		If ($Log.Message -notmatch "Account Name:\s+(admin[^\r\n]+)") { Continue } # Search for specific accounts by checking 'Account Name:'
		If ($Log.Message -notmatch "Logon Type:\s+(2|10)") { Continue } # Looking for interactive sessions by checking 'Logon Type:'
	}
	If ($Log.Id -eq 4728 -and $Log.Message -notmatch $Privileged_Groups) { Continue }
	If ($Log.Id -eq 4729 -and $Log.Message -notmatch $Privileged_Groups) { Continue }
	
	$List = New-Object -TypeName PSObject
	$List | Add-Member -NotePropertyName Event -NotePropertyValue $Event_IDs[$Log.Id].Name
	$List | Add-Member -NotePropertyName EventID -NotePropertyValue $Log.Id
	$List | Add-Member -NotePropertyName Time -NotePropertyValue $Log.TimeCreated
	$List | Add-Member -NotePropertyName Message -NotePropertyValue $Log.Message
	$List | Add-Member -NotePropertyName Recipient -NotePropertyValue $Event_IDs[$Log.Id].Recipient

	$Complete_List += $List
}

Return $Complete_List | ConvertTo-Json