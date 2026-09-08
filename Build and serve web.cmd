@echo off
setlocal
cd /d "%~dp0"
set "GODOT=C:\Portables\Godot4\Godot_v4.7.2-stable_mono_win64_console.exe"
set "APPDATA=%~dp0.runtime-data"
if not exist "%APPDATA%" mkdir "%APPDATA%"
if not exist "builds\web" mkdir "builds\web"

echo [1/2] Packaging game assets into builds\web\index.pck ...
"%GODOT%" --headless --path "%~dp0." --export-pack "Windows Desktop" "builds/web/index.pck"
if errorlevel 1 (
    echo Packaging failed.
    pause
    exit /b 1
)

echo [2/2] Assembling HTML5 WebAssembly engine files ...
"%GODOT%" --headless --path "%~dp0." --script "scripts/assemble_web.gd"
if errorlevel 1 (
    echo Web assembly failed.
    pause
    exit /b 1
)

echo.
echo Build successful! Starting HTTP server at http://localhost:8040 ...
start http://localhost:8040
python serve_web.py
pause
