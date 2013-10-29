rem @echo off

SET OPERA_NEXT=
SET OPERA_DEVELOPMENT=
SEt OPERA_DAILY=
SET INSTALL_PATH="C:\temp\Opera Development"

(
	SET /p OPERA_STABLE=
	SET /p OPERA_NEXT=
)<download.txt
@echo on
if not exist downloads mkdir downloads
powershell.exe -Command (new-object System.Net.WebClient).DownloadFile("%OPERA_NEXT%", %~dp0./downloads )
@echo off
rem wget %OPERA_STABLE%
echo "done"

rem %OPERA% /install /runimmediately /launchopera=0 /installfolder=%INSTALL_PATH% /singleprofile=1 /copyonly=1