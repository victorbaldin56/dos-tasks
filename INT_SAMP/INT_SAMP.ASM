.286
.model tiny
.code
org 100h

start:		mov ax, 3509h	;
		int 21h		
		mov Old09fs, bx
		push bx, es
		mov Old09Seg, bx

		push 0
		pop es
		mov bx, 4 * 09h
		cli
		mov es:[bx], offset keyboardInt
		sti
		push cs
		pop ax
		mov es:[bx + 2], ax

		mov ax, 3100h	; TSR
		mov dx, offset eop 
		shr dx, 4
		inc dx
		int 21h
		
keyboardInt	proc
		push ax bx cx	; tasm macro

		push 0b800h
		pop es
		mov bx, (80 * 5 + 40) / 2
		mov ah, 4eh
		
		in al, 61h 	; blink hi bit in kybd cntrlr cmd port
		or al, 80h
		out 61h, al
		and al, not 80h
		out 61h, al

		mov al, 20h
		out 20h, al
		pop es bx ax

		db 0eah		; JMP FAR
Old090fs	dw 0
Old09Seg	dw 0

		iret
		endp

eop:

end start