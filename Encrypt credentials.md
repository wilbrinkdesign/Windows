#### Define vars for username, password and the encrypted file

```powershell
$Username = "<username>"
$Password = "<password>" | ConvertTo-SecureString -AsPlainText -Force
$Password_File = "<file_path>"
```

### Option 1

```powershell
# Encrypt credentials with 32-byte key (AES-256)
$Password | ConvertFrom-SecureString -Key (1..32) | Out-File $Password_File

# Decrypt credentials with the same 32-byte key (AES-256)
$Password = Get-Content $Password_File | ConvertTo-SecureString -Key (1..32)

# Store credentials in var '$Cred'
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password
```

### Option 2

```powershell
# Encrypt credentials with DPAPI
$Password | ConvertFrom-SecureString | Out-File $Password_File

# Decrypt credentials
$Password = Get-Content $Password_File | ConvertTo-SecureString

# Store credentials in var '$Cred'
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password
```

### Option 3

```powershell
# Encrypt credentials with DPAPI
New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password | Export-Clixml -Path $Password_File

# Store credentials in var '$Cred'
$Cred = Import-Clixml -Path $Password_File
```

### Option 4

```powershell
# Encrypt credentials with 32-byte key (AES-256)
$Key = (1..32) | ForEach-Object { Get-Random -Maximum 256 }
[System.IO.File]::WriteAllBytes("$($Password_File).key", $Key)
$Password | ConvertFrom-SecureString -Key $Key | Set-Content $Password_File

# Decrypt credentials with the same 32-byte key (AES-256) file
$Key = [System.IO.File]::ReadAllBytes("$($Password_File).key")
$Password = Get-Content $Password_File | ConvertTo-SecureString -Key $Key

# Store credentials in var '$Cred'
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password
```

### Test password

```powershell
# If you succesfully read the credentials into '$Cred', you can show the password
[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Cred.Password))
```

For option 1, we use a fixed **32-byte key (AES-256)** so that the encryption doesn't get tied to the current user and machine. This way, any user could decrypt the credentials with the password file.

Option 2 is the same as option 1, but the main difference is that we use **DPAPI (Data Protection API)** for our encryption. This means that the encryption is tied to the user and machine, making the password file not transferable to other users or machines.

Option 3 uses the '**Export-Clixml**' (DPAPI) function. Like option 2, this also means that the encryption is tied to the user and machine, making the password file not transferable to other users or machines.

Option 4 uses a random **32-byte key (AES-256)** that is exported as a key file with the password file. This way, any user could decrypt the credentials when they have access to the password file and the key file.

In the scripts above, the variable '**$Cred**' becomes available. This variable can be used in your scripts to make, for example, a drive mapping.