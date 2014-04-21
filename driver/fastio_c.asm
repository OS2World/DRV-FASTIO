;	Static Name Aliases
;
	TITLE   fastio_c.c
	NAME    fastio_c

	.286p
	.287
_TEXT	SEGMENT  WORD PUBLIC 'CODE'
_TEXT	ENDS
_DATA	SEGMENT  WORD PUBLIC 'DATA'
_DATA	ENDS
CONST	SEGMENT  WORD PUBLIC 'CONST'
CONST	ENDS
_BSS	SEGMENT  WORD PUBLIC 'BSS'
_BSS	ENDS
DGROUP	GROUP	CONST, _BSS, _DATA
	ASSUME  CS: _TEXT, DS: DGROUP, SS: DGROUP
PUBLIC  _DiscardData
PUBLIC  _start_msg
EXTRN	__acrtused:ABS
EXTRN	_SegLimit:NEAR
EXTRN	_Verify:NEAR
EXTRN	_acquire_gdt:NEAR
EXTRN	DOS16PUTMESSAGE:FAR
EXTRN	_io_gdt32:WORD
EXTRN	_Device_Help:DWORD
_DATA      SEGMENT
_start_msg	DB	0dH,  0aH, 'FASTIOA$(EDM/2) Copyright(C)1995 by Holger Veit '
	DB	'and AB',  0dH,  0aH,  00H
_DiscardData	DB	00H
_DATA      ENDS
_TEXT      SEGMENT
	ASSUME	CS: _TEXT
; Line 2089
; Line 4259
; Line 2281
; Line 247
; Line 29
io_init	PROC NEAR
	enter	WORD PTR 0,0
;	rp = 4
; Line 30
	les	bx,DWORD PTR [bp+4]	;rp
	mov	ax,WORD PTR es:[bx+14]
	mov	dx,WORD PTR es:[bx+16]
	mov	WORD PTR _Device_Help,ax
	mov	WORD PTR _Device_Help+2,dx
; Line 33
	mov	ax,bx
	mov	dx,es
	add	ax,14
	push	dx
	push	ax
	mov	dx,cs
	mov	ax,dx
	push	ax
	call	_SegLimit
	add	sp,6
; Line 34
	mov	ax,WORD PTR [bp+4]	;rp
	mov	dx,WORD PTR [bp+6]
	add	ax,16
	push	dx
	push	ax
	mov	dx,ds
	mov	ax,dx
	push	ax
	call	_SegLimit
	add	sp,6
; Line 36
	push	1
	push	59
	push	ds
	push	OFFSET DGROUP:_start_msg
	call	FAR PTR DOS16PUTMESSAGE
; Line 37
	mov	ax,256
	leave	
	ret	

io_init	ENDP
; Line 48
io_ioctl	PROC NEAR
	enter	WORD PTR 4,0
;	rp = 4
;	d = -4
; Line 49
	les	bx,DWORD PTR [bp+4]	;rp
	mov	ax,WORD PTR es:[bx+19]
	mov	dx,WORD PTR es:[bx+21]
	mov	WORD PTR [bp-4],ax	;d
	mov	WORD PTR [bp-2],dx
; Line 52
	cmp	BYTE PTR es:[bx+13],118
	je	$I2204
; Line 53
$L20002:
	mov	ax,-32493
	leave	
	ret	
	nop	
$I2204:
	les	bx,DWORD PTR [bp+4]	;rp
	mov	al,BYTE PTR es:[bx+14]
	sub	ah,ah
	cmp	ax,96
	jne	$L20002
; Line 57
	push	1
	push	2
	push	WORD PTR [bp-2]
	push	WORD PTR [bp-4]	;d
	call	_Verify
	add	sp,8
	or	ax,ax
	jne	$L20002
	cmp	WORD PTR _io_gdt32,0
	je	$L20002
; Line 58
	les	bx,DWORD PTR [bp-4]	;d
	mov	ax,_io_gdt32
	mov	WORD PTR es:[bx],ax
; Line 59
	mov	ax,256
	leave	
	ret	
	nop	

io_ioctl	ENDP
; Line 72
	PUBLIC	_io_open
_io_open	PROC NEAR
; Line 73
	call	_acquire_gdt
	or	ax,ax
	je	$L20000
	mov	ax,256
	ret	
	nop	
$L20000:
	mov	ax,-32500
	ret	

_io_open	ENDP
; Line 81
	PUBLIC	_iostrategy
_iostrategy	PROC NEAR
	enter	WORD PTR 0,0
;	rp = 4
; Line 82
	les	bx,DWORD PTR [bp+4]	;rp
	mov	al,BYTE PTR es:[bx+2]
	sub	ah,ah
	or	ax,ax
	je	$SC2220
	cmp	ax,13
	je	$SC2222
	cmp	ax,14
	je	$SC2221
	cmp	ax,16
	je	$SC2224
	cmp	ax,28
	je	$SC2221
; Line 94
	mov	ax,-32509
	leave	
	ret	
$SC2220:
; Line 84
	push	es
	push	bx
	call	io_init
$L20003:
	add	sp,4
	leave	
	ret	
$SC2222:
; Line 88
	call	_io_open
	leave	
	ret	
	nop	
$SC2221:
; Line 86
	mov	ax,256
	leave	
	ret	
	nop	
$SC2224:
; Line 92
	push	WORD PTR [bp+6]
	push	WORD PTR [bp+4]	;rp
	call	io_ioctl
	jmp	SHORT $L20003
	nop	

_iostrategy	ENDP
; Line 99
	PUBLIC	_DiscardProc
_DiscardProc	PROC NEAR
	ret	
	nop	

_DiscardProc	ENDP
_TEXT	ENDS
END
