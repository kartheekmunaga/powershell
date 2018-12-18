#To select particular sub
$subcriptions = get-content 'subcriptions.txt'

Foreach($subcription in $subcriptions)
{
   select-azurermsubscription –SubscriptionId $subcription
   $WebApps = Get-AzureRmWebApp
   Foreach($WebApp in $WebApps)
   {
     $WebApp | select-object -property Name,state,HttpsOnly | Export-Csv -Path webapps.csv -NoTypeInformation -Append
   }
}
