### Get all certificates

```powershell
Get-ExchangeCertificate
```

### Get connectors with certificate

```powershell
Get-SendConnector | where {$_.TlsCertificateName}
Get-ReceiveConnector | where {$_.TlsCertificateName}
```

### Activate certificate on connector

```powershell
$cert = Get-ExchangeCertificate -Thumbprint <thumbprint>
$tls = "<i>$($cert.Issuer)<s>$($cert.Subject)"
Set-SendConnector "<connector>" -TlsCertificateName $tls
Restart-Service MSExchangeTransport
```

### Restart Transport service after activating certificate

```powershell
Restart-Service MSExchangeTransport
```

### Get all availability groups

```powershell
Get-DatabaseAvailabilityGroup
```

### Get database copy status

```powershell
Get-MailboxDatabaseCopyStatus * -Active
```

### Get all performance counters

```powershell
Get-Counter -ListSet "*Queues*"
Get-Counter -ListSet "MSExchangeTransport Queues" | select -ExpandProperty paths
```

### Get specific performance counters

```powershell
Get-Counter "\MSExchangeTransport Queues(_total)\Aggregate Shadow Queue Length"
```

### Get Public Folders

```powershell
Get-OrganizationConfig | fl publicfoldersenabled
```

### Create master hierachy for Public Folders

```powershell
New-Mailbox -PublicFolder -Name MasterHierachy
```

### Add permissions to Public Folders

```powershell
Add-PublicFolderClientPermission "\<folder>\<name>" -User "<group>" -AccessRights Reviewer
```

### Get Public Folders permissions

```powershell
Get-PublicFolder "\<folder>\<name>" | Get-PublicFolderClientPermission
```