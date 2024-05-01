# dotfiles

Another attempt to automate the basic setup and configuration of a computer.

The idea is to do it without using tools like ansible.


## Who can use these?
Anyone with a windows OS 10 or 11


## tl;dr => I want to run this right now

1. Run powershell as administrator (do NOT use 'Powershell 7')

2. Run below scripts (one at a time)

```powershell
# Checking permissions and setting execution policy and repository for Powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -Confirm:$false -Verbose
```
```powershell
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
```
```powershell
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force
```
```powershell
$url = "https://raw.githubusercontent.com/devadalberto/dotfiles/main/install/windows/Setup-Windows.ps1"

try {
    $cmd = Invoke-WebRequest $url
    return
}
catch {
    $Error[0]
    "This window will close in 15 seconds"
    Start-Sleep -Seconds 15
    exit
}


if ($cmd.StatusCode -ne 200) {
    "Something went south"
    "This window will close in 15 seconds"
    Start-Sleep -Seconds 15
    exit
} elseif ($cmd.StatusCode -eq 200) {
    Invoke-Expression $($cmd.Content)
    "Script ran successfully.`n"
    "Make sure to close all your powershell sessions."
    "This window will close in 5 seconds"
    Start-Sleep -Seconds 5
    break
}
```


## ToDo
- [ ] Create install files for MacOS
- [ ] Create install files for Linux? (compatible with WSL?)
- [ ] Finish the Windows install files
- [ ] Get the scripts hosted in a webServer


## Disclaimer

I am just putting together stuff already configured or created by someone else.
If I miss anybody on the Special Thanks, please let me know.

## Special thanks

For all those that shared already their knowledge, their time and their dotfiles (and other kind of files of course) to make this happen.

- [mischavandenburg](https://github.com/mischavandenburg/dotfiles) (dotfiles / workflow)
- [ryanlmcintyre](https://github.com/ryanoasis/nerd-fonts) (nerdfonts)
- [vatsan-madhavan](https://github.com/vatsan-madhavan/NerdFontInstaller) (nerdfonts installer for win)
- [benmatselby](https://github.com/benmatselby/dotfiles/blob/main/install.sh) (dotfiles)
- [getnf](https://github.com/getnf/getnf) (nerdfonts made easy for *nix systems)