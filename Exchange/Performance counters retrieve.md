### Get all performance counters

```powershell
Get-Counter -ListSet "*Queues*"
Get-Counter -ListSet "MSExchangeTransport Queues" | select -ExpandProperty paths
```

### Get specific performance counters

```powershell
Get-Counter "\MSExchangeTransport Queues(_total)\Aggregate Shadow Queue Length"
```