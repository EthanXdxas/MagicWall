@echo off
echo ====================================
echo   GitHub Authentication Reset Tool
echo ====================================

:: Step 1: Clear git credential helper
git config --global --unset credential.helper >nul 2>&1
echo Cleared credential.helper from git config

:: Step 2: Delete Windows Credential Manager entry for GitHub
echo Deleting GitHub credentials from Windows Credential Manager...
cmdkey /delete:git:https://github.com >nul 2>&1

:: Step 3: Ask how to store new credentials
echo.
echo Choose credential storage method:
echo   1. Store in plain text (not secure)
echo   2. Use Windows Credential Manager (recommended)
set /p choice=Enter your choice (1/2): 

if "%choice%"=="1" (
    git config --global credential.helper store
    echo credential.helper set to store
) else (
    git config --global credential.helper manager
    echo credential.helper set to manager
)

:: Step 4: Ask user for GitHub username and token
echo.
set /p gh_user=Enter your GitHub username: 
set /p gh_token=Enter your GitHub Personal Access Token: 

:: Step 5: Save credentials manually (only if store was chosen)
if "%choice%"=="1" (
    echo https://%gh_user%:%gh_token%@github.com> "%USERPROFILE%\.git-credentials"
    echo Saved credentials to %USERPROFILE%\.git-credentials
) else (
    echo Next time you run git push, Windows Credential Manager will ask for your username and token.
)

echo.
echo Done! You can now run: git push origin main
pause
