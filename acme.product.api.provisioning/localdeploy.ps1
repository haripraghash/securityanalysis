#
# localdeploy.ps1
# script can be used for deployment from local pc to Azure
clear
#Clear-AzureRmContext -Scope Process

if ((Get-AzContext).Subscription.Name -ne "Visual Studio Enterprise")
{
    Login-AzureRmAccount

    Set-AzContext -Subscription Visual Studio Enterprise
}

$AadAdmin = "..."
$AadPassword = ConvertTo-SecureString "..." -AsPlainText -Force
$ResourceGroupLocation = "northeurope"
$Environment = "dev"

.\deploy-productapi.ps1 -AadAdmin $AadAdmin `
   -AadPassword $AadPassword `
   -ResourceGroupLocation $ResourceGroupLocation `
   -environment $Environment