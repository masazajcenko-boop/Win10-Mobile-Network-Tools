@echo off
chcp 65001 >nul
title Mobile Internet - Safe Optimization
color 0B
net session >nul 2>&1
if errorlevel 1 (
  echo Запустите файл от имени администратора.
  pause
  exit /b 1
)
set "ROOT=%ProgramData%\Win10-Mobile-Network-Tools"
if not exist "%ROOT%" mkdir "%ROOT%"
set "BACKUP=%ROOT%\delivery-optimization-backup.txt"
if exist "%BACKUP%" (
  echo Резервная копия уже существует: "%BACKUP%"
  echo Сначала выполните MOBILE_NET_RESTORE.bat, если хотите начать заново.
  pause
  exit /b 1
)
set "KEY=HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
set "OLD="
for /f "tokens=3" %%A in ('reg query "%KEY%" /v DODownloadMode 2^>nul') do set "OLD=%%A"
if defined OLD (
  >"%BACKUP%" echo PRESENT
  >>"%BACKUP%" echo %OLD%
) else (
  >"%BACKUP%" echo ABSENT
)
reg add "%KEY%" /v DODownloadMode /t REG_DWORD /d 0 /f
if errorlevel 1 (
  del "%BACKUP%" >nul 2>&1
  echo Не удалось изменить настройку.
  pause
  exit /b 1
)
echo.
echo Готово. Режим обмена обновлениями с другими ПК отключён.
echo Windows Update, Defender и Firewall не отключались.
echo Для дополнительной экономии трафика включите "Лимитное подключение"
echo в Параметры - Сеть и Интернет - Wi-Fi - свойства вашей точки доступа.
echo.
echo Для отмены запустите Network\MOBILE_NET_RESTORE.bat.
pause
