@echo off
REM  Backup script for Opera 15 and up

REM  Get options
SET OPTION=%1
SET GITEXIST=


REM  INIT
REM  ====
REM  Check if sqlite3.exe exist in the path folders ( Nice solution by Joey! http://bit.ly/16CqIVQ )
for %%X in (sqlite3.exe) do (set SQLFOUND=%%~$PATH:X)
IF NOT DEFINED SQLFOUND (
    ECHO.WARNING: sqlite3 is not in path. Will not be able to dump databases.
) ELSE (
	ECHO.Using %SQLFOUND%
)
for %%X in (git.exe) do (set GITFOUND=%%~$PATH:X)
IF NOT DEFINED GITFOUND (
	ECHO.WARNING: git is not in path. Will not be able to commit changes. All files will be overwritten.
	SET /p CONTINUE="Overwrite files? [Y/N]: " %=%
	IF NOT CONTINUE==Y (
		ECHO.EXIT: Batch aborted by user. User does not wish to overwrite files.
		GOTO CLEANEXIT
	)
) ELSE (
	ECHO.Using %GITFOUND%
)

REM  COPY FILES TO BACKUP FOLDER
FOR %%f IN (Bookmarks;favorites.db;Preferences;session.db;stash.db) DO (
	IF EXIST %%f (
		IF NOT EXIST backup (
			mkdir backup
		)
		copy /Y %%f ./backup/%%f
	)
)

REM  IF SQLITE EXIST, DUMP FILES

REM  IF GIT EXIST, COMMIT CHANGES

IF NOT ERRORLEVEL 1 GOTO CLEANEXIT



:DIRTYEXIT
echo.
echo. This exit should not happen, an uncatched exit exist in the script
exit /b

:FATALEXIT
echo.
echo.An error occured that prevents the script from finishing. Nothing was changed.
echo.
exit /b

:DESTRUCTIVEEXIT
echo.
echo.Oh no! An error occured while performing changes. The job was only partly finished.
echo.
exit /b

:CLEANEXIT
set errorlevel=0
exit /b