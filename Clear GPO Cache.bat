@echo off
DEL S F Q “%ALLUSERSPROFILE%Application DataMicrosoftGroup PolicyHistory.”
REG DELETE HKLMSOFTWAREMicrosoftWindowsCurrentVersionPolicies f
REG DELETE HKCUSOFTWAREMicrosoftWindowsCurrentVersionPolicies f
DEL F Q CWINDOWSsecurityDatabasesecedit.sdb
Klist purge
gpupdate force
exit