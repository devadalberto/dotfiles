# dotfiles

Another attempt to automate the basic setup and configuration of a computer.

The idea is to do it without using tools like ansible.


## Who can use these?
Anyone with a windows OS 10 or 11


## tl;dr => I want to run this right now

1. Press **"Windows-key + R"** on your keyboard.

2. This will open the Run dialog box.

3. Type 'PowerShell' and press Enter.

4. Run below script.

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
$winSetupUrl = "https://raw.githubusercontent.com/devadalberto/dotfiles/main/install/windows/Setup-Windows.ps1"

try {
    $scriptInstallerCmd = Invoke-WebRequest $winSetupUrl
}
catch {
    $Error[0]
    "This window will close in 15 seconds"
    Start-Sleep -Seconds 15
    exit
}
if ($scriptInstallerCmd.StatusCode -eq 200) {
    Invoke-Expression $($scriptInstallerCmd.Content)
}
else {
    "Something went south"
    "This window will close in 15 seconds"
    Start-Sleep -Seconds 15
    exit
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