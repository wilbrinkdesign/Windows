### Examples for proxies for SYSTEM account

```powershell
bitsadmin /Util /SetIEProxy localsystem AUTODETECT
bitsadmin /util /setieproxy localsystem MANUAL_PROXY <proxy>:<port> ""
```