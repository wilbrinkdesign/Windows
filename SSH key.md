### SSH from Windows to Linux

```powershell
ssh-keygen
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add <ssh_private_key>
type <ssh_public_key> | ssh <user>@<host> "cat >> .ssh/authorized_keys"
```