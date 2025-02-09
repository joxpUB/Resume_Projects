# Intune Detection Script for Intune_Remediation_IdlePowerSaving.ps1
# Detects the Idle Power Saving property on all network adapters, if it exists. Created due to an issue with Cisco AnyConnect VPN dropping through docking monitors. This is especially prevalent/necessary with everyone who uses Cisco Finesse. Specifically created for ticket# 00615097
# Created: jfrocco 2/8/2025, pretend this is a signed PS script.


try{

    $IdlePowerSaving = (Get-NetAdapterAdvancedProperty -RegistryKeyword EnableExtraPowerSaving -ErrorAction Stop).RegistryValue

    # If the EnableExtraPowerSaving (AKA Idle Power Saving) keyword exists and is not disabled, remediate. Else there is no need to remediate.
    if($IdlePowerSaving -ne "0"){
        Write-Host "Idle Power Saving is enabled, this will be remediated."
        exit 1
    }
    else{
        Write-Host "Idle Power Saving is NOT enabled, no remediation necessary."
        exit 0
    }
}

catch{
    Write-Host "EnableExtraPowerSaving AKA Idle Power Saving likely does not exist on this device, no remediation necessary."
    exit 0
}
