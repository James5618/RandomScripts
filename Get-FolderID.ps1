#Specify target mailbox and folder to find folderid of
$TargetMailbox = "duncan@calicointeriors.co.uk"
$TargetFolderPath = "/Sent Items"

Connect-ExchangeOnline

#FolderID format conversion code taken from https://blogs.technet.microsoft.com/latam/2017/10/06/o365-export-pst/ 
$Folders = Get-MailboxFolderStatistics -Identity $TargetMailbox
$FolderID = ($Folders | where { $_.FolderPath -eq $TargetFolderPath }).FolderID
$Encoding= [System.Text.Encoding]::GetEncoding("us-ascii");
$FolderIdBytes = [Convert]::FromBase64String($FolderID);
$Nibbler= $encoding.GetBytes("0123456789ABCDEF");
$IndexIdBytes = New-Object byte[] 48;
$IndexIdIdx=0;
$FolderIdBytes | select -skip 23 -First 24 | %{$IndexIdBytes[$IndexIdIdx++]=$Nibbler[$_ -shr 4]; $IndexIdBytes[$IndexIdIdx++]=$Nibbler[$_ -band 0xF]}
$folderQuery = "folderid:$($encoding.GetString($indexIdBytes))";

write-host $folderQuery 