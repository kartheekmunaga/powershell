Import-Module AzureRM

#To select particular sub1
$subcriptions = get-content 'subcriptions.txt'

Foreach($subcription in $subcriptions)
{
   select-azurermsubscription –SubscriptionId $subcription

   $nsgs = Get-AzureRmNetworkSecurityGroup
   $exportPath = 'NSG Backups'

   #backup nsgs to csv
       Foreach ($nsg in $nsgs) 
       {
         New-Item -ItemType file -Path "$exportPath\$($nsg.Name).csv" -Force
         $nsgRules = $nsg.SecurityRules
         foreach ($nsgRule in $nsgRules) 
         {
         $nsgRule | Select-Object Name,Description,Priority,@{Name=’SourceAddressPrefix’;Expression={[string]::join(“,”, ($_.SourceAddressPrefix))}},@{Name=’SourcePortRange’;Expression={[string]::join(“,”, ($_.SourcePortRange))}},@{Name=’DestinationAddressPrefix’;Expression={[string]::join(“,”, ($_.DestinationAddressPrefix))}},@{Name=’DestinationPortRange’;Expression={[string]::join(“,”, ($_.DestinationPortRange))}},Protocol,Access,Direction `
         | Export-Csv "$exportPath\$($nsg.Name).csv" -NoTypeInformation -Encoding ASCII -Append
         }
       }
}
