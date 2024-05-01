Clear-host
#region Global Variables
$dirName = "wslsetup"
$outputPath = "$env:TEMP + '\' + $dirName"
#winget
# $wingetInstaller = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.txt.msixbundle"
#wsl
$wsl2InstallerName = "wsl_update_x64.msi"
$msivtUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/$wsl2InstallerName"


#endregion Global Variables


#region Functions
function New-InstallDir {
    if (!(Test-Path $outputPath)) {
        New-Item -ItemType Directory -Path $outputPath
    }
    Set-Location $outputPath
    "Directory $outputPath created."
}


function Install-MsiOrMsixBundle {
    param(
        [string]$installerName
    )

    # Set-Location $outputPath
    $msiOutputFile = "$outputPath + '\' + $wsl2InstallerNameName"
    Invoke-WebRequest -Uri $msivtUrl -OutFile $msiOutputFile


    if ( ($wsl2InstallerNameName.Split(".")[-1]).ToLower() -eq "msi" ) {    
        
        Start-Process msiexec.exe -Wait -ArgumentList "/I $msiOutputFile /quiet"
    }
    elseif (($wsl2InstallerNameName.Split(".")[-1]).ToLower() -eq "msixbundle") {
        Add-AppxPackage -Path $msiOutputFile
    }
    else {
        "Something went South. Call Jose"
    }

}


function Install-Winget {
    param (
        $someparam
    )
    ## Test if winget command can run from CMD/PS, if it can't, install prerequisites (if needed) and update to latest version
    try {
        winget --version
        Write-host "Winget command present"
        Stop-Transcript
        Exit 0
    }
    catch {
        Write-Host "Checking prerequisites and updating winget..."
	
        ## Test if Microsoft.UI.Xaml.2.7 is present, if not then install
        try {
            $package = Get-AppxPackage -Name "Microsoft.UI.Xaml.2.7"
            if ($package) {
                Write-Host "Microsoft.UI.Xaml.2.7 is installed."
            }
            else {
                Write-Host "Installing Microsoft.UI.Xaml.2.7..."
                Invoke-WebRequest `
                    -URI https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 `
                    -OutFile xaml.zip -UseBasicParsing
                New-Item -ItemType Directory -Path xaml
                Expand-Archive -Path xaml.zip -DestinationPath xaml
                Add-AppxPackage -Path "xaml\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"
                Remove-Item xaml.zip
                Remove-Item xaml -Recurse
            }
        }
        catch {
            Write-Host "An error occurred: $($_.Exception.Message)"
        }

        ## Update Microsoft.VCLibs.140.00.UWPDesktop
        Write-Host "Updating Microsoft.VCLibs.140.00.UWPDesktop..."
        Invoke-WebRequest `
            -URI https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx `
            -OutFile UWPDesktop.appx -UseBasicParsing
        Add-AppxPackage UWPDesktop.appx
        Remove-Item UWPDesktop.appx

        ## Install latest version of Winget
        $API_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
        $DOWNLOAD_URL = $(Invoke-RestMethod $API_URL).assets.browser_download_url |
        Where-Object { $_.EndsWith(".msixbundle") }
        Invoke-WebRequest -URI $DOWNLOAD_URL -OutFile winget.msixbundle -UseBasicParsing
        Add-AppxPackage winget.msixbundle
        Remove-Item winget.msixbundle
    }
}
#endregion Functions

#Script Execution
# Check if running as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    clear-host
    Write-Host "Please run this script as an administrator." -foregroundcolor red
}
else {
    # Check if winget is installed and up to date
    Install-Winget

    # Check if WSL is already enabled
    $wslStatus = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

    if ($wslStatus.State -eq "Enabled") {
        Write-Host "WSL is already enabled." -foregroundcolor Green

        Write-Host "Now we check the WSL Version" -foregroundcolor Green
        $wslVersion = $(Invoke-Expression $("wsl --version"))[0]
        $wsls = $wslVersion[0].Replace(" ", "").Replace()
        $wsls = $wsls -replace '\s', ''

        if ($($wsls.Replace(" ", "").Split(":")[1]).Contains('2')) {
            [Int32]$wslInstalledVersion = 2
        }
        else {
            [Int32]$wslInstalledVersion = 1
        }
        
        
        if ($wslInstalledVersion -ne 2 ) {
            #we create the temp dir to install and change dir into it
            New-InstallDir

            #now we download and install the WSL
            Install-MsiOrMsixBundle -installerName $wsl2InstallerName
        }
    }
    else {
        # Enable WSL
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

        # Check if reboot is required
        $rebootRequired = $?
        if ($rebootRequired) {
            Write-Host "WSL has been enabled. Please reboot your computer to apply the changes." -foregroundcolor Yellow
            Restart-Computer
        }
        else {
            Write-Host "WSL has been enabled successfully." -foregroundcolor Green
        }
    }

    # Turn on WSL
    Invoke-Expression $("wsl --set-default-version 2")
}