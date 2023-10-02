@echo off
chcp 65001
color 0a
::WINDOWS 修改远程端口批处理脚本
title 修改Windows远程桌面服务端口号
echo *******************************************************************
echo * 请输入您要更改的远程桌面端口号，范围：1024-65535，不能与其他端口冲突*
echo *******************************************************************
echo.

:input
set /p port=请输入端口：
echo %port%| findstr /r "^[1-9][0-9]*$"
if errorlevel 1 (
    echo 错误：请输入数字。
    echo.
    goto input
) else (
    if %port% LSS 1024 (
        echo 错误：请输入1024-65535之间的数字。
        echo.
        goto input
    ) else (
        if %port% GTR 65535 (
            echo 错误：请输入1024-65535之间的数字。
            echo.
            goto input
        )
    )
)


echo 远程端口修改完成，您当前的远程端口已修改为%port%请使用新的端口进行连接

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber /t reg_dword /d %port% /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t reg_dword /d %port% /f
netsh advfirewall firewall add rule name="远程桌面" dir=in action=allow protocol=TCP localport=%port%
echo.
echo *******************************
echo * 重新启动远程桌面 *
echo *******************************
net stop termservice /y >nul
net start termservice >nul

pause
exit
