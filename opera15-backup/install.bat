@echo off

rem init variables
SET OPERA_NEXT=
SET OPERA_DEVELOPMENT=
SEt OPERA_DAILY=
SET INSTALL_PATH=C:\temp\Opera Development
SET OUTPUTFILE=install_development.exe

rem Load download urls
(
	SET /p OPERA_STABLE=
	SET /p OPERA_NEXT=
	SET /p OPERA_DEVELOPMENT=
	SET /p TEST=
)<download.txt

IF NOT EXIST downloads MKDIR downloads

IF EXIST "downloads/install_development.exe" (
	ECHO Skipping download as the file already exist. REM Use /D to force download
) ELSE (
	powershell.exe "-Command (new-object System.Net.WebClient).DownloadFile("'%OPERA_DEVELOPMENT%'", "'%~dp0\downloads\install_development.exe'")"
)
rem powershell -Command (Invoke-WebRequest -uri "'%OPERA_STABLE%'" -OutFile "'%~dp0\downloads\install_stable.exe'")

rem pushd wget
rem wget -nc "%OPERA_STABLE%" --output-document=../downloads/install_stable.exe
rem popd

pushd downloads
"%OUTPUTFILE%" /install /runimmediately /launchopera=0 /installfolder="%INSTALL_PATH%" /singleprofile=1 /copyonly=1
popd

IF NOT EXIST "%INSTALL_PATH%/profile" MKDIR "%INSTALL_PATH%/profile"
IF NOT EXIST "%INSTALL_PATH%/profile/data" MKDIR "%INSTALL_PATH%/profile/data"

copy /Y "backup.bat" "%INSTALL_PATH%/profile/data/backup.bat"
