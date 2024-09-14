### Enable WinRM

```cmd
winrm quickconfig
```

### Get WinRM auth methods

```cmd
winrm get winrm/config/service/auth
```

### Get WinRM listeners

```cmd
winrm e winrm/config/listener
```

### Enable HTTPS listener

```cmd
winrm quickconfig -transport:https
```

### Delete HTTPS listener

```cmd
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
```