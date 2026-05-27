@echo off
title Jeeni — AI Mental Health Companion
color 0A

echo.
echo  ======================================
echo   JEENI - AI Mental Health Companion
echo   Starting all services...
echo  ======================================
echo.

:: Check if Ollama is installed
where ollama >nul 2>&1
if %errorlevel% neq 0 (
    echo  [!] Ollama not found in PATH. 
    echo      Please install from: https://ollama.com
    echo      Jeeni will run in fallback mode.
    echo.
) else (
    echo  [1/4] Starting Ollama server...
    start "Ollama Server" cmd /k "ollama serve"
    timeout /t 3 /nobreak >nul
)

:: Install server dependencies if needed
echo  [2/4] Checking server dependencies...
cd /d "%~dp0server"
if not exist "node_modules" (
    echo      Installing server packages...
    call npm install
)

:: Start backend proxy server
echo  [3/4] Starting backend proxy server...
start "Jeeni Backend" cmd /k "cd /d %~dp0server && node server.js"
timeout /t 2 /nobreak >nul

:: Start Telegram bot
echo  [3.5/4] Starting Telegram bot...
start "Jeeni Telegram" cmd /k "cd /d %~dp0server && node telegramBot.js"
timeout /t 1 /nobreak >nul

:: Install frontend dependencies if needed
cd /d "%~dp0"
if not exist "node_modules" (
    echo      Installing frontend packages...
    call npm install
)

:: Start frontend dev server
echo  [4/4] Starting frontend dev server...
start "Jeeni Frontend" cmd /k "cd /d %~dp0 && npm run dev"

echo.
echo  ======================================
echo   All services started!
echo   Frontend: http://localhost:5173
echo   Backend:  http://localhost:3001
echo   Telegram: Running in background
echo  ======================================
echo.
echo  Press any key to close this window...
echo  (Services will continue running)
pause >nul
