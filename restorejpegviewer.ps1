Get-AppXPackage *WindowsStore* -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

New-PSDrive -Name HKEY_CLASSES_ROOT -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
New-Item -Path $("HKEY_CLASSES_ROOT:\jpegfile\shell\open") -Force | Out-Null
New-Item -Path $("HKEY_CLASSES_ROOT:\jpegfile\shell\open\command") -Force | Out-Null
Set-ItemProperty -Path $("HKEY_CLASSES_ROOT:\jpegfile\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3043"
Set-ItemProperty -Path $("HKEY_CLASSES_ROOT:\jpegfile\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"