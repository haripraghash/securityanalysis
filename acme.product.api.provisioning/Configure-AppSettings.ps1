#Requires -Version 3.0

Param(
    [string] [Parameter(Mandatory = $true)] $ResourceGroupName,
    [string] [Parameter(Mandatory = $true)] $WebAppName,
	[hashtable] [Parameter(Mandatory = $true)] $AppSettings
)

$webApp = Get-AzureRmWebApp -ResourceGroupName $ResourceGroupName `
    -Name $WebAppName

if (!$webApp) {
    throw "Web App $WebAppName not found"
}

$settings = $webApp.SiteConfig.AppSettings

Write-Host "Current application settings:"
$settings


$hash = @{}
ForEach ($kvp in $settings) {
    $hash[$kvp.Name] = $kvp.Value
}

$AppSettings.GetEnumerator() | ForEach-Object {
        $hash[$_.key] = $_.value
}

# check if client secret is provided
if($ClientSecret){
	$hash['ClientSecret'] = $ClientSecret
}

Write-Host "New application settings"
$hash

Set-AzureRmWebApp -ResourceGroupName $ResourceGroupName `
    -Name $WebAppName `
    -AppSettings $hash