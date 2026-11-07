@echo off
:: Builds Star Browser for Symbian^3/Anna/Belle (Qt 4.7.4 SDK, GCCE) and produces an unsigned .sis.
:: In-source build: Qt 4.7 + sbsv2 does not support shadow builds.
:: Usage: build_symbian.bat [release|debug]   (default: release)
setlocal
set PROJDIR=%~dp0
set CONF=%1
if "%CONF%"=="" set CONF=release

call C:\QtSDK\Symbian\SDKs\Symbian3Qt474\env.bat
pushd "%PROJDIR%"

qmake.exe StarBrowser.pro -r -spec symbian-sbsv2 "CONFIG+=%CONF%" || goto :fail
make %CONF%-gcce -w || goto :fail
:: -o: create only the unsigned package (no self-signing, no capability patching).
if exist StarBrowser.sis del StarBrowser.sis
make sis QT_SIS_TARGET=%CONF%-gcce QT_SIS_OPTIONS=-o || goto :fail
:: createpackage names it StarBrowser_unsigned.sis; keep the usual name.
move /y StarBrowser_unsigned.sis StarBrowser.sis >nul || goto :fail

echo.
echo === Build OK ===
dir /b *.sis
popd
exit /b 0

:fail
echo.
echo === Build FAILED ===
popd
exit /b 1
