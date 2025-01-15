Connect-ExchangeOnline
# Query all the mailboxes
$Mailboxes = Get-Mailbox -ResultSize Unlimited
 
# Loop through each mailbox
foreach ($mailbox in $mailboxes) {
    # Apply desired settings
    Set-MailboxMessageConfiguration -Identity $mailbox.Identity -DefaultFontName "Gill Sans" -DefaultFontSize 11
}