# Update the source IP of an existing "allow all traffic" Security Group inbound rule based on a Security Group ID and a rule description.
# Suitable for cases where you want to automatically update the security group rules to allow access from your dynamic source IP (and to remove the previous rule).
# PreReqs: Place the "SG-Script-Config.json" file in the script running directory and update its parameters.

$configFilePath = "SG-Script-Config.json"
$conf = Get-Content $configFilePath | Out-String | ConvertFrom-Json

# putting it all in try-catch statement, to reduce the risk of messing up security group rules in case of an unexpected error
try {
    $currentIp = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
    Write-Host "Current IP address:" $currentIp

    # find old security group rules
    $secGroup = (Get-EC2SecurityGroup -Region $conf.region -AccessKey $conf.access_k -SecretKey $conf.sec_k) | ? {$_.groupId -eq $conf.secGroupID}
    if ($secGroup -eq $null)
    {
        Write-Host "Did not found Security Group with ID:" $conf.secGroupID -ForegroundColor red
    }
    else {
        Write-Host "Found Security Group to update:" $secGroup.GroupName

        $IpPermissionAllowAll = ($secGroup.IpPermissions | ? {$_.IpProtocol -eq "-1"})
        if ($IpPermissionAllowAll -eq $null)
        {
            Write-Host "Did not found rules allowing inbound for all protocols." -ForegroundColor red
        }
        else {
            Write-Host "Found rules allowing inbound for all protocols from" $IpPermissionAllowAll.Ipv4Ranges.Count "sources"

            $ipv4RangeToRemove = $IpPermissionAllowAll.Ipv4Ranges | ? {$_.Description -eq $conf.ruleDescriptionToDelete}
            if ($ipv4RangeToRemove -eq $null)
            {
                Write-Host "Did not found rules allowing inbound for all protocols with description:" $conf.ruleDescriptionToDelete -ForegroundColor red
            }
            else {              
                Write-Host "Found rule with description:" $conf.ruleDescriptionToDelete
                $ipPermissionToRevoke = $IpPermissionAllowAll
                $ipPermissionToRevoke.Ipv4Ranges = $ipv4RangeToRemove
                Revoke-EC2SecurityGroupIngress -GroupId $conf.secGroupID -IpPermissions $ipPermissionToRevoke -Region $conf.region -AccessKey $conf.access_k -SecretKey $conf.sec_k                
                Write-Host "Revoked old IP:" $ipv4RangeToRemove.CidrIp -ForegroundColor Green

                # authorize access
                $myIpRange = New-Object -TypeName Amazon.EC2.Model.IpRange
                $myIpRange.CidrIp = $currentIp + "/32"
                $myIpRange.Description = "Haim home IP"
                $newIpPermissions = New-Object Amazon.EC2.Model.IpPermission
                $newIpPermissions.IpProtocol = "-1"
                $newIpPermissions.Ipv4Ranges = $myIpRange
                Grant-EC2SecurityGroupIngress -GroupId $conf.secGroupID -IpPermission $newIpPermissions -Region $conf.region -AccessKey $conf.access_k -SecretKey $conf.sec_k
                Write-Host "Authorized new IP:" $currentIp"/32" -ForegroundColor Green
            }
        }
    }
}
catch {
    Write-Host "Encountered errors during running." -ForegroundColor red
}
