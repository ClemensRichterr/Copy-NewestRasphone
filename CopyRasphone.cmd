@echo off

set CUR_HH=%time:~0,2%
if %CUR_HH% lss 10 (set CUR_HH=0%time:~1,1%)
set CUR_NN=%time:~3,2%
set CUR_SS=%time:~6,2%
set ex=.log 

set SUBFILENAME=%computername%-%CUR_HH%%CUR_NN%%CUR_SS%%ex%

rasdial | findstr /ic:"Keine" >nul
if not %errorlevel% EQU 0 (
    rem Found a VPN connection!
    goto :found
) else (
    rem We didn't find any VPN connections!
    goto :notfound
)

:found
echo "%time% - try the replacement next time when no VPN is connected" > \\DC\rasponeLOG$\CopyRasphoneLog-%SUBFILENAME%

:notfound
echo "%time% - Copy the newest rasphone.pbk to C:\ProgramData\Microsoft\Network\Connections\Pbk\" > \\DC\rasponeLOG$\CopyRasphoneLog-%SUBFILENAME%
xcopy /y /f "\\lab.local\SYSVOL\LAB.local\scripts\rasphone.pbk" "C:\ProgramData\Microsoft\Network\Connections\Pbk\"
echo "%time% - Successfully copied the newest rasphone.pbk to C:\ProgramData\Microsoft\Network\Connections\Pbk\" >> \\DC\rasponeLOG$\CopyRasphoneLog-%SUBFILENAME%
echo "%time% - Try to delte old rasphone.pbk under all user profiles (C:\Users\*\AppData\Roaming\Microsoft\Network\Connections\Pbk\rasphone.pbk)" >> \\DC\rasponeLOG$\CopyRasphoneLog-%SUBFILENAME%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item 'C:\Users\*\AppData\Roaming\Microsoft\Network\Connections\Pbk\rasphone.pbk' -Force" >> \\DC\rasponeLOG$\CopyRasphoneLog-%SUBFILENAME%
echo "%time% - Deleted all possible rasphone.pbk under all user profiles (C:\Users\*\AppData\Roaming\Microsoft\Network\Connections\Pbk\rasphone.pbk)" >> \\DC\rasponeLOG$\CopyRasphoneLog-%SUBFILENAME%