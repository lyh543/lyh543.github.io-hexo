@echo off
title Backup lyh543.github.io
set sourceDirectory=C:\Users\lyh\Documents\Git\lyh543.github.io
set destinationDirectory=C:\Users\lyh\OneDrive\Documents\lyh543.github.io.backup

del /f /s /q %destinationDirectory% >nul
rd /s /q %destinationDirectory% >nul
md %destinationDirectory%\

echo .deploy_git\ >xcopy_exlude_files.txt 
echo public >>xcopy_exlude_files.txt
echo node_modules >>xcopy_exlude_files.txt

echo.
xcopy /s /i %sourceDirectory% %destinationDirectory%\ /EXCLUDE:xcopy_exlude_files.txt
echo.

del /q xcopy_exlude_files.txt %destinationDirectory%\xcopy_exlude_files.txt >nul 

pause