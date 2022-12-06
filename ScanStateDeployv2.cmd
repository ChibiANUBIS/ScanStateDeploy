@ECHO OFF
TITLE ScanState Deploy - Chibi ANUBIS
COLOR F0
pushd "%~dp0"

:: Check if you are WADK ScanState files
if exist "%programfiles%\Windows Kits\10\Assessment and Deployment Kit\" SET "ADK=%programfiles%\Windows Kits\10\Assessment and Deployment Kit\" & goto RunScript
if exist "%programfiles(x86)%\Windows Kits\10\Assessment and Deployment Kit\" SET "ADK=%programfiles(x86)%\Windows Kits\10\Assessment and Deployment Kit\" & goto RunScript
goto ADKError

:RunScript
if exist "%ADK%\User State Migration Tool\amd64" SET "USMTx64=%ADK%\User State Migration Tool\amd64"
if exist "%ADK%\User State Migration Tool\x86" SET "USMTx86=%ADK%\User State Migration Tool\x86"
if exist "%ADK%\User State Migration Tool\arm64" SET "USMTARM64=%ADK%\User State Migration Tool\arm64"
if exist "%ADK%\Windows Setup\amd64\Sources" SET "Sourcesx64=%ADK%\Windows Setup\amd64\Sources"
if exist "%ADK%\Windows Setup\x86\Sources" SET "Sourcesx86=%ADK%\Windows Setup\x86\Sources"
if exist "%ADK%\Windows Setup\arm64\Sources" SET "SourcesARM64=%ADK%\Windows Setup\arm64\Sources"


if not defined USMTx64 goto ScanStateError
if not defined USMTx86 goto ScanStateError
if not defined USMTARM64 goto ScanStateError
if not defined Sourcesx64 goto ADKError
if not defined Sourcesx86 goto ADKError
if not defined SourcesARM64 goto ADKError
goto RunCopy

:: Copying the files to
:RunCopy
:: Build version
ECHO ADK INSTALLED
ECHO Check build...
SET "fn=%ADK%\User State Migration Tool\%processor_architecture%\scanstate.exe"
FOR /F "tokens=2 delims==" %%I IN (
  'wmic datafile where "name='%fn:\=\\%'" get version /format:list'
) DO SET "build=%%I"
SET Location=ScanState %build%
if not exist "%Location%\x86\" mkdir "%Location%\x86\"
if not exist "%Location%\amd64\" mkdir "%Location%\amd64\"
if not exist "%Location%\arm64\" mkdir "%Location%\arm64\"
echo ======================================
echo Copying files to x86
xcopy "%USMTx86%\*" "%Location%\x86\" /y /v /q 
xcopy "%Sourcesx86%\*" "%Location%\x86\" /y /v /q 
echo ======================================
echo Copying files to amd64
xcopy "%USMTx64%\*" "%Location%\amd64\" /y /v /q 
xcopy "%Sourcesx86%\*" "%Location%\amd64\" /y /v /q 
echo ======================================
echo Copying files to arm64
xcopy "%USMTARM64%\*" "%Location%\arm64\" /y /v /q 
xcopy "%SourcesARM64%\*" "%Location%\arm64\" /y /v /q 
echo ======================================
ECHO.
ECHO ===================================
ECHO Process Complete ! :)
ECHO You can update the Recovery Project
ECHO Press any key to exit.
ECHO ===================================
pause>nul
exit

:ADKError
cls
ECHO.
ECHO ===================================
ECHO Sorry, You don't have ADK... :(
ECHO Please install the ADK for Windows 10 
ECHO Press any key to exit.
ECHO ===================================
pause>nul
exit

:ScanStateError
cls
ECHO.
ECHO ===================================
ECHO Sorry, You don't have ScanState... :(
ECHO Please install the ADK for Windows 10 
ECHO Press any key to exit.
ECHO ===================================
pause>nul
exit