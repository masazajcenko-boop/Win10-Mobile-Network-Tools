@echo off
chcp 65001 >nul
title Wi-Fi - Prevent Adapter Power Off
color 0B
net session >nul 2>&1
if errorlevel 1 (
  echo Запустите файл от имени администратора.
  pause
  exit /b 1
)
set "ROOT=%ProgramData%\Win10-Mobile-Network-Tools"
if not exist "%ROOT%" mkdir "%ROOT%"
set "BACKUP=%ROOT%\wifi-power-backup.txt"
if exist "%BACKUP%" (
  echo Резервная копия уже существует. Сначала выполните WIFI_RESTORE.bat.
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop'; $a=Get-NetAdapter -Physical | Where-Object {$_.Status -ne 'Not Present' -and ($_.Name -match 'Wi-Fi|WiFi|Wireless' -or $_.InterfaceDescription -match 'Wi-Fi|Wireless|802.11')}; if(-not $a){Write-Host 'Wi-Fi адаптер не найден.'; exit 2}; $out=@(); foreach($n in $a){$p=Get-NetAdapterPowerManagement -Name $n.Name -ErrorAction SilentlyContinue; if($null -eq $p){Write-Host ('Управление питанием недоступно для '+$n.Name); continue}; $out += [pscustomobject]@{Name=$n.Name; AllowComputerToTurnOffDevice=[string]$p.AllowComputerToTurnOffDevice}}; if($out.Count -eq 0){exit 3}; $out | ConvertTo-Json | Set-Content -Encoding UTF8 '%BACKUP%'; foreach($n in $a){Set-NetAdapterPowerManagement -Name $n.Name -AllowComputerToTurnOffDevice Disabled -ErrorAction Continue}; Write-Host 'Настройка применена. Возможно, потребуется переподключить Wi-Fi.'"
if errorlevel 1 (
  echo Не удалось применить настройку. Проверьте поддержку драйвером.
  pause
  exit /b 1
)
echo.
echo Windows больше не должна отключать поддерживаемый адаптер для экономии энергии.
echo Это не удерживает соединение при полном сне ПК или выключении точки доступа телефона.
echo Для отмены запустите WIFI_RESTORE.bat.
pause
