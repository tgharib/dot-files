#SingleInstance Force
#NoEnv
SendMode Input

;;;;;;;;;;;;;; Config ;;;;;;;;;;;;;;
Run, komorebic.exe ensure-workspaces 0 6, , Hide ; Ensure there are 6 workspaces created on monitor 0
#Include %A_ScriptDir%\komorebi.generated.ahk

;;;;;;;;;;;;;; Moved focused window in workspace ;;;;;;;;;;;;;;
#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
H::
Run, komorebic.exe move left, , Hide
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
J::
Run, komorebic.exe move down, , Hide
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
K::
Run, komorebic.exe move up, , Hide
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
L::
Run, komorebic.exe move right, , Hide
return

;;;;;;;;;;;;;; Focus window in workspace ;;;;;;;;;;;;;;
#if GetKeyState("F24", "P")
H::
Run, komorebic.exe focus left, , Hide
return

#if GetKeyState("F24", "P")
J::
Run, komorebic.exe focus down, , Hide
return

#if GetKeyState("F24", "P")
K::
Run, komorebic.exe focus up, , Hide
return

#if GetKeyState("F24", "P")
L::
Run, komorebic.exe focus right, , Hide
return

;;;;;;;;;;;;;; Move focused window to workspace ;;;;;;;;;;;;;;
#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
1::
Run, komorebic.exe send-to-workspace 0, , Hide
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
2::
Run, komorebic.exe send-to-workspace 1, , Hide
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
3::
Run, komorebic.exe send-to-workspace 2, , Hide
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
4::
Run, komorebic.exe send-to-workspace 3, , Hide
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
5::
Run, komorebic.exe send-to-workspace 4, , Hide
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
6::
Run, komorebic.exe send-to-workspace 5, , Hide
return

;;;;;;;;;;;;;; Focus workspace ;;;;;;;;;;;;;;
#if GetKeyState("F24", "P")
1::
Run, komorebic.exe focus-workspace 0, , Hide
return

#if GetKeyState("F24", "P")
2::
Run, komorebic.exe focus-workspace 1, , Hide
return

#if GetKeyState("F24", "P")
3::
Run, komorebic.exe focus-workspace 2, , Hide
return

#if GetKeyState("F24", "P")
4::
Run, komorebic.exe focus-workspace 3, , Hide
return

#if GetKeyState("F24", "P")
5::
Run, komorebic.exe focus-workspace 4, , Hide
return

#if GetKeyState("F24", "P")
6::
Run, komorebic.exe focus-workspace 5, , Hide
return

;;;;;;;;;;;;;; Tiling ;;;;;;;;;;;;;;
#if GetKeyState("F24", "P")
X::
Run, komorebic.exe flip-layout horizontal, , Hide
return

#if GetKeyState("F24", "P")
Y::
Run, komorebic.exe flip-layout vertical, , Hide
return

#if GetKeyState("F24", "P")
W::
Run, komorebic.exe toggle-monocle, , Hide
return

#if GetKeyState("F24", "P")
Tab::
Run, komorebic.exe cycle-focus next, , Hide
return

;;;;;;;;;;;;;; Floating / fullscreen ;;;;;;;;;;;;;;
#if GetKeyState("F24", "P")
U::
Run, komorebic.exe resize-axis horizontal increase, , Hide
return

#if GetKeyState("F24", "P")
I::
Run, komorebic.exe resize-axis vertical increase, , Hide
return

#if GetKeyState("F24", "P")
O::
Run, komorebic.exe resize-axis vertical decrease, , Hide
return

#if GetKeyState("F24", "P")
P::
Run, komorebic.exe resize-axis horizontal decrease, , Hide
return

;;;;;;;;;;;;;; Floating / fullscreen ;;;;;;;;;;;;;;
#if GetKeyState("F24", "P")
F::
Run, komorebic.exe toggle-maximize, , Hide
return

#if GetKeyState("F24", "P")
T::
Run, komorebic.exe toggle-float, , Hide
return

;;;;;;;;;;;;;; Misc ;;;;;;;;;;;;;;
#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
Q::
WinClose A
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
Enter::
Run, komorebic.exe promote, , Hide
return

#if GetKeyState("F24", "P")
Enter::
Run, wt, ,
return

#if GetKeyState("F24", "P")
#if GetKeyState("F23", "P")
E::
Run, komorebic.exe stop, , Hide
ExitApp
return

#if GetKeyState("F24", "P")
C::
Run, komorebic.exe retile, , Hide
return

#if GetKeyState("F24", "P")
D::
Send {LWin}
return
