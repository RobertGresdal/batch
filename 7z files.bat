echo off
cls
echo.It's best to drag a file onto the batch file to make sure everything works.
echo.

SETLOCAL ENABLEDELAYEDEXPANSION

:uservariables



:programvariables
rem Gets the filename from argument and creates a full URL from it
rem It's best to drag a file onto the batch file to make sure everything works
set absolutePath=%1
set inputFile=%~n1
echo.Source file: %inputFile%
echo.

rem Makes calling vlc a little easier
set path=%path%;C:\Program Files\7-Zip

rem Sets current timestamp
rem set curTimestamp=%date:~7,2%_%date:~3,3%_%date:~10,4%_%time:~0,2%_%time:~3,2%
rem set curTimestamp=%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%
set curTimestamp=%DATE:/=-%@%TIME::=-%
set outputFile=%inputFile%-%curTimestamp%.7z
echo.Writing to %outputFile%
echo.

:7zVariables
rem set generalOptions=-I dummy --no-sout-video --sout-audio --no-sout-rtp-sap --no-sout-standard-sap --ttl=1 --sout-keep
set command=a
set switches=


:compress
set run=7z %command% %switches% %outputFile% %absolutePath%
echo %run%
%run%
goto exit




:stuff
rem vlc d3.avi --no-sout-video --sout "#std{mux=raw,dst=file.mp3}" vlc://quit
:exit
pause