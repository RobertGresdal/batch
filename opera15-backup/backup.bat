@echo off

rem  ========================================
rem  ============= BACKUP.BAT ===============
rem  ========================================
REM  Backup script for Opera 15 and up

REM  Get options
SET OPTION=%1
SET SQLFOUND=
SET GITFOUND=

REM  INIT
REM  ====
REM  Check if sqlite3.exe exist in the path folders ( Nice solution by Joey! http://bit.ly/16CqIVQ )
FOR %%X IN (sqlite3.exe) DO ( 
	SET SQLFOUND=%%~$PATH:X 
)
IF NOT DEFINED SQLFOUND (
	ECHO.WARNING: sqlite3 is not in path. Will not be able to dump databases.
) ELSE (
	ECHO.Found "%SQLFOUND%"
)

REM  Check for git.cmd in the path
FOR %%X IN (git.cmd) DO ( 
	SET GITFOUND=%%~$PATH:X 
)
IF NOT DEFINED GITFOUND (
	ECHO.WARNING: git is not in path. Will not be able to commit changes. All files will be overwritten.
	SET /p CONTINUE="Overwrite files? [Y/N]: " %=%
	IF NOT "Y" == "%CONTINUE%" (
		ECHO.EXIT: Batch aborted by user. User does not wish to overwrite files.
		GOTO EXIT
	)
) ELSE (
	ECHO.Found "%GITFOUND%"
)

IF NOT EXIST backup (
	ECHO.Creating directory "backup"
	MKDIR backup
)
rem  Create git repository
IF NOT EXIST "backup/.git" (
	IF DEFINED GITFOUND (
		pushd backup
		git init
		IF NOT EXIST .gitignore echo /.gitignore> .gitignore
		popd
	)
)

REM  COPY FILES TO BACKUP FOLDER
SETLOCAL ENABLEDELAYEDEXPANSION
SET t = %SQLFOUND%
FOR %%f IN (Bookmarks;favorites.db;Preferences;session.db;stash.db) DO (
	IF EXIST "%%f" (
		ECHO.Copying "%%f" to "./backup/%%f"
		copy /Y "%%f" "./backup/%%f"
		
		REM  IF SQLITE EXIST, DUMP FILES
		IF DEFINED SQLFOUND (
			IF ".db" == "%%~xf" (
				pushd backup
				ECHO.Dumping "%%f" to "%%~nf.sql"...
				sqlite3 "%%f" -cmd .dump .quit > "%%~nf.sql"
				popd
			)
		)
	)
)
REM  IF GIT EXIST, COMMIT CHANGES
IF DEFINED GITFOUND (
	pushd backup
	git add .
	git commit -m "Automatic backup"
	popd
)
ENDLOCAL

IF NOT ERRORLEVEL 1 GOTO EXIT



:DIRTYEXIT
echo
echo This exit should not happen, an uncatched exit exist in the script
exit /b 900

:FATALEXIT
echo
echo An error occured that prevents the script from finishing. Nothing was changed.
exit /b 100

:DESTRUCTIVEEXIT
echo
echo Oh no! An error occured while performing changes. The job was only partly finished.
exit /b 800

:EXIT
exit /b 0