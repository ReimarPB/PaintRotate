#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^+R::
SetTitleMatchMode, 2
#IfWinActive Paint

; Prompt user for rotation angle
InputBox, Angle, Rotation, Rotate by (degrees):, , 200, 130
if ErrorLevel
	Return

; Error handling
if (!Angle is number) {
	MsgBox, That is not a number
	Return
}
if (Abs(Angle) > 179) {
	MsgBox, Rotation Angle must be between -179 and 179
	Return
}

; Calculate skewing values
PI = 3.14159265358979323

HorizontalSkew := Floor(Abs(Angle) / 2)
VerticalSkew := Floor(ATan(Sin(Abs(Angle) * PI / 180)) * 180 / PI)

if (Angle <= 0)
	HorizontalSkew := 0 - HorizontalSkew
else
	VerticalSkew := 0 - VerticalSkew

; Insert them into Paint
; (Clipboard is used because of a bug in some versions of Paint that doesn't let you type negative numbers)
OldClipboard := Clipboard

Clipboard := HorizontalSkew
Send, ^w{Tab}{Tab}{Tab}{Tab}^v{Tab}
Sleep, 100

Clipboard := VerticalSkew
Send, ^v{Enter}
Sleep, 100

Clipboard := HorizontalSkew
Send, ^w{Tab}{Tab}{Tab}{Tab}^v{Enter}
Sleep, 100

Clipboard := OldClipboard

Return
