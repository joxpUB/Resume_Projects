# Intune Remediation Script for Intune_Detection_IdlePowerSaving.ps1
# Sets the Idle Power Saving property to Disabled, due to an issue with Cisco AnyConnect VPN dropping through docking monitors. This is especially prevalent/necessary with everyone who uses Cisco Finesse. Specifically created for ticket# 00615097
# Created: jfrocco 3/9/2023
# Turned into an Intune Remediation Script 2/8/2025, pretend this is a signed PS script. Do not run with logged-on credentials, Admin is necessary.


try{

    $IdlePowerSaving = (Get-NetAdapterAdvancedProperty -RegistryKeyword EnableExtraPowerSaving -ErrorAction Stop).RegistryValue

    # If the EnableExtraPowerSaving (AKA Idle Power Saving) keyword exists, disable it but do not restart the network adapter. Else, do nothing!
    if($IdlePowerSaving -ne "0"){
        Set-NetAdapterAdvancedProperty -RegistryKeyword "EnableExtraPowerSaving" -RegistryValue "0" -NoRestart # This change will not take effect until the network adapter restarts, so as not to distrupt startup processes.

        Write-Host "Idle Power Saving has been disabled."
        exit 0
    }
    # It shouldn't be able to get to this state
    else{
        Write-Host "Idle Power Saving is already disabled."
        exit 0
    }
}

catch{
    # EnableExtraPowerSaving likely does not exist if it gets here! Or something went wrong.
    Write-Error "($_.Exception.Message)"
    exit 1
}
