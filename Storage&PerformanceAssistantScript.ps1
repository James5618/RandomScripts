############
## Setup ##
############
$Warningcolour = (Get-Host).PrivateData
$Warningcolour.WarningBackgroundColour = "Red"
$Warningcolour.WarningForegroundColour = "White"
$DebugColour = (Get-Host).PrivateData
$DebugColour.DebugBackgroundColour = "White"
$DebugColour.DebugForegroundColour = "Blue"
$console.backgroundcolour = "Black"

Write-Host "Setting up ..." -ForegroundColor Green

############################################
## Self elevate to Administrator Privlages #
#############################################
Write-Host "Checking for administrative rights..." -ForegroundColor Green
## Get the ID and security principal of the current user account.
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
$myWindowsPrinciples = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);
## get the security principal for the administrator role.
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

##check if script is running as admin

if ($myWindowsPrinciples.IsInRole($adminRole))
{

    Write-Host "Script is Currently running as administrator" -ForegroundColor Green
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)";
}
else
{
    Write-Host "We are not running as Administrator. Attempting to Relaunch as Administrator..." -ForegroundColor Red
        ##Not running as admin, relaunch script as admin
    $NewProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
        ## Specifying Current Script path and name as Parameter, support for spaces included :)
    $NewProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "'"
        ## Process should be elevated.
}