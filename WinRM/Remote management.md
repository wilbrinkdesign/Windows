### Session with certificate

```powershell
Enter-PSSession -ComputerName "<server>" -Credential $Cred -UseSSL
```

### Session with certificate without check

```powershell
Enter-PSSession -ComputerName "<server>" -UseSSL -Credential $Cred -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck)
```

### Session Kerberos authentication (and with certificate)

```powershell
Enter-PSSesion -ComputerName "<server>"
Enter-PSSesion -ComputerName "<server>" -UseSSL
```