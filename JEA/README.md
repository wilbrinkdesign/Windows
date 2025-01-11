### JEA requirements

```powershell
# Create mandatory directories
New-Item -Path '<transcript_dir>' -ItemType Directory
New-Item -Path '<jea_dir>' -ItemType Directory

# Create the JEA config file (who gets what permissions?)
New-PSSessionConfigurationFile -Path '<jea_dir>\<jea_config>.pssc'

# Create the JEA capability file (what can the user do on the system?)
New-PSRoleCapabilityFile -Path '<jea_dir>\<jea_capability>.psrc'

# Register the JEA config file
Register-PSSessionConfiguration -Name <name> -Path '<jea_dir>\<jea_config>.pssc'

# Restart WinRM
Restart-Service WinRM

# Connect to server with JEA config file
Enter-PSSession <server> -ConfigurationName <name>
```

### Example content of file: <jea_config>.pssc

```powershell
SessionType = 'RestrictedRemoteServer'
TranscriptDirectory = '<transcript_dir>'
RunAsVirtualAccount = $true
RoleDefinitions = @{ '<domain>\<group>' = @{ RoleCapabilities = '<jea_config>' }}
```

### Example content of file: <jea_capability>.psrc

```powershell
VisibleCmdlets = @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = '<service_name>' } }
VisibleFunctions = 'TabExpansion2'
VisibleExternalCommands = '<command_path>'
```