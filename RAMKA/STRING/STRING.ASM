;-----------------------------------------------------------------------------
; ENTRY: 	ES:DI -- address of string, AL -- character to find
; ASSUMES:	
; DESTROYS:	CX
; RETURNS:	CX -- position of the character in the string
;-----------------------------------------------------------------------------
myMemchr	proc
		cld 
		xor cx, cx
		dec cx		; max CX
		repne scasb
		neg cx
		ret
		endp

;-----------------------------------------------------------------------------
; ENTRY:	ES:DI -- address of string
; ASSUMES:	
; DESTROYS:	AX, CX
; RETURNS: 	CX -- lenght of the string
;-----------------------------------------------------------------------------
myStrlen	proc
		cld
		xor al, al	; searching null terminator
		call myMemchr
		inc cx
		ret
		endp

;-----------------------------------------------------------------------------
; ENTRY:	ES:DI, ES:SI -- dest, src; CX -- size of blocks
; ASSUMES:	The blocks are not overlaped
; DESTROYS:	CX
;-----------------------------------------------------------------------------
myMemcpy	proc
		cld
		rep movsb
		ret
		endp

;-----------------------------------------------------------------------------
;
;
;
;-----------------------------------------------------------------------------
myStrcpy	proc
		call myStrlen
		call myMemcpy
		ret
		endp

;-----------------------------------------------------------------------------
; ENTRY:	
;
;
;-----------------------------------------------------------------------------
myMemmove	proc
		std
		ret
		endp
