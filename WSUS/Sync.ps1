<#
	.DESCRIPTION
	Sync WSUS with Windows Updates every second tuesday and the day after. You can schedule this script and let it run every day.

	.NOTES
	Author: Mark Wilbrink
	Date: see Git info
#>

$Second_Tuesday = (0..30 | % { (Get-Date -Day 1).AddDays($_) } | ? { $_.DayOfWeek -match "Tuesday|Dinsdag" })[1]
$Day_After_Second_Tuesday = $Second_Tuesday.AddDays(1)

# Check if today is the second tuesday of the month or the day after
If ((Get-Date -Format "yyyy-MM-dd") -eq (Get-Date $Second_Tuesday -Format "yyyy-MM-dd") -or (Get-Date -Format "yyyy-MM-dd") -eq (Get-Date $Day_After_Second_Tuesday -Format "yyyy-MM-dd"))
{
	Write-Host "Get latest sync status..." -ForegroundColor Yellow
	(Get-WsusServer).GetSubscription().GetLastSynchronizationInfo()

	Write-Host "Sync with Windows Updates..." -ForegroundColor Yellow
	(Get-WsusServer).GetSubscription().StartSynchronization()
}
Else
{
	Write-Host "Today there are no updates available :)" -ForegroundColor Yellow
}