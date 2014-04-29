@ECHO OFF

SET BINPATH=D:\bennu\bin\windows

:: Compilo juego
%BINPATH%\bgdc.exe main.prg
IF NOT ERRORLEVEL 2 %BINPATH%\bgdi.exe main.dcb
IF ERRORLEVEL 2 PAUSE
