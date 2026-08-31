@echo off
cd /d "%~dp0"
echo ========================================
echo  P0-5: WentiPersona instantiation
echo  Input : wenti_personas.jsonl (4800)
echo  Output: wenti_persona_instances.jsonl
echo  Model : Qwen3.6-35B-A3B (remote API)
echo  Workers: 4
echo ========================================
echo.

python wenti_data_simulator\persona\instantiate_personas.py ^
  --input   wenti_data_simulator\data\personas\wenti_personas.jsonl ^
  --output  wenti_data_simulator\data\personas\wenti_persona_instances.jsonl ^
  --errors  wenti_data_simulator\data\personas\instance_error_log.jsonl ^
  --limit   4800 ^
  --workers 4 ^
  --resume

echo.
echo ========================================
echo  Done. Check output file line count:
find /c /v "" "wenti_data_simulator\data\personas\wenti_persona_instances.jsonl"
echo ========================================
pause
