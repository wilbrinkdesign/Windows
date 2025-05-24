### Clean IIS log files

```powershell
forfiles -p <inetpub_dir>\logs\LogFiles\ -s -m *.log -d -180 -c "cmd /C DEL @File"
```

### Get current visitors from a specific site

```powershell
Get-Counter "\\<server>\web service(<website>)\current connections"
```

### Get all current visitors

```powershell
Get-Counter 'web service(_total)\current connections' -ComputerName $env:COMPUTERNAME
```

### Activate Kerberos authentication on a IIS website

1. IIS => Set "Windows authentication" => On => Disable other authentication methods
2. IIS => Set "Negotiate" on top of all other authentication methods (ntlm last)
3. PowerShell => setspn -a HTTP/<server+fqdn> <domain>\<user>
4. IIS => Set system.wevServer/security/authentication/WindowsAuthentication => useKernelMode => True
5. IIS => Set system.wevServer/security/authentication/WindowsAuthentication => useAppPoolCredentials => True
6. IIS => Set Application Pool credentials <domain>\<user>
7. AD => Set AD user Delegation tab => Trust this user for delegation to any service (Kerberos only)

[Manual Kerberos configuration for IIS](https://techcommunity.microsoft.com/t5/iis-support-blog/setting-up-kerberos-authentication-for-a-website-in-iis/ba-p/347882)