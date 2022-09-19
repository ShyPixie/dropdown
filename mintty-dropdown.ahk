; This file is part of mintty-dropdown.
;
; Lara Maia <dev@lara.click> 2016
;
; mintty-dropdown is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; mintty-dropdown is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with mintty-dropdown.  If not, see <http://www.gnu.org/licenses/>.
;

;@Ahk2Exe-AddResource dropdown.ico, 160
;@Ahk2Exe-AddResource dropdown.ico, 206
;@Ahk2Exe-AddResource dropdown.ico, 207
;@Ahk2Exe-AddResource dropdown.ico, 208
;@Ahk2Exe-SetMainIcon dropdown.ico
;@Ahk2Exe-SetCopyright 2022
;@Ahk2Exe-SetInternalName dropdown
;@Ahk2Exe-SetName cmd-dropdown

#NoEnv
#SingleInstance ignore
#InputLevel, 100
SendMode Input
DetectHiddenWindows on

if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

Menu, Tray, NoStandard
Menu, Tray, Add, Reload, BtnReload
Menu, Tray, Add, Exit, BtnExit

iniFile = %A_WorkingDir%\mintty-dropdown.ini

IniRead, rootDir, %iniFile%, Global, rootDir
if rootDir contains ERROR
{
    MsgBox,, Error, Please, check your config file!
    Gosub BtnExit
}

IniRead, shell, %iniFile%, Global, shell
if shell contains ERROR
    shell = /bin/sh

IniRead, homeDir, %iniFile%, Global, homeDir
if homeDir contains ERROR
    homeDir = %rootDir%\home\%A_UserName%

IniRead, binDir, %iniFile%, Global, binDir
if binDir contains ERROR
    binDir = /usr/bin

IniRead, minttyPath, %iniFile%, Global, minttyPath
if minttyPath contains ERROR
    minttyPath = %rootDir%\%binDir%\mintty.exe

console = %minttyPath% --class mintty-dropdown %shell%

IniRead, height, %iniFile%, Global, height
if height contains ERROR
    height = 400

IniRead, consoleHotKey, %iniFile%, Global, consoleHotKey
if consoleHotKey contains ERROR
    consoleHotKey = !F12
HotKey, %consoleHotKey%, ConsoleCheck

IniRead, fullScreenHotKey, %iniFile%, Global, fullScreenHotKey
if fullScreenHotKey contains ERROR
    fullScreenHotKey = !F11
HotKey, %fullScreenHotKey%, fullScreenCheck

if fullScreenHotKey != !F11
    HotKey, !F11, Ignore
if fullScreenHotKey != !Enter
    Hotkey, !Enter, Ignore

IniRead, screenMoveRight, %iniFile%, Global, screenMoveRight
if screenMoveRight contains ERROR
    screenMoveRight = ^+Right
HotKey, %screenMoveRight%, screenMoveRightCheck

IniRead, screenMoveLeft, %iniFile%, Global, screenMoveLeft
if screenMoveLeft contains ERROR
    screenMoveLeft = ^+Left
HotKey, %screenMoveLeft%, screenMoveLeftCheck

CurrentScreenWidth = 0
CurrentScreenHeight = 0
window = ahk_class mintty-dropdown
fullscreen = 0
start()
setGeometry()

return

setGeometry() {
    global

    WinSet, AlwaysOnTop, On, %window%
    WinSet,   Style, -0x00C00000, %window% ; WS_CAPTION
    WinSet,   Style, -0x00040000, %window% ; WS_THICKFRAME
    WinSet,   Style, -0x00200000, %window% ; WS_VSCROLL
    WinSet, ExStyle,  0x00000080, %window% ; WS_EX_TOOLWINDOW

    WinMove, %window%,, CurrentScreenWidth, CurrentScreenHeight, A_ScreenWidth, %height%
}

start() {
    global

    IfWinNotExist %window%
    {
        Run %console%, %homeDir%, Hide
        WinWait %window%
    }
}

stop() {
    global

    IfWinExist %window%
    {
        WinClose
    }
}

checkWinStatus() {
    global

    DetectHiddenWindows off
    WinGet, temp_window,, %window%
    if %temp_window%
    {
        return "hide"
    }
    DetectHiddenWindows on
    return "show"
}

toggleFullScreen() {
    global

    if InStr(checkWinStatus(), "hide")
    {
        a += 1
        if InStr(Mod(a, 2), 0)
        {
            setGeometry()
            Send !{F11}
            setGeometry()
            fullscreen = 0
        }
        else
        {
            Send !{F11}
            fullscreen = 1
        }
    }
}

toggle() {
    global

    if InStr(checkWinStatus(), "hide")
    {
        WinHide %window%
    }
    else
    {
        WinShow %window%
        WinActivate %window%

        if %fullscreen%
        {
            toggleFullScreen()
        }
    }
}

consoleCheck:
    window = ahk_class mintty-dropdown

    start()
    setGeometry()
    toggle()

    return

fullScreenCheck:
    toggleFullScreen()

    return

screenMoveLeftCheck:
    SysGet, CurrentScreenWidth, 76
    SysGet, CurrentScreenHeight, 77
    setGeometry()

    return

screenMoveRightCheck:
    CurrentScreenWidth = 0
    CurrentScreenHeight = 0
    setGeometry()

    return

Ignore:
    return

BtnExit:
    stop()
    ExitApp

BtnReload:
    stop()
    Reload
