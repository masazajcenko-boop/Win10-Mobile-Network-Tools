@echo off
chcp 65001 >nul
title Mobile Internet - Restore
color 0A
net session >nul 2>&1
if errorlevel 1 (
  echo Запустите файл от имени администратора.
  pause
  exit /b 1
)
set "BACKUP=%ProgramData%\Win10-Mobile-Network-Tools\delivery-optimization-backup.txt"
if not exist "%BACKUP%" (
  echo Резервная копия не найдена. Ничего не изменено.
  pause
  exit /b 1
)
set "STATE="
set "VALUE="
<"%BACKUP%" (
  set /p STATE=
  set /p VALUE=
)
set "KEY=HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
if /i "%STATE%"=="PRESENT" (
  reg add "%KEY%" /v DODownloadMode /t REG_DWORD /d %VALUE% /f
  if errorlevel 1 goto :failed
) else if /i "%STATE%"=="ABSENT" (
  reg delete "%KEY%" /v DODownloadMode /f >nul 2>&1
) else (
  echo Файл резервной копии повреждён. Ничего не изменено.
  pause
  exit /b 1
)
del "%BACKUP%" >nul 2>&1
echo Исходное состояние параметра восстановлено.
pause
exit /b 0
:failed
echo Не удалось восстановить параметр. Резервная копия сохранена.
pause
exit /b 1
