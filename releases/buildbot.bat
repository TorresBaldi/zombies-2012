@echo off
Title BUILDBOT

::
:::::: CARGO CONFIGURACIONES
::
CALL files.bat configure


::
:::::: PREGUNTO VERSION
::
echo Version:
set /p ver=
mkdir %ver%

:: agrego winrar y bennu windows al path
set path=%path%;"C:\Archivos de programa\WinRAR";%bennupath%\windows\


:bot_begin

:: WINDOWS
IF %windows% == 0 GOTO skip_windows

	SET windows=0

	SET platform=windows
	SET ROOT=%gamename%-%platform%
	SET URL=%root%

	MKDIR %url%
	
	CALL build-windows.bat
	
:skip_windows


:: LINUX
IF %linux% == 0 GOTO skip_linux

	SET linux=0

	SET platform=linux
	SET ROOT=%gamename%-%platform%
	SET URL=%root%

	MKDIR %url%

	CALL build-linux.bat
	
:skip_linux


:: SOURCE CODE
IF %source% == 0 GOTO skip_source

	SET source=0

	SET platform=source
	SET ROOT=%gamename%-%platform%
	SET URL=%root%

	MKDIR %url%
	
	CALL build-source.bat
	
:skip_source


:: WIZ
IF %wiz% == 0 GOTO skip_wiz

	SET wiz=0

	SET platform=wiz
	SET ROOT=%gamename%-%platform%
	SET URL=%root%\%gamename%

	MKDIR %url%
	
	CALL build-wiz.bat
	
:skip_wiz


:: CAANOO
IF %caanoo% == 0 GOTO skip_caanoo

	SET caanoo=0

	SET platform=caanoo
	SET ROOT=%gamename%-%platform%
	SET URL=%root%\%gamename%

	MKDIR %url%
	
	CALL build-caanoo.bat
	
:skip_caanoo


:: si ya no quedan plataformas, termino
GOTO bot_end



:bot_end

ECHO "BOT ENDED"