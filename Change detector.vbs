With CreateObject("Scripting.FileSystemObject")
    For Each File In .GetFolder("WIMFileFOLDER LOCATION").Files
        If DateDiff("n", File.DateLastModified, Now) < 10 Then
   ' File has been modified in past amount of time (Change the 10 to what ever number desired, this is measured in minutes.)
  
   Set objShell = CreateObject(“Wscript.shell”)
   objShell.run(“powershell -noexit -file POWERSHELL SCRIPT DIR”)
        End If
    Next
End With