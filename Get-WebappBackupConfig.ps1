Login-AzureRmAccount

$CsvInfo = @()

$subcriptions = get-content 'C:\Users\kmunaga001\Documents\Projects\Astro\NSG Backups\subcriptions.txt'

Foreach($subcription in $subcriptions)
{
   select-azurermsubscription –SubscriptionId $subcription

   $ResourceGroups = Get-AzureRmResourceGroup

   Foreach($ResourceGroup in $ResourceGroups)
     {

     $webapps = Get-AzureRmWebApp -ResourceGroupName $ResourceGroup.ResourceGroupName

     Foreach($webapp in $webapps)
       {
        
        $backupinfo = Get-AzureRmWebAppbackupConfiguration -Name $webapp.Name -ResourceGroupName $ResourceGroup.ResourceGroupName -ErrorAction SilentlyContinue

        $obj = New-Object PSObject
        $obj | Add-Member -MemberType NoteProperty -Name Name -Value $webapp.Name
        $obj | Add-Member -MemberType NoteProperty -Name Frequency -Value $backupinfo.FrequencyUnit
        $obj | Add-Member -MemberType NoteProperty -Name RetentionPeriodInDays -Value $backupinfo.RetentionPeriodInDays
        $obj | Add-Member -MemberType NoteProperty -Name Enabled -Value $backupinfo.Enabled
        $obj | Add-Member -MemberType NoteProperty -Name StartTime -Value $backupinfo.StartTime
        $CsvInfo += $obj

       }

       $CsvInfo | Export-Csv -Path C:\Users\kmunaga001\Documents\Projects\Astro\powershell\webappbackup.csv -NoTypeInformation
    
   }
}
