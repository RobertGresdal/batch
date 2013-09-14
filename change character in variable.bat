rem Example of changing one character to another in a variable.
rem This script can take a file dropped onto it in windows GUI and make it
rem into a URL where spaces are changed into %20 and backslahes into front slashes.
SETLOCAL ENABLEDELAYEDEXPANSION
set filename=%~1
set nf=!filename: =%%20!
set inputURL=file://!nf:\=/!
echo %inputURL%
goto exit