### Get all Windows versions from ISO

```powershell
dism /Get-WimInfo /WimFile:<disk>\sources\install.wim
```

### Create an export of the ISO file

```powershell
dism /export-image /SourceImageFile:<disk>\sources\install.wim /SourceIndex:5 /DestinationImageFile:<dir>\install.wim /Compress:max /CheckIntegrity
```

### Inject drivers into the WIM file

```powershell
dism /Mount-Wim /WimFile:<source_path>\boot.wim /Index:1 /MountDir:<mount_path>
dism /Image:<mount_path> /Add-Driver /Driver:<driver_path> /recurse
dism /Unmount-Wim /MountDir:<mount_path> /Commit
```

### Add Windows Updates

```powershell
dism /mount-wim /wimfile:<source_path>\boot.wim /Index:1 /mountdir:<mount_path>
dism /image:<mount_path> /Add-Package /PackagePath:<windows_updates_path>
dism /Unmount-wim /mountdir:<mount_path> /commit
```