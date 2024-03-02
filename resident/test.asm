; =============================================================================
; A test programm for resident.
;
; Copyright (C) Victor Baldin, 2024.
; =============================================================================
.model tiny
.286
.code
org 100h

HOTKEY          equ 1

start:          mov bx, 1111h
                mov di, 3333h
                mov si, 4444h
                mov dx, cs
                call printHex 

scan:           in al, 60h
                cmp al, HOTKEY
                je exit
                jmp scan

exit:           mov ax, 4c00h
                int 21h

; ============================================================================
; ENTRY: DX -- A number to print.
; ============================================================================
printHex        proc

                mov cx, 04h     ; Number of hex digits in word.
@@printDigits:  push cx dx
                dec cx
                shl cx, 2       ; Get offset 
                shr dx, cl
                and dx, HEXMASK ; Now DX is equal to desired hex digit.
                call printHexDigit
                pop dx cx 
                loop @@printDigits

                ret
                endp

HEXMASK         equ 000fh

; =============================================================================
;
; =============================================================================
printHexDigit   proc
                cmp dx, 0ah
                mov ah, 02h
                jl @@digit
                jmp @@letter

@@digit:        add dl, '0'
                int 21h
                ret
@@letter:       add dl, 'a' - 0ah
                int 21h
                ret
                endp

end start
