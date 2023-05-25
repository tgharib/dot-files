#SingleInstance Force
#NoEnv
SendMode Input

Capslock::Esc ; for laptop
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
h::Run, komorebic.exe focus left, , Hide
j::Run, komorebic.exe focus down, , Hide
k::Run, komorebic.exe focus up, , Hide
l::Run, komorebic.exe focus right, , Hide

!h::Run, komorebic.exe move left, , Hide
!j::Run, komorebic.exe move down, , Hide
!k::Run, komorebic.exe move up, , Hide
!l::Run, komorebic.exe move right, , Hide

1::Run, komorebic.exe focus-workspace 0, , Hide
2::Run, komorebic.exe focus-workspace 1, , Hide
3::Run, komorebic.exe focus-workspace 2, , Hide
4::Run, komorebic.exe focus-workspace 3, , Hide
5::Run, komorebic.exe focus-workspace 4, , Hide
6::Run, komorebic.exe focus-workspace 5, , Hide
7::Run, komorebic.exe focus-workspace 6, , Hide
8::Run, komorebic.exe focus-workspace 7, , Hide
9::Run, komorebic.exe focus-workspace 8, , Hide

!1::Run, komorebic.exe move-to-workspace 0, , Hide
!2::Run, komorebic.exe move-to-workspace 1, , Hide
!3::Run, komorebic.exe move-to-workspace 2, , Hide
!4::Run, komorebic.exe move-to-workspace 3, , Hide
!5::Run, komorebic.exe move-to-workspace 4, , Hide
!6::Run, komorebic.exe move-to-workspace 5, , Hide
!7::Run, komorebic.exe move-to-workspace 6, , Hide
!8::Run, komorebic.exe move-to-workspace 7, , Hide
!9::Run, komorebic.exe move-to-workspace 8, , Hide

m::Run, komorebic.exe manage, , Hide
!m::Run, komorebic.exe unmanage, , Hide

t::Run, komorebic.exe toggle-float, , Hide
w::Run, komorebic.exe toggle-monocle, , Hide
tab::Run, komorebic.exe cycle-focus next, , Hide

c::Run, komorebic.exe reload-configuration, , Hide
!q::WinClose A
enter::Run, C:\Users\tahag_science\scoop\apps\wezterm\current\wezterm-gui.exe start --always-new-process
d::Send {LWin}
i::Run, C:\Users\tahag_science\scoop\apps\wezterm\current\wezterm-gui.exe start --always-new-process -- nvim -c "autocmd TextChanged`,TextChangedI <buffer> silent write" %UserProfile%\Documents\Files\vim-temp.md
