@rem detect admin righs
@whoami /groups | findstr /b BUILTIN\Administrators | findstr /c:"Enabled group" && goto isadministrator
@if errorlevel 0 echo. &&echo This script must be run as an administrator. && goto eof
:isadministrator
@echo Updating gpo
@gpudate /force
@echo starting SCCM installer
cd C:\Windows\Ccmsetup
ccmsetup.exe /mp:https://CMGWARWICKSHIREGOVUK.CLOUDAPP.NET/CCM_Proxy_MutualAuth/72057594037927940 CCMHOSTNAME=CMGWARWICKSHIREGOVUK.CLOUDAPP.NET/ CCM_Proxy_MutualAuth/72057594037927940 SMSSiteCode=WCC /UsePKICert
@echo. &&echo This script has ended.  &&echo The installation of SCCM is silent, please allow time for it to finish.
:eof
@pause
