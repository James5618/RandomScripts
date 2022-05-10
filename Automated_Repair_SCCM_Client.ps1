
#ERROR REPORTING ALL
Set-StrictMode -Version latest

#----------------------------------------------------------
#STATIC VARIABLES
#----------------------------------------------------------


#----------------------------------------------------------
#FUNCTION RepairSCCM
#----------------------------------------------------------
Function Repair_SCCM
{
  Write-Host "Please select input the the Identifier for the Surface Pro."
  ##$arrComputer = Get-Content ($SCRIPT_PARENT + "\input.txt")
  $arrComputer = Read-Host -Prompt 'Input Computer Number'
  Foreach ($strComputer In $arrComputer)
  {
	#Put an asterisk (*) in front of the lines that need to be skipped in the input file.
    If ($strComputer.substring(0,1) -ne "*")
	{
	  Write-Host "Starting ..."
	  Try
	  {
		$GetProcess = Get-Process -Name ccmrepair* -ComputerName $strComputer
		If ($GetProcess)
		{
		  Write-Host "[WARNING] SCCM Repair is already running. Script will end."
		  Exit 1
		}
		Else
		{
		  Write-Host "Connecting to the C$ on $strComputer."
		  $SMSCli = [wmiclass] "\\$strComputer\c$\Windows\ccmsetup\ccmsetup.exe"
		
		  Write-Host "[INFO] Trigger the SCCM Repair on $strComputer."
		  # The actual repair is put in a variable, to trap unwanted output.
		  $repair = $SMSCli.RepairClient()
		  Write-Host "[INFO] Successfully connected to the WMI Namespace and triggered the SCCM Repair on $strComputer."
		  ########## START - PROCESS / PROGRESS CHECK AND RUN
		  # Comment the lines below if it is unwanted to wait for each repair to finish and trigger multiple repairs quickly.
		  Write-Host "[INFO] Wait (a maximum of 7 minutes) for the repair to actually finish."
		  For ($i = 0; $i -le 470; $i++)
		  {
			$checkProcess = Get-Process -Name ccmrepair* -ComputerName $strComputer
			Start-Sleep 1
			Write-Progress -Activity "Repairing client $strComputer ..." -Status "Repair running for $i seconds ..."
			
		    If ($checkProcess -eq $Null)
			{
			  Write-Host "[INFO] SCCM Client repair ran for $i seconds."
			  Write-Host "[INFO] SCCM Client repair process ran successfully on $strComputer."
			  Write-Host "[INFO] Check \\$strComputer\c$\Windows\SysWOW64\CCM\Logs\repair-msi%.log to make sure it was successful."
			}
			ElseIf ($i -eq 470)
			{
			  Write-Host "[ERROR] Repair ran for more than 7 minutes. Script will end and process will be stopped."
			  Invoke-Command -Computer $strComputer { Get-Process -Name ccmrepair* | Stop-Process -Force }
			  Exit 1
			}
		  }
		  ########## END - PROCESS / PROGRESS CHECK AND RUN

		}
	  }
	  Catch
	  {
		Write-Host "[WARNING] Either the WMI Namespace connect or the SCCM Repair trigger returned an error."
		Write-Host "[WARNING] This is most likely caused, because there is already a repair trigger running."
		Write-Host "[WARNING] Wait a couple of minutes and try again."
		# If the script keeps throwing errors, the WMI Namespace on $strComputer might be corrupt.
	  }
    }
  }
}
# RUN SCRIPT 
Repair_SCCM 
#Finished
