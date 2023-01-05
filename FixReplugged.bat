@echo off

:check_connection
cls
echo Checking for internet connection...
ping -n 1 google.com >nul 2>&1
if not %errorlevel% == 0 (
  echo No internet connection detected. Waiting 60 seconds before trying again.
  timeout /t 60 >nul 2>&1
  goto check_connection
) else (
  echo Internet connection detected. Proceeding with script.
)

:check_nodejs
echo Checking if Node.js is installed...
where npm >nul 2>&1
if %errorlevel% == 0 (
  echo Node.js is already installed.
  goto check_discordcanary
) else (
  echo Node.js is not installed on this system.
  set /p install="Do you want to install it now? (y/n) "
  if /i "%install%" == "y" (
    goto install_nodejs
  ) else (
    echo Exiting script.
    goto :eof
  )
)

:install_nodejs
echo Downloading Node.js installer...
bitsadmin /transfer "nodejs_installer" /download /priority high "https://nodejs.org/dist/v18.12.1/node-v18.12.1-x64.msi" "%temp%\node-v18.12.1-x64.msi"
echo Installing Node.js...
start "" /wait msiexec /i "%temp%\node-v18.12.1-x64.msi" /qn
if %ERRORLEVEL% == 0 (
  echo Node.js installation successful.
  goto check_nodejs
) else (
  echo Node.js installation failed. Exiting script.
  goto :eof
)

:check_discordcanary
echo Stopping DiscordCanary process...
taskkill /f /im discordcanary.exe >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to stop DiscordCanary process.
)

echo Installing pnpm...
call npm i -g pnpm >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to install pnpm.
  goto :eof
)

echo Changing to %userprofile%\replugged directory...
PUSHD %userprofile%\replugged >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to change to %userprofile%\replugged directory.
  goto :eof
)

echo Updating global git configuration...
call git config --global --add safe.directory %userprofile%\replugged >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to update global git configuration.
  goto :eof
)

echo Pulling latest changes from Git repository...
call git pull >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to pull latest changes from Git repository.
  goto :eof
)

echo Unplugging DiscordCanary...
call pnpm run unplug canary >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to unplug DiscordCanary.
  goto :eof
)

echo Installing dependencies...
call pnpm i >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to install dependencies.
  goto :eof
)
echo Building project...
call pnpm run build >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to build project.
  goto :eof
)

echo Plugging DiscordCanary...
call pnpm run plug canary >nul 2>&1
if not %errorlevel% == 0 (
  echo Failed to plug DiscordCanary.
  goto :eof
)

echo Launching DiscordCanary update process...
START "" "%localappdata%\DiscordCanary\Update.exe" --processStart discordcanary.exe

echo Restoring original current directory...
POPD

echo Done.
