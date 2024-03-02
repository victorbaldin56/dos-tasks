; -----------------------------------------------------------------------------
; A program accepting password from standart input written for MS-DOS.
; -----------------------------------------------------------------------------
.model tiny
.286
.code
org 100h

locals @@

; -----------------------------------------------------------------------------
;
; -----------------------------------------------------------------------------
REFERENCE_HASH      equ 1013 
BUFFER_SIZE         equ 0ffh
REAL_BUFFER_SIZE    equ 20h

; -----------------------------------------------------------------------------
;
; -----------------------------------------------------------------------------
start:
    mov ah, 09h
    mov dx, offset input_prompt
    int 21h                     ; puts(dx)
    mov ah, 0ah
    mov dx, offset password
    int 21h                     ; gets(dx)
    mov si, dx
    add si, 2

    call hash
    mov ah, 09h
    cmp bx, REFERENCE_HASH    
    jne @@denied

    mov dx, offset success_message
    int 21h

    mov ax, 4c00h
    int 21h

@@denied:
    mov dx, offset failure_message
    int 21h

    mov ax, 4c01h
    int 21h

; -----------------------------------------------------------------------------
; 
; -----------------------------------------------------------------------------
input_prompt    db 'Enter password: $'
password        db BUFFER_SIZE, REAL_BUFFER_SIZE dup(0)
failure_message db 0ah, 'Access denied.', 0ah, ' $'
success_message db 0ah, 'Access granted.', 0ah, ' $'

; -----------------------------------------------------------------------------
; Evaluates hash of a carriage-return-terminated string.
; Entry:    SI -- the string address.
; Destroys: AX, BX 
; -----------------------------------------------------------------------------
hash proc
    xor bx, bx  ; Cleanup
    xor ax, ax
    cld
@@sum:
    lodsb
    cmp al, 0dh
    je @@exit
    add bx, ax
    loop @@sum
@@exit:
    ret
endp

end start
