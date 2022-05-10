@echo off
regedit.exe /S DisablePowerSaveFeatures.reg

powercfg.exe /hibernate off