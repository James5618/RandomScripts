on error resume next 
 
Set objNet = WScript.CreateObject( "WScript.Network" ) 
 
Const FOR_READING = 2 
CONST ADS_UF_DONT_EXPIRE_PASSWD = &h1014 
 
strFilename = "c:\workstations.txt" 
 
strUser = "testuser" 
 
Set objFSO = CreateObject("Scripting.FileSystemObject") 
 
Set objTextStream = objFSO.OpenTextFile(strFilename, FOR_READING) 
 
 
 
Do Until objTextStream.AtEndOfStream 
    ' Create user 
    strComputer = objTextStream.ReadLine 
    Set colAccounts = GetObject("WinNT://" & strComputer & "") 
    Set objUser = colAccounts.Create("user", strUser) 
    objUser.SetPassword "ENTERPASSWORDHERE" 
    objUser.SetInfo 
    Wscript.Echo "Added user " & strUser & " to " & strComputer 
    ' add user to admin group 
    Set objLocalUser = GetObject("WinNT://" & strComputer & "/" & strUser) 
 
intFlags = objLocalUser.GET("UserFlags") 
intFlags = intFlags OR ADS_UF_DONT_EXPIRE_PASSWD 
objLocalUser.Put "userFlags", intFlags  
objLocalUser.SetInfo 
 
     
    Set objLocalAdmGroup = GetObject("WinNT://" & strComputer & "/Administrators,group") 
    objLocalAdmGroup.Add(objLocalUser.AdsPath) 
    Wscript.Echo "Added user " & strUser & " to " & strComputer & "'s local admin group" 
Loop 