@echo off
chcp 65001 >nul
cd /d "%~dp0"

title CodeCV 简历去水印工具
color 0B

echo ╔══════════════════════════════════════╗
echo ║   CodeCV 简历去水印工具              ║
echo ╚══════════════════════════════════════╝
echo.

:: 激活虚拟环境
call .venv\Scripts\activate.bat

if not "%~1"=="" (
    :: 命令行参数模式：run.bat "输入文件.pdf" ["输出文件.pdf"]
    if "%~2"=="" (
        python remove_codecv_watermark.py "%~1"
    ) else (
        python remove_codecv_watermark.py "%~1" "%~2"
    )
    goto :end
)

:: 交互模式
:input
echo 请选择操作：
echo   [1] 拖拽 PDF 文件到本窗口
echo   [2] 手动输入文件路径
echo   [3] 退出
echo.
set /p CHOICE=请输入 (1/2/3):

if "%CHOICE%"=="1" goto :drag
if "%CHOICE%"=="2" goto :manual
if "%CHOICE%"=="3" exit /b
goto :input

:drag
echo.
echo 请将 PDF 文件拖拽到本窗口，然后按回车：
set /p FILE_PATH=
if "%FILE_PATH%"=="" goto :input
goto :run

:manual
echo.
set /p FILE_PATH=请输入 PDF 文件路径：
if "%FILE_PATH%"=="" goto :input

:run
echo.
echo 处理中...
python remove_codecv_watermark.py "%FILE_PATH%"
echo.
if %ERRORLEVEL%==0 (
    echo ✅ 去水印成功！
) else (
    echo ⚠ 未检测到水印或处理失败
    echo   请确认文件是 CodeCV 导出的 PDF
)
echo.
pause
goto :input

:end
echo.
if %ERRORLEVEL%==0 (
    echo ✅ 去水印成功！
) else (
    echo ⚠ 未检测到水印或处理失败
)
echo.
pause
