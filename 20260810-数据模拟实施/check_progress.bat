@echo off
chcp 65001 >nul
cd /d "%~dp0"

set JSONL=wenti_data_simulator\data\personas\wenti_personas.jsonl

for /f %%i in ('find /c /v "" "%JSONL%" 2^>nul') do set LINES=%%i
echo 当前进度: %LINES% / 5000 条
echo 文件: %JSONL%
echo.
