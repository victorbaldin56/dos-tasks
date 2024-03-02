; =============================================================================
; A resident programm for DOS, draws a frame with register values.
;
; Copyright (C) Victor Baldin, 2024.
; =============================================================================
.model tiny
.286

VMEM            equ 0b800h
KYBPORT         equ 60h
HOTKEY          equ 2          ; F1
FRAME_WIDGHT    equ 9d
FRAME_HIGH      equ 15d
SCREEN_WIDGHT   equ 80d
WHITE_ATTRIBUTE equ 70h
INITIAL_POS     equ 2 * (SCREEN_WIDGHT - FRAME_WIDGHT)

locals @@

.code
org 100h

start:          call rewriteInts
                ;call drawFrame

                mov ax, 3100h
                mov dx, offset eop
                shr dx, 4
                inc dx
                int 21h

active          db 0

; =============================================================================
;
;
; =============================================================================
rewriteInts     proc
                push ax bx es 

                mov ax, 3509h       ; Get INT vector
                int 21h
                mov old09Ofs, bx
                mov bx, es
                mov old09Seg, bx
                push 0
                pop es
                mov bx, 4 * 9h

                cli
                mov es:[bx], offset keyboardHandler
                mov es:[bx + 2], cs ; INT segment
                sti
                
                mov ax, 3508h
                int 21h
                mov old08Ofs, bx
                mov bx, es 
                mov old08Seg, bx
                push 0
                pop es
                mov bx, 4 * 08h
                
                cli
                mov es:[bx], offset timerHandler
                mov es:[bx + 2], cs
                sti
               
                pop es bx ax
                ret
                endp

MY_PUSHA        macro
                push ax bx cx dx di si bp sp ds es ss
                endm

MY_POPA         macro
                pop ss es ds sp bp si di dx cx bx ax
                endm

; =============================================================================
; Timer interrupt handler. 
; =============================================================================
timerHandler    proc
                MY_PUSHA
                mov bp, sp
 
                cmp cs:active, 1
                jne @@exit
                call drawFrame

@@exit:         MY_POPA
 
                db 0eah                 ; far jmp to original 08h
old08Ofs        dw 0
old08Seg        dw 0
                endp

; =============================================================================
; ENTRY:
; ASSUMES:
; 
; =============================================================================
keyboardHandler proc 
                pusha

                in al, 60h

                cmp al, HOTKEY ; 1
                jne @@exit
                mov cs:active, 1
        
@@exit:         popa
                db 0eah
old09Ofs        dw 0
old09Seg        dw 0
                endp

BREAK_LINE      macro
                add di, 2 * (SCREEN_WIDGHT - FRAME_WIDGHT) 
                endm

DRAW_HORIZONTAL macro
                mov al, [si + 4]
                mov cx, FRAME_WIDGHT - 2
                rep stosw
                endm

; =============================================================================
;
; DESTROYS: AX
; =============================================================================
drawFrame       proc
                push VMEM
                pop es          ; Sets ES to VMEM.

                push cs
                pop ds

                mov di, INITIAL_POS     ; Starting point
                mov si, offset template
                mov al, [si]
                mov ah, WHITE_ATTRIBUTE ; 70h
                stosw
                DRAW_HORIZONTAL
                mov al, [si + 1]
                stosw

                BREAK_LINE
                call printRegisters
                
                mov al, [si + 2]
                stosw
                DRAW_HORIZONTAL
                mov al, [si + 3]
                stosw

                ret
                endp

template        db 0c9h, 0bbh, 0c8h, 0bch, 0cdh, 0bah

NUM_GEN_REGS    equ 11 ; All registers except CS & IP
NUM_REGS        equ 13 ; All registers

; =============================================================================
; 
; 
; =============================================================================
printRegisters  proc
                push bx si 
                mov cx, NUM_REGS
                mov bl, [si + 5]
                mov si, offset registerNames

@@print:        push cx
                push cx
                mov al, bl
                stosw                
                mov cx, 2       ; Register name lenght

@@printSingle:  mov al, [si]
                inc si
                stosw
                loop @@printSingle

                mov al, '='
                stosw
                
                pop cx
                push si
                cmp cx, 2
                jge @@genRegs 
                mov si, cx   ; To obtain CS & IP
                add si, NUM_GEN_REGS
                jmp @@getOffs

@@genRegs:      mov si, cx
                sub si, 1 + (NUM_REGS - NUM_GEN_REGS)
@@getOffs:      shl si, 1
                mov dx, [bp + si]
                call printHex

                mov al, bl
                stosw
                BREAK_LINE
                pop si
                pop cx
                loop @@print        

                pop si bx
                ret
                endp

HEXMASK         equ 000fh

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

; =============================================================================
;
; =============================================================================
printHexDigit   proc
                cmp dx, 0ah
                jl @@digit
                jmp @@letter
@@digit:        add dx, '0'
                mov al, dl
                stosw
                ret
@@letter:       add dx, 'a' - 0ah
                mov al, dl
                stosw
                ret
                endp
registerNames   db 'ax', 'bx', 'cx', 'dx', 'di', 'si', 'bp', 'sp'
                db 'ds', 'es', 'ss', 'ip', 'cs'

eop:

end start
