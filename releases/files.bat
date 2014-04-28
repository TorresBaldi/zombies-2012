IF "%1" == "configure" GOTO configure
IF "%1" == "copy_files" GOTO copy_files
IF "%1" == "copy_extra_files" GOTO copy_extra_files
IF "%1" == "copy_source" GOTO copy_source
IF "%1" == "zip_file" GOTO zip_file
GOTO end


::
:::::: CONFIGURACIONES
::
:configure

set gamename=zombies2012
set prgname=main
set bennupath=D:\bennu\bin

::
:::::: VERSIONES A CREAR
::

set windows=1
set linux=1
set wiz=1
set caanoo=1
set source=1

GOTO end


::
:: ARCHIVOS DEL JUEGO
::
:copy_files

::archivos y carpetas de recursos
xcopy "..\bgm" /D /E /I /Q "%url%\bgm"
xcopy "..\sfx" /D /E /I /Q "%url%\sfx"
xcopy "..\fpg" /D /E /I /Q "%url%\fpg"

GOTO end


::
:: ARCHIVOS DE DISTRUBUCION
::
:copy_extra_files

::archivos extra (tambien incluidos en release exe)
xcopy "..\readme.txt" /Q "%url%\"

GOTO end


::
:: ARCHIVOS FUENTE
::
:copy_source

::archivos y carpetas de recursos
xcopy "..\bgm" /D /E /I /Q "%url%\bgm"
xcopy "..\sfx" /D /E /I /Q "%url%\sfx"
xcopy "..\fpg" /D /E /I /Q "%url%\fpg"

:: codigo fuente
xcopy "..\prg" /D /E /I /Q "%url%\prg"

xcopy "..\main.prg" /Q "%url%\"

GOTO end


::
:: COMPRIMO ARCHIVOS
::
:zip_file

::comprimo archivo
winRAR a -cl -m5 -r "%ver%\%gamename%-%ver%-%platform%.zip" "%root%\*"

:: borro carpeta 
rd /Q /s %root%

GOTO end


:end
