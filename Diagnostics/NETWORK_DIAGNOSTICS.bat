@echo off
chcp 65001 >nul
title Network Diagnostics
color 0B
set "OUT=%USERPROFILE%\Desktop\Network-Diagnostics-%COMPUTERNAME%.txt"
(
  echo NETWORK DIAGNOSTICS
  echo Date: %date% %time%
  echo Computer: %COMPUTERNAME%
  echo.
  echo ==== IP CONFIGURATION ====
  ipconfig /all
  echo.
  echo ==== ROUTES ====
  route print
  echo.
  echo ==== DNS CACHE SUMMARY ====
  ipconfig /displaydns
  echo.
  echo ==== WLAN INTERFACES ====
  netsh wlan show interfaces
  echo.
  echo ==== WLAN DRIVERS ====
  netsh wlan show drivers
) > "%OUT%" 2>&1
echo Отчёт создан: "%OUT%"
echo Внимание: перед отправкой отчёта кому-либо проверьте его на наличие имени ПК,
echo локальных IP-адресов, имени Wi-Fi сети и других личных данных.
pause
