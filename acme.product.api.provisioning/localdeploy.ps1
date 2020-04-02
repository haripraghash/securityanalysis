#
# localdeploy.ps1
# script can be used for deployment from local pc to Azure
clear

if ((Get-AzContext).Subscription.Name -ne "Visual Studio Enterprise")
{
    Login-AzureRmAccount

    Set-AzContext -Subscription Visual Studio Enterprise
}

$AadAdmin = "harioverhere@hotmail.com"
$AadPassword = ConvertTo-SecureString "dravid421" -AsPlainText -Force
$ResourceGroupLocation = "eastus"
$Environment = "dev"

.\deploy-productapi.ps1 -AadAdmin $AadAdmin `
   -AadPassword $AadPassword `
   -ResourceGroupLocation $ResourceGroupLocation `
   -environment $Environment