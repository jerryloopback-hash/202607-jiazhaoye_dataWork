@echo off
chcp 936 >nul
echo ============================================
echo  P2-2 + P2-3  User + Marketing Events
echo  Target: 800 j_member rows + related tables
echo  ETA: 25-40 hours (LLM serial, concurrency=1)
echo  Resume: run again after interrupt (auto-resume)
echo ============================================
echo.

set WORKDIR=%~dp0
cd /d "%WORKDIR%"

echo [INFO] Working dir: %CD%
echo [INFO] Start time: %DATE% %TIME%
echo.

D:\devWorkshopForCC\.venv\Scripts\python.exe wenti_data_simulator\generators\generate_members.py

echo.
echo [INFO] Done: %DATE% %TIME%
echo.
echo Output: wenti_data_simulator\data\output\
echo   j_member.csv
echo   j_member_third.csv
echo   buy_ticket_people.csv
echo   j_member_time_card.csv
echo   j_coupon.csv
echo.
pause
