#SingleInstance Force
#NoEnv
SendMode Input

!`::
WinGetClass, ActiveClass, A
WinGet, WinClassCount, Count, ahk_class %ActiveClass%
IF WinClassCount = 1
    Return
Else
WinSet, Bottom,, A
WinActivate, ahk_class %ActiveClass%
return

!+`::
WinGetClass, ActiveClass, A
WinActivateBottom, ahk_class %ActiveClass%
return

#if GetKeyState("F24")
1::switchDesktopByNumber(1)
2::switchDesktopByNumber(2)
3::switchDesktopByNumber(3)
4::switchDesktopByNumber(4)
5::switchDesktopByNumber(5)
6::switchDesktopByNumber(6)
7::switchDesktopByNumber(7)
8::switchDesktopByNumber(8)
9::switchDesktopByNumber(9)

!1::MoveCurrentWindowToDesktop(1)
!2::MoveCurrentWindowToDesktop(2)
!3::MoveCurrentWindowToDesktop(3)
!4::MoveCurrentWindowToDesktop(4)
!5::MoveCurrentWindowToDesktop(5)
!6::MoveCurrentWindowToDesktop(6)
!7::MoveCurrentWindowToDesktop(7)
!8::MoveCurrentWindowToDesktop(8)
!9::MoveCurrentWindowToDesktop(9)

!Q::WinClose A
Enter::Run, wt
D::Send {LWin}
I::Run, wt nvim -c "autocmd TextChanged`,TextChangedI <buffer> silent write" %A_Desktop%\..\vim-temp.txt
M::Run, %A_Desktop%\..\.manual\msteams-workaround\fix1.bat, %A_Desktop%\..\.manual\msteams-workaround\

Tab::
win := windows()
WinActivate, % "ahk_id " win[win.Count()]
Return

windows() {
 program := []
 WinGet, wins, List
 Loop, %wins% {
  WinGet, style, Style, % "ahk_id " wins%A_Index%
  If !(style ~= "0x(9|16)")
   program.Push(wins%A_Index%)
 }
 Return program
}

