#
# localdeploy.ps1
# script can be used for deployment from local pc to Azure

clear

if ((Get-AzureRmContext).Subscription.Name -ne "Visual Studio Enterprise")
{
    Login-AzureRmAccount

    Set-AzureRmContext -Subscription Visual Studio Enterprise
}

$AadAdmin = "harioverhere@hotmail.com"
$AadPassword = ConvertTo-SecureString "dravid421" -AsPlainText -Force
$ResourceGroupLocation = "northeurope"
$Environment = "dev"

.\deploy-productapi.ps1 -AadAdmin $AadAdmin `
   -AadPassword $AadPassword `
   -ResourceGroupLocation $ResourceGroupLocation `
   -environment $Environment