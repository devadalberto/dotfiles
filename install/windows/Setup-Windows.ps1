# Check if it is an admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    clear-host
    Write-Host "Please run this script as an administrator.`n" -foregroundcolor red
    "This window will close in 15 seconds"
    Start-Sleep -Seconds 15
    exit
}

#region functions

function Install-FromRepo {
    param (
        [Parameter(Mandatory = $false)]
        [string]$githubRawUrl = "https://raw.githubusercontent.com/devadalberto/dotfiles/main/install/windows/nerdfonts/Install-Nerdfonts.ps1"
    )

    try {
        $scriptInstallerCmd = Invoke-WebRequest $githubRawUrl
    }
    catch {
        $Error[0]
        "This window will close in 15 seconds"
        Start-Sleep -Seconds 15
        exit
    }

    if ($scriptInstallerCmd.StatusCode -eq 200) {
        Invoke-Expression $($scriptInstallerCmd.Content)
        "Script ran successfully.`n"
        "Make sure to close all your powershell sessions."
        "This window will close in 5 seconds"
        Start-Sleep -Seconds 5
        return
    }
    else {
        "Something went south"
        "This window will close in 15 seconds"
        Start-Sleep -Seconds 15
        exit
    }
    
}


function Show-Menu {
    param (
        [string]$Title = "Install-FromRepo"
    )
    Clear-Host
    Write-Host “================ $Title ================”
    
    Write-Host “1:nerdonts - Press '1' to install nerdonts.”
    Write-Host “2:wsl      - Press '2' to install wsl2.”
    Write-Host “3:wsl & nf - Press '3' to install wsl and nerdfonts.”
    Write-Host “Q:         - Press 'Q' to quit.”
}

#endregion functions

#region Script Exec

if ( 5 -eq $PSVersionTable.PSVersion.Major) {
    do {
    
        Show-Menu
        $opt = Read-Host "Make a selection and WAIT... patiently"

        switch ($opt.ToLower()) {
            "1" { 
                $nerdfontsUrl = "https://raw.githubusercontent.com/devadalberto/dotfiles/main/install/windows/nerdfonts/Install-Nerdfonts.ps1"
                Install-FromRepo -githubRawUrl $nerdfontsUrl
            }
            "2" {
            
                $wsl2SetupUrl = "https://raw.githubusercontent.com/devadalberto/dotfiles/main/install/windows/wsl/Install-Wsl2.ps1"
                Install-FromRepo -githubRawUrl $wsl2SetupUrl
            }
            "3" {

                $newWinSetupUrl = "https://raw.githubusercontent.com/devadalberto/dotfiles/main/install/windows/Setup-Windows.ps1"
                Install-FromRepo -githubRawUrl $newWinSetupUrl
            }
            "q" {
                return
            }
        }
        pause
    } until (
        $opt -eq 'q'
    )
}
else {
    "Currently the supported versions of this installer are for powershell 5`n"
    "Launch powershell using the following instructions and try again:`n`n"
    "Press the Windows key (or the search  bar). and type powershell.`n"
    "Right click the icon that says only the word Powershell | run as Administrator.`n`n"
    "try again this script"
    Start-Sleep -Seconds 15
    "This window will close in 15 seconds"
    break
}