# Set pagefile to auto
$Pagefile = Get-WmiObject Win32_ComputerSystem
$Pagefile.AutomaticManagedPagefile = $false
$Pagefile.Put()

# Place pagefile on E:\ drive
$Pagefile_E_Drive = Get-WmiObject Win32_PagefileSetting
$Pagefile_E_Drive.Name = "E:\pagefile.sys"
$Pagefile_E_Drive.Caption = "E:\pagefile.sys"
$Pagefile_E_Drive.Description = "’pagefile.sys’ @ E:\"
$Pagefile_E_Drive.SettingID ="pagefile.sys @ E:"
$Pagefile_E_Drive.put()

# Delete pagefile on C:\ drive
$Pagefile_C_Drive = Get-WmiObject Win32_PagefileSetting | Where-Object { $_.Name -eq "C:\pagefile.sys" }
$Pagefile_C_Drive.delete()