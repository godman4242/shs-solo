@echo off
:: Straw Hat Samurai: Duels — local launcher wrapper for Windows
cd /d "%~dp0"
python play.py
if errorlevel 1 pause
