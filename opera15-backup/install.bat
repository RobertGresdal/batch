rem @echo off

rem init variables
SET OPERA_NEXT=
SET OPERA_DEVELOPMENT=
SEt OPERA_DAILY=
SET INSTALL_PATH="C:\temp\Opera Development"

rem Load download urls
(
	SET /p OPERA_STABLE=
	SET /p OPERA_NEXT=
	SET /p OPERA_DEVELOPMENT=
	SET /p TEST=
)<download.txt

IF NOT EXIST downloads MKDIR downloads

powershell.exe -Command ((new-object System.Net.WebClient).DownloadFile("'%OPERA_DEVELOPMENT%'", "'%~dp0\downloads\install_development.exe'"))

rem powershell -Command (Invoke-WebRequest -uri "'%OPERA_STABLE%'" -OutFile "'%~dp0\downloads\install_stable.exe'")

rem pushd wget
rem wget -nc "%OPERA_STABLE%" --output-document=../downloads/install_stable.exe
rem popd

rem %OPERA% /install /runimmediately /launchopera=0 /installfolder=%INSTALL_PATH% /singleprofile=1 /copyonly=1