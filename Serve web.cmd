@echo off
setlocal
cd /d "%~dp0"
echo Starting Three Colors of Madness Web Server on port 8040...
start http://localhost:8040
python serve_web.py
pause
