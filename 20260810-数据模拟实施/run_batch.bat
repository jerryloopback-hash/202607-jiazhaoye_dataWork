@echo off
cd /d "%~dp0"

echo ========================================
echo  PersonaHub batch run - 4800 personas
echo  Output: wenti_personas.jsonl (target 5000)
echo ========================================
echo.

python wenti_data_simulator\persona\hub_adapter.py ^
  --input  wenti_data_simulator\data\personas\persona_hub_stratified_4800.jsonl ^
  --output wenti_data_simulator\data\personas\wenti_personas.jsonl ^
  --errors wenti_data_simulator\data\personas\error_log.jsonl ^
  --limit  4800 ^
  --workers 4 ^
  --resume

echo.
echo ========================================
echo  Done. Press any key to close.
echo ========================================
pause
