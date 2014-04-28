@ECHO OFF

SET BINPATH=D:\bennu\bin\windows

:: Compilo FPG Tools
%BINPATH%\bgdc.exe tools\fpg-tools\fpg-tools.prg
CLS

:: 'Exporto' FPGs
::%BINPATH%\bgdi.exe tools\fpg-tools\fpg-tools.dcb -e fpg-sources fpg 16

:: 'Compilo' FPGs
::%BINPATH%\bgdi.exe tools\fpg-tools\fpg-tools.dcb -c fpg-sources fpg 16

:: Compilo juego
%BINPATH%\bgdc.exe main.prg
IF NOT ERRORLEVEL 2 %BINPATH%\bgdi.exe main.dcb
IF ERRORLEVEL 2 PAUSE
