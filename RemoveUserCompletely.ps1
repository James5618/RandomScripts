function Remove-LocalUserCompletely {

    Param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $Name
    )

    process {
        $user = Get-LocalUser -Name $Name -ErrorAction Stop

        # Remove the user from the account database
        Remove-LocalUser -SID $user.SID

        # Remove the profile of the user (both, profile directory and profile in the registry)
        Get-CimInstance -Class Win32_UserProfile | ? SID -eq $user.SID | Remove-CimInstance
    }
}

# Example usage:
Remove-LocalUserCompletely -Name 'HarryClarke'