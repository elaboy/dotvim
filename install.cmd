@echo off
rem Install dotvim for native Windows Vim (gvim.exe / vim.exe) without Git Bash.
rem Writes %HOME%\_vimrc (or %USERPROFILE%\_vimrc) as a one-line pointer to
rem this repo. An existing _vimrc is backed up first. Safe to re-run.
setlocal EnableDelayedExpansion

set "REPO=%~dp0"
set "REPO=!REPO:\=/!"
set "REPO=!REPO: =\ !"
set "STUB=source !REPO!vimrc"

if defined HOME (set "TARGET=%HOME%\_vimrc") else (set "TARGET=%USERPROFILE%\_vimrc")

if exist "!TARGET!" (
    findstr /x /c:"!STUB!" "!TARGET!" >nul 2>&1
    if not errorlevel 1 (
        echo !TARGET! already points here
        exit /b 0
    )
    set "BACKUP=!TARGET!.bak.!RANDOM!"
    move "!TARGET!" "!BACKUP!" >nul
    echo backed up !TARGET! to !BACKUP!
)

(echo !STUB!)>"!TARGET!"
echo wrote !TARGET!
