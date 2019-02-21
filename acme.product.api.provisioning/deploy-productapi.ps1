Param (
	# Azure AD
	[Parameter(Mandatory=$true)]
    [string] $AadAdmin,

	[Parameter(Mandatory=$true)]
    [secureString] $AadPassword,
	
	# Resource group
	[Parameter(Mandatory=$true)]
	[string] $ResourceGroupLocation,

    [string] $ResourceGroupName = 'acme-product-eun-dev-resgrp',

    [string] $TemplateFile = 'azuredeploy.json',

	# General
	[Parameter(Mandatory=$true)]
	[string] $Environment = 'dev',

	# App service plan
	[string] $AppServicePlanSKUTier = 'Standard',

	[string] $AppServicePlanSKUName = 'S1',

	# Homepage db
	[string] $SqlDbEdition = 'Standard',

	[string] $SqlDbTier = 'S1'
)

$ErrorActionPreference = 'Stop'

Set-Location $PSScriptRoot

$AadTenantId = (Get-AzureRmContext).Tenant.Id
$ArtifactsStorageAccountName = $ResourceNamePrefix + $Environment + 'artifacts'
$ArtifactsStorageContainerName = 'artifacts'
$ArtifactsStagingDirectory = '.\templates'

function Generate-Password ($length = 20, $nonAlphaChars = 5)
{
	Add-Type -AssemblyName System.Web
	
	[char[]] $illegalChars = @(':', '/', '\', '@', '''', '"', ';', '.', '+', '#')

	do {
		$hasIllegalChars = $false
		$password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)

		$illegalChars | ForEach-Object {
			if ($password -like "*$_*") {
				$hasIllegalChars = $true
			}
		}
	} while ($hasIllegalChars)

	ConvertTo-SecureString $password -AsPlainText -Force
}

function CreateResourceGroup() {
	$parameters = New-Object -TypeName Hashtable

	# general
	$parameters['environment'] = $Environment

	# homepage sql db	
	$parameters['sqlDbEdition'] = $SqlDbEdition
	$parameters['sqlDbTier'] = $SqlDbTier

	$parameters['sqlServerAdminLogin'] = $SqlServerAdminLogin
	$parameters['sqlServerAdminLoginPassword'] = $SqlServerAdminLoginPassword

	
	# App service plan
	$parameters['appServicePlanSKUTier'] = $AppServicePlanSKUTier
	$parameters['appServicePlanSKUName'] = $AppServicePlanSKUName

	.\Deploy-AzureResourcegroup.ps1 `
	    -resourcegrouplocation $ResourceGroupLocation `
		-resourcegroupname $ResourceGroupName `
		-uploadartifacts `
		-storageaccountname $ArtifactsStorageAccountName `
		-storagecontainername $ArtifactsStorageContainerName `
		-artifactstagingdirectory $ArtifactsStagingDirectory `
		-templatefile $TemplateFile `
		-templateparameters $parameters
}

function Main() {
	$deployment = CreateResourceGroup
	$deployment

	if ($deployment.ProvisioningState -eq 'Failed'){
		throw "Deployment was unsuccessful"
	}
	
	$webApiName = $deployment.outputs.webApiName.Value
	$webUiName = $deployment.outputs.webUiName.Value
	$keyVaultName = $deployment.outputs.keyVaultName.Value
	$appInsightsName = $deployment.outputs.appInsightsName.Value
	$appInsightsInstrumentationKey = $deployment.outputs.appInsightsInstrumentationKey.Value
	$productApiWebAppUrl = $deployment.outputs.webApiUrl.Value
	$storageAccountName = $deployment.outputs.storageAccountName.Value

	# SQL server
	$SqlServerName = $deployment.outputs.sqlServerName.Value
	$SqlServerDbName = $deployment.outputs.sqlDbName.Value

	$BSTR1 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sqlServerAdminLoginPassword)
	$sqlServerAdminLoginPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR1)

	
	# set application settings for web api
	$apiAppSettings = @{
		'KeyVault:Name' = $keyVaultName;
		'AzureAd:Tenant' = $AadTenantId;
		'AzureAd:Audience' = $adAppUri;
		'AzureAd:ClientId' = $adAppClientId;
		'AzureAd:AadInstance' = 'https://login.microsoftonline.com/{0}';
		'ApplicationInsights:InstrumentationKey' = $appInsightsInstrumentationKey;
		'UIAppUrl' = "https://$webUiName.azurewebsites.net";
	}

	if ($IsDevelopment)
	{
		$apiAppSettings = $apiAppSettings + @{'ASPNETCORE_ENVIRONMENT' = 'Development'}
	}

	
	Write-Host "##vso[task.setvariable variable=WebApiAppServiceName;]$webApiName"
	Write-Host "##vso[task.setvariable variable=ResourceGroupName;]$ResourceGroupName"
	Write-Host "##vso[task.setvariable variable=HomePageApiWebAppUrl;]$productApiWebAppUrl"

	Write-Host "##vso[task.setvariable variable=SqlServerName;]$SqlServerName"
	Write-Host "##vso[task.setvariable variable=SqlServerDbName;]$SqlServerDbName"
	Write-Host "##vso[task.setvariable variable=SqlServerAppAdminLogin;]$sqlServerAdminLogin"
	Write-Host "##vso[task.setvariable variable=SqlServerAppAdminLoginPassword;issecret=true;]$sqlServerAdminLoginPasswordPlain"
}

$SqlServerAdminLogin = "productadmin"
$SqlServerAdminLoginPassword = Generate-Password

Main