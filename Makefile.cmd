@echo off

set MKPATH=constructor
set AHK2EXE=Ahk2Exe.exe
set PACKER=upx.exe

if defined ProgramFiles(x86) (
    set AHKRES=resources64.bin
) else (
    set AHKRES=resources32.bin
)

set object=cmd-dropdown

if "%~1" == "clean" (
    call:clean
) else (
    call:cmd-dropdown
)

echo Successfully compiled
goto:EOF

:cmd-dropdown
    echo %MKPATH%\%AHK2EXE% /in %object%.ahk /bin %MKPATH%\%AHKRES%
    %MKPATH%\%AHK2EXE% /in %object%.ahk /bin %MKPATH%\%AHKRES%
    echo %MKPATH%\%PACKER% %object%.exe
    %MKPATH%\%PACKER% %object%.exe
goto:EOF

:clean
    echo DEL /F /Q %object%.exe
    DEL /F /Q %object%.exe
goto:EOF
