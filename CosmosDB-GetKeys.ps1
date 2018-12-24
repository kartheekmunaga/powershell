#To select particular sub
$rgs = get-content 'C:\Users\kmunaga001\Documents\Projects\Astro\powershell\resourcegroups.txt'

Foreach($rg in $rgs)
{
  $cosmosDBS = Get-AzureRmResource -ResourceType "Microsoft.DocumentDb/databaseAccounts" -ResourceGroupName $rg -ErrorAction SilentlyContinue
  Foreach($cosmosDB in $cosmosDBS)
  {
  Invoke-AzureRmResourceAction -Action listkeys `
    -ResourceType "Microsoft.DocumentDb/databaseAccounts" `
    -ResourceGroupName $rg `
    -Name $cosmosDB.Name -Force | Select-Object -Property @{Name="Name"; Expression={$cosmosDB.Name}},primaryReadonlyMasterKey,secondaryReadonlyMasterKey | FT
  }

}
