.model tiny
.code
.286
org 100h

start:	mov ah, 9h	; DOS FN -- PRINT STRING
	mov dx, offset meow
	int 21h 	; PUTS(DX)
	mov ax, 4c00h
	int 21h 	; TERMINATES

meow	db 'MMMMMMMMMMEEEEEEEEEEOOOOOOOOOOWWWWWWWWW', 0dh, 0ah, '$'

end start
