:: creo el dcb con mochila
cd ..
bgdc.exe "%prgname%.prg"
cd releases\
MOVE "..\%prgname%.dcb" %url%\%prgname%.dcb

:: copio binarios de bennu
xcopy %bennupath%\%platform% /E /D /I /q %root%\bgd-runtime\

::copio archivos especificos de linux
copy release-files\linux.sh %root%\%gamename%.sh

::copio archivos del juego
CALL files.bat copy_files
CALL files.bat copy_extra_files

:: comprimo 
CALL files.bat zip_file
