@echo off

REM  
:USER_VARIABLES
SET INSTALL_PATH=C:\temp\


REM 
REM   PLEASE DO NOT CHANGE ANYTHING BELOW UNLESS YOU KNOW WHAT YOU ARE DOING
REM 
SET VERSION=stable
	
:SET_SCRIPT_OPTIONS
FOR %%o in (%*) DO (
	IF "/D" == "%%o" SET ALWAYS_DOWNLOAD=1
	IF "/V=NEXT" == "%%o" SET VERSION=next
	IF "/V=DEV" == "%%o" SET VERSION=development
	IF "/V=DAILY" == "%%o" SET VERSION=daily
)

:LOAD_DOWNLOAD_URLS
(
	SET /p OPERA_STABLE=
	SET /p OPERA_NEXT=
	SET /p OPERA_DEVELOPMENT=
	SET /p OPERA_DAILY=
)<urls.txt

:COMPUTED_VARIABLES
IF VERSION==next (
	SET OUTPUTFILE=install_next.exe
	SET DOWNLOAD_URL=%OPERA_NEXT%
) ELSE IF VERSION==development (
	SET OUTPUTFILE=install_development.exe
	SET DOWNLOAD_URL=%OPERA_DEVELOPMENT%
) ELSE IF VERSION==daily(
	SET OUTPUTFILE=install_daily.exe
	SET DOWNLOAD_URL=%OPERA_DAILY%
) ELSE (
	SET OUTPUTFILE=install_stable.exe
	SET DOWNLOAD_URL=%OPERA_STABLE%
)


:PREPARE_FOR_DOWNLOAD
IF NOT EXIST downloads MKDIR downloads
IF %ALWAYS_DOWNLOAD%==1 GOTO DOWNLOAD
IF EXIST "downloads/%OUTPUTFILE%" SET INSTALLFILE_EXIST=1

:DOWNLOAD
IF NOT %ALWAYS_DOWNLOAD%==1 (
	IF %INSTALLFILE_EXIST%==1 (
		ECHO Skipping download as the file already exist.
		SET SKIP_DOWNLOAD==1
	)
)
IF NOT %SKIP_DOWNLOAD%==1 (
	powershell.exe "-Command (new-object System.Net.WebClient).DownloadFile("'%DOWNLOAD_URL%'", "'%~dp0\downloads\%OUTPUTFILE%'")"
)


rem powershell -Command (Invoke-WebRequest -uri "'%OPERA_STABLE%'" -OutFile "'%~dp0\downloads\install_stable.exe'")

rem pushd wget
rem wget -nc "%OPERA_STABLE%" --output-document=../downloads/install_stable.exe
rem popd

:INSTALL_OPERA
pushd downloads
"%OUTPUTFILE%" /install /runimmediately /launchopera=0 /installfolder="%INSTALL_PATH%" /singleprofile=1 /copyonly=1
popd

:INSTALL_BACKUP_SCRIPT
IF NOT EXIST "%INSTALL_PATH%/profile/data" MKDIR "%INSTALL_PATH%/profile/data"
copy /Y "backup.bat" "%INSTALL_PATH%/profile/data/backup.bat"


:EXIT
SET ERRORLEVEL=0
exit /b