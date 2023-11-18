# Windows install scripts

## Prerequisites

- Windows 10 or higher
- Powershell (installed by default)
- Script execution allowed

To start powershell, read [Microsoft documentation](https://learn.microsoft.com/en-us/powershell/scripting/windows-powershell/starting-windows-powershell?view=powershell-7.3)

On windows, for you user to be able to run scripts you have to run this command :

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

### Download

#### With Git

```
git clone git@github.com:Nexir/windows-install.git
```

#### With Browser

![Download](/images/download.png)

(extract the archive)

### Launch Terminal

![Launch terminal](/images/terminal.png)

## Debloat Windows

### Check program list

Before running the script you may check the file **programs-to-remove.txt** to verify the packages which will be removed.

### Run script

If you want to uninstall some default windows packages run the command below, which will ask for admin rights and run **debloat.ps1** script that will uninstall uncommented listed packages in **programs-to-remove.txt**.

```powershell
.\run-debloat.bat
```

## Install your programs

The script uses official microsoft package manager **winget** to install your programs.

[Official winget documentation](https://learn.microsoft.com/en-us/windows/package-manager/winget/)

### Advice

Default winget downloader seems to be slow, you should try switching to **do** :

1. Run `winget settings`
2. Add :

```
"network": {
    "downloader": "do"
}
```

[Microsoft settings](https://learn.microsoft.com/en-us/windows/package-manager/winget/settings#downloader)

3. Save file

### Search for a package id

You can find your program winget id, either from the command line :

```powershell
# Update package sources
winget update
# Format example
winget search _query_
# Actual example
winget search vlc
```

or from this website : [https://winget.run/](https://winget.run/)

### Update package list

You have to modify the list **_$apps_** in **install.ps1** file with your personal list as below :

```powershell
# Format example
@{name = "wingetpackage.id"; source = "if_needed" },
# Actual example
@{name = "7zip.7zip" },
```

### Run script

Install the package list **(without admin right)** :

(you will be ask for admin right elevation when the package needs it)

```powershell
.\install.ps1
```

Install the package list **(with admin right by default)** :

```powershell
.\run-install.bat
```
