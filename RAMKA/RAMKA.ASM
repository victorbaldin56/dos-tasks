.model tiny
.286
.code
org 100h

.FrameBegin	equ 19
.FrameWidght	equ 60
.FullWidght	equ 160
.FrameHigh	equ 3

.BreakLine	macro
		add di, .FullWidght - 2 * .FrameWidght + 1
		endm

start:		cld				; For stosw, etc		
		mov bx, 0b800h
		mov es, bx			; Using ES for video mem
		mov di, .FrameBegin + .FullWidght * 4
		call drawRectangle
		mov si, 82h
		mov bl, byte ptr [si]
		xor bh, bh
		sub bl, '0'
		cmp bl, 0
		je userStyle
		dec bx
		mov ax, 6			; Size of template string
		mul bx
		mov bx, ax
		mov ax, offset frameTemplates
		add bx, ax
		mov si, bx
startFrame:	dec di				; Going to write text
		call drawFrame
		call insertText
		mov ax, 4c00h
		int 21h

userStyle:	mov si, 84h
		jmp startFrame

;-----------------------------------------------------------------------------
; ENTRY:	DI -- the starting point of the rectangle
; ASSUMES:		
; DESTROYS:	CX
;-----------------------------------------------------------------------------	
drawRectangle	proc
		mov ax, 0070h			; White background
		push di
		
setBackground:	mov cx, .FrameWidght 
		push di
		rep stosw
		pop di
		cmp di, .FrameBegin + .FullWidght * 6
		je rectangleRet
		add di, .FullWidght
		jmp setBackground

rectangleRet:	pop di
		ret
		endp	

;-----------------------------------------------------------------------------
; ENTRY:	SI -- template string for the frame
; ASSUMES:
; DESTROYS:	SI
;-----------------------------------------------------------------------------
drawFrame	proc
		push di	
		mov ax, 0070h
		movsb				; Top left corner
		mov ah, [si + 3]		; Horizontal line character
		mov cx, .FrameWidght - 1	; Horizontal line widght
		push cx
		rep stosw
		dec di
		movsb				; Top right corner
		mov ah, [si + 1]
		.BreakLine
		call drawVertical
		dec di
		movsb				; Bottom left corner
		inc di
		pop cx
		mov al, [si + 1]
		dec cx
		rep stosw			; Bottom
		movsb				; Bottom right corner
		pop di
		ret
		endp

;-----------------------------------------------------------------------------
; ENTRY: 	SI -- template string for the frame
; ASSUMES:	
; DESTROYS:	SI
;-----------------------------------------------------------------------------
drawVertical	proc
		mov al, [si + 3]		; Vertical line character
		mov ah, 70h

startVertical:	stosw
		add di, 2 * .FrameWidght - 4
		stosw
		.BreakLine
		cmp di, .FullWidght * (.FrameHigh - 1) + .FrameBegin
		jge endVertical
		jmp startVertical

endVertical:	ret
		endp

include string\string.asm

;------------------------------------------------------------------------------
; ENTRY: 	DI -- the start of the frame
; ASSUMES:	
; DESTROYS:	BX, CX, SI 
;------------------------------------------------------------------------------
insertText	proc
		add di, .FullWidght
		mov bx, 80h			; Lenght of argv
		mov cl, byte ptr [bx]
		sub cl, 3
		xor ch, ch
		mov bx, cx
		sub bx, .FrameWidght + 1
		neg bx
		add di, bx			; To start user's string
		and bx, 01h
		add di, bx
		mov si, 84h
writeString:	movsb
		inc di
		loop writeString		
		ret
		endp

; Template string format: top left, top right, bottom right, bottom left, 
;			  horizontal, vertical
frameTemplates	db '++++-|'
		db 0c9h, 0bbh, 0c8h, 0bch, 0cdh, 0bah
		db 03h, 03h, 03h, 03h, 03h, 03h

end start
