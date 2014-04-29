@ECHO OFF

SET BINPATH=D:\bennu\bin\windows

:: Compilo FPG Tools
%BINPATH%\bgdc.exe tools\fpg-tools\fpg-tools.prg
CLS

:: 'Compilo' FPGs
%BINPATH%\bgdi.exe tools\fpg-tools\fpg-tools.dcb -c fpg-sources fpg 16
