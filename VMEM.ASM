.model tiny
.286
.code
org 100h

; TEXT MODE
start:		mov bx, 0b800h
		mov es, bx
		
		mov bx, (5 * 80 + 80 / 2) * 2
		mov byte ptr es:[bx], 'A'
		
		; 7654 3210
		; Bbbb ffff
		;  rgb irgb
		;      1100
		;      0100
		;      1110

		mov byte ptr es:[bx+1], 4eh

		mov ax, 4c00h
		int 21h 	; TERMINATES	

end 		start
