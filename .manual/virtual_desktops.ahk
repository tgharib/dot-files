#SingleInstance Force

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
2::^#Left
return

3::^#Right
return

1::#Tab
return

!Q::
WinClose A
return
