Import-Csv "C:\temp\AddAlias\alias.csv" | ForEach-Object {
    try{
        Set-ADUser -Identity $_.samaccountname -add @{Proxyaddresses=$_.Proxyaddresses -split ";"} -ErrorAction Stop
        Write-Host $_.samaccountname complete! -ForegroundColor Green
    }catch{
        Write-Host 'Failed : ' -NoNewline
        Write-Host $_.samaccountname -ForegroundColor Red
    }
}