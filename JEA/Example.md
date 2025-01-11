# JEA Example: Windows Update admin capabilities

### Create mandatory directories

```powershell
New-Item -Path 'C:\Transcripts' -ItemType Directory
New-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\JEA\RoleCapabilities' -ItemType Directory
```

### Create the JEA config file (who gets what permissions?)

```powershell
$Roles = @{
	'<domain>\<admin_group>' = @{ RoleCapabilities = 'WindowsUpdateAdmin' }
	'<domain>\<user_group>' = @{ RoleCapabilities = 'WindowsUpdateUser' }
}

$Parameters = @{
	SessionType = 'RestrictedRemoteServer'
	Path = 'C:\Program Files\WindowsPowerShell\Modules\JEA\RoleCapabilities\WindowsUpdateConfig.pssc'
	RunAsVirtualAccount = $true
	TranscriptDirectory = 'C:\Transcripts'
	RoleDefinitions = $Roles
}

New-PSSessionConfigurationFile @Parameters
```

### Create the JEA capability file (what can the user do on the system?)

```powershell
# Admins
$Parameters = @{
	Path = "C:\Program Files\WindowsPowerShell\Modules\JEA\RoleCapabilities\WindowsUpdateAdmin.psrc"
	VisibleCmdlets = "Restart-Service", @{
		Name = "Restart-Service"
		Parameters = @{ Name = "Service"; ValidateSet = "wuauserv" }
	}
	VisibleFunctions = 'TabExpansion2'
	VisibleExternalCommands = 'C:\Windows\System32\UsoClient.exe', 'C:\Windows\wuauclt.exe'
}

New-PSRoleCapabilityFile @Parameters

# Normal users
$Parameters = @{
	Path = "C:\Program Files\WindowsPowerShell\Modules\JEA\RoleCapabilities\WindowsUpdateUser.psrc"
	VisibleFunctions = 'TabExpansion2'
	VisibleExternalCommands = 'C:\Windows\System32\UsoClient.exe', 'C:\Windows\wuauclt.exe'
}

New-PSRoleCapabilityFile @Parameters
```

### Register the JEA config file

```powershell
Register-PSSessionConfiguration -Name WindowsUpdate -Path 'C:\Program Files\WindowsPowerShell\Modules\JEA\RoleCapabilities\WindowsUpdateConfig.pssc' -Force
```

### Restart WinRM

```powershell
Restart-Service WinRM -Force
```

### Connect to server with JEA

```powershell
Enter-PSSession <server> -ConfigurationName WindowsUpdate
```