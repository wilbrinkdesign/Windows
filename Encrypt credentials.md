#### Define vars for username, password and the encrypted file

```powershell
$Username = ""
$Password = ""
$Password_File = ""
```

### Option 1

```powershell
# Encrypt credentials with 16-byte key
$Password | ConvertFrom-SecureString -Key (1..16) | Out-File $Password_File

# Decrypt credentials with the same 16-byte key
$Password = Get-Content $Password_File | ConvertTo-SecureString -Key (1..16)

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

For option 1, we use a **16-byte key** so that the encryption doesn't get tied to the current user's credentials. This way, any user could decrypt the credentials. Not the safest way, but better than plaintext credentials.

Option 2 is the same as option 1, but the main difference is that we use **DPAPI (Data Protection API)** for our encryption. This means that only the user who encrypted the credentials on the specific server can decrypt the credentials.

Option 3 uses the '**Export-Clixml**' (DPAPI) function so that only the user who encrypted the credentials on the specific server can decrypt the credentials.

In the scripts above, the variable '**$Cred**' becomes available. This variable can be used in your scripts to make, for example, a drive mapping.