### How the shortcut works for a Windows App (example: Cortana)

1. Cortana App dir: **C:\Program Files\WindowsApps\Microsoft.549981C3F5F10_4.2204.13303.0_x64__8wekyb3d8bbwe**
2. The package name is: **Microsoft.549981C3F5F10_8wekyb3d8bbwe** (First name without version and everything after __)
3. The App ID is: **App** (check the **AppxManifest.xml** file and search for "**Application Id**" )
4. The shortcut code is: **Microsoft.549981C3F5F10_8wekyb3d8bbwe!App**

### Code for Cortana shortcut

```cmd
explorer shell:appsfolder\Microsoft.549981C3F5F10_8wekyb3d8bbwe!App
````