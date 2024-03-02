; -----------------------------------------------------------------------------
; A program accepting password from standart input written for MS-DOS.
; -----------------------------------------------------------------------------
.model tiny
.286
.code
org 100h

start:
	mov ax, 4c00h
	int 21h
	
; -----------------------------------------------------------------------------
; Evaluates hash of a null-terminated string.
; Entry:    AX -- the string address.
; Destroys: 
; Returns:  DX -- hash value. 
; -----------------------------------------------------------------------------
proc hash
	xor dx, dx
	ret
endp

end start
