:: creo el dcb
cd ..
bgdc.exe "%prgname%.prg"
cd releases\
MOVE "..\%prgname%.dcb" %url%\%prgname%.dcb

:: copio binarios de bennu
xcopy %bennupath%\%platform% /E /D /I /q %root%\bgd-runtime\

::copio archivos especificos de wiz
copy release-files\icon.png %url%\icon.png
copy release-files\script.gpe %url%\%gamename%.gpe

copy release-files\wiz.ini %root%\%gamename%.ini

::copio archivos del juego
CALL files.bat copy_files
CALL files.bat copy_extra_files

:: comprimo 
CALL files.bat zip_file
