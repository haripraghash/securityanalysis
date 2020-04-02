<#
.SYNOPSIS
    Build agent script to install Az Powershell modules. This script should be run as sudo.

    On a linux build agent, this command can be run as:
    sudo /usr/bin/pwsh -NoLogo -NoProfile -NonInteractive -Command . '$(Build.Repository.LocalPath)/build/install-az-modules.ps1'
#>

# Disable status info to clean up build agent stdout
$global:ProgressPreference = 'SilentlyContinue'
$global:VerbosePreference = "SilentlyContinue"

$azureRmModule = Get-InstalledModule AzureRM -ErrorAction SilentlyContinue
if ($azureRmModule) {
  Write-Host 'AzureRM module exists. Removing it'
  Uninstall-Module -Name AzureRM -AllVersions
  Write-Host 'AzureRM module removed'
}

Write-Host 'Installing Az module...'
Install-Module Az -Force -AllowClobber

if (Get-Command Uninstall-AzureRm -ErrorAction SilentlyContinue) {
  Write-Host 'Running Uninstall-AzureRm...'
  Uninstall-AzureRm
}