@echo off
chcp 65001 >nul
title Wi-Fi - Restore Power Settings
color 0A
net session >nul 2>&1
if errorlevel 1 (
  echo Запустите файл от имени администратора.
  pause
  exit /b 1
)
set "BACKUP=%ProgramData%\Win10-Mobile-Network-Tools\wifi-power-backup.txt"
if not exist "%BACKUP%" (
  echo Резервная копия не найдена. Ничего не изменено.
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop'; $items=Get-Content -Raw '%BACKUP%' | ConvertFrom-Json; foreach($i in @($items)){Set-NetAdapterPowerManagement -Name $i.Name -AllowComputerToTurnOffDevice $i.AllowComputerToTurnOffDevice -ErrorAction Stop}; Remove-Item '%BACKUP%' -Force; Write-Host 'Исходные настройки адаптера восстановлены.'"
if errorlevel 1 (
  echo Восстановление не завершено. Резервная копия сохранена.
  pause
  exit /b 1
)
pause
