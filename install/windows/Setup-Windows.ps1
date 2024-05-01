# Check if it is an admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    clear-host
    Write-Host "Please run this script as an administrator." -foregroundcolor red
}
else {
    # check powershell version

}

$wslSetupUrl = "https://raw.githubusercontent.com/devadalberto/dotfiles/main/install/windows/wsl/Install-Wsl2.ps1"
$nfSetupUrl = "https://raw.githubusercontent.com/devadalberto/dotfiles/main/install/windows/nerdfonts/Install-Nerdfonts.ps1"

$dirName = "wslsetup"
$outputPath = $env:TEMP + '\' + $dirName
New-Item -ItemType Directory -Path $outputPath
Set-Location $outputPath

$psver = 0

#region functions
function Install-FromRepo {
    param (
        [Parameter(Mandatory)]
        [string]$repoUrl
    )
    try {
        $scriptInstallerCmd = Invoke-WebRequest $repoUrl
    }
    catch {
        $Error[0]
    }
    if ($scriptInstallerCmd.StatusCode -eq 200) {
        Invoke-Expression $($scriptInstallerCmd.Content)
    }
    else {
        $repoInstaller = "https://github.com/devadalberto/dotfiles"
        "Woooot... navigate to:`n$repoInstaller`n and check everything is ok"
    }
}
#endregion functions

"Starting ..."
"Installing Windows Subsystem for Linux (wsl2)"
Start-Sleep -Seconds 2

if ( 5 -eq $PSVersionTable.PSVersion.Major) {
    "Installing for Powershell $psver"
}
else {
    "Currently the supported versions of this installer are for powershell 5`n"
    "Launch powershell using the following instructions and try again:`n`n"
    "Press the Windows key + R on your keyboard. This will open the Run dialog box.`n"
    "Type 'PowerShell' and press Enter.`n`n"
    Start-Sleep -Seconds 15
    "This window will close in 15 seconds"
    break
}

Install-FromRepo -repoUrl $wslSetupUrl

"Installing Nerdfont UbuntuMono"
Start-Sleep -Seconds 2

Install-FromRepo -repoUrl $nfSetupUrl

# some cleanup
Set-Location $env:TEMP
Remove-Item -Path $outputPath -Recurse -Confirm $false -Force