; **********************************************************************
; Copyright (C) 1995 by Holger Veit (Holger.Veit@gmd.de)
; Use at your own risk! No Warranty! The author is not responsible for
; any damage or loss of data caused by proper or improper use of this
; device driver.
;
; 20040221 Slightly modified by Andreas Buchinger. See AB_changes.txt.
; **********************************************************************
	PAGE	80,132
	.286p
	TITLE   fastioa.sys - FASTIO DRIVER
	NAME	fastioa

; **********************************************************************
; Equates
; **********************************************************************
DevHlp_VerifyAccess     EQU     39      ; Verify access to memory
DevHlp_AllocGDTSelector EQU     45      ; Allocate GDT Selectors
DevHlp_FreeGDTSelector  EQU     83      ; Free allocated GDT selector
DevHlp_LinToGDTSelector EQU     92      ; Convert linear address to virtual

DEV_CHAR_DEV		EQU	8000h	; char device flag
DEV_30			EQU	0800h	; can do open/close
DEVLEV_3		EQU	0180h	; has level 3 capabilities

; **********************************************************************
; SEGMENTS
; **********************************************************************

; These are the standard segments
_DATA   segment word public 'DATA'
_DATA   ends
CONST   segment word public 'CONST'
CONST   ends
_BSS	segment word public 'BSS'
_BSS	ends

DGROUP  GROUP   CONST, _BSS, _DATA

_TEXT   segment word public 'CODE'
_TEXT   ends

; **********************************************************************
; Macros
; **********************************************************************

; declares a device driver header
Header macro lbl, next, attr, strat, intr, name, pcs, pds, rcs, rds, cap
	?Header macro f,sz,val
		.errnz ($ - lbl - offset f)
		sz val
	endm
	public  lbl
	lbl	label byte
	?Header SDevNext	dd	<next>
	?Header SDevAtt	 	dw	<attr>
	?Header SDevStrat	dw	<strat>
	?Header SDevInt	 	dw	<intr>
	?Header SDevName	db	<name>
	?Header SDevProtCS	dw	<pcs>
	?Header SDevProtDS	dw	<pds>
	?Header SDevRealCS	dw	<rcs>
	?Header SDevRealDS	dw	<rds>
	?Header SDevCaps	dd	<cap or 0000000000000001b>
	.errnz ($ - lbl - size SysDev3)
endm

_DATA	   segment

; **********************************************************************
; header and attribute of FASTIO$ device
; **********************************************************************
IO_ATTR	equ	DEV_CHAR_DEV or DEV_30 or DEVLEV_3

IoDev	dd	-1		; link to next driver
	dw	IO_ATTR		; attributes
	dw	IOStrat		; strategy entry
	dw	0		; IDC entry
	db	'FASTIOA$'	; device name
	dw	0		; protected mode CS
	dw	0		; protected mode DS
	dw	0		; real mode CS
	dw	0		; real mode DS
	dd	1		; capabilities strip (1= can do shutdown)

; **********************************************************************
; public DATA declarations
; **********************************************************************
		public  _Device_Help
		public	_io_gdt32

		; note the variables beginning with '_' can be visible
		; to a C routine

_Device_Help	dd	0	; 16:16 indirect address of Device Helpers 
_io_gdt32	dw	0	; 32 bit call gate for I/O
gdthelper	dw	0	; helper selector for accessing GDT
gdtsave		dq	0	; save for GDT register
_DATA		ends

; **********************************************************************
; public TEXT routines, called from C code
; **********************************************************************
_TEXT		segment
		assume cs:_TEXT, ds:DGROUP, es:NOTHING, ss:NOTHING

		extrn   _iostrategy:near

		public  __acrtused
		public	IOStrat

; **********************************************************************
; Startup routine for FASTIO driver
; **********************************************************************

IOStrat	proc	far
__acrtused:				; to stop MSC cl from linking crt0.o
		push	es
		push	bx
		call	_iostrategy	; int iostrategy(RP rp)
		pop	bx
		pop	es
		mov	word ptr es:[bx+3], ax	; return status
		ret
IOStrat		endp

; **********************************************************************
; Utility Device helpers
; **********************************************************************

		public  _SegLimit
		public	_Verify
		public	_io_call
		public	_acquire_gdt

		.386p

; int SegLimit(int [bp+4], int* [bp+6])
; put the segment limit of the given selector in arg1 into address arg2
; never fails, returns 0
;
_SegLimit	proc	near
		push	bp
		mov	bp,sp

		push	es			; save regs
		push	bx
		push	di

		mov	ax, word ptr [bp+4]	; get selector
		;lsl	bx, ax			; load segment limit
		db	0fh,03h,0d8h		; circumvent assembler bug
		les	di, dword ptr [bp+6]	; get address
		mov	word ptr es:[di],bx	; store limit
		xor	ax,ax			; return ok

		pop	di
		pop	bx
		pop	es
		pop	bp
		ret
_SegLimit	endp

; int Verify(FPVOID [bp+4], int [bp+8], char [bp+10])
; check whether a segment is accessible, arg1 = base address, arg2 = size,
; arg3 = type (0=R/O, 1=R/W)
; return 0, if sucessful
; return !=0 if error
;
_Verify		proc	near
		assume  cs:_TEXT, ds:DGROUP
		push	bp
		mov	bp,sp
		push	dx			; save regs
		push	cx
		push	di

		mov	di,word ptr [bp+4]	; offset
		mov	ax,word ptr [bp+6]	; selector
		mov	cx,word ptr [bp+8]	; size
		mov	dh,byte ptr [bp+10]	; type of segment (R/O, R/W)
		mov	dl,DevHlp_VerifyAccess
		call	[_Device_Help]		; check memory
		jc	err4			; carry set if error

		xor	ax,ax			; exit ok
		jmp	ok4
err4:		or	ax,1			; exit error
ok4:		pop	di
		pop	cx
		pop	dx
		pop	bp
		ret
_Verify		endp

; int acquire_gdt()
; This routine is the worst hack this driver contains, and you should study
; it, but avoid it under all circumstances.
;
; I expect that this way is the fastest possible way in OS/2 to execute
; R0 code.
;
		.386p
_acquire_gdt	proc	near
		pusha

		mov	ax, word ptr [_io_gdt32]	; get selector
		or	ax,ax
		jnz	aexit				; if we have one, exit
							; else make one
		xor	ax, ax
		mov	word ptr [_io_gdt32], ax	; clear gdt save
		mov	word ptr [gdthelper], ax	; helper

		push	ds
		pop	es				; ES:DI = addr of
		mov	di, offset _io_gdt32		; _io_gdt32
		mov	cx, 2				; two selectors
		mov	dl, DevHlp_AllocGDTSelector	; get GDT selectors
		call	[_Device_Help]
		jc	aexit				; exit if failed

		sgdt	fword ptr [gdtsave]		; access the GDT ptr
		mov	ebx, dword ptr [gdtsave+2]	; get lin addr of GDT
		movzx	eax, word ptr [_io_gdt32]	; build offset into table
		and	eax, 0fffffff8h			; mask away DPL
		add	ebx, eax			; build address

		mov	ax, word ptr [gdthelper]	; sel to map to
		mov	ecx, 08h			; size of a gdt entry
		mov	dl, DevHlp_LinToGDTSelector	
		call	[_Device_Help]
		jc	aexit0				; if failed exit

		mov	ax, word ptr [gdthelper]
		mov	es, ax				; build address to GDT
		xor	bx, bx

		mov	word ptr es:[bx], offset _io_call ; fix address off
		mov	word ptr es:[bx+2], cs		; fix address sel
		mov	word ptr es:[bx+4], 0ec00h	; a r0 386 call gate
		mov	word ptr es:[bx+6], 0000h	; high offset

		mov	dl, DevHlp_FreeGDTSelector	; free gdthelper
		call	[_Device_Help]
		jnc	short aexit

aexit0:		xor	ax,ax				; clear selector
		mov	word ptr [_io_gdt32], ax
aexit:
		popa			; restore all registers
		mov	ax, word ptr [_io_gdt32]
		ret
_acquire_gdt	endp

; This is the entry point to the io handler. In order to make it as
; fast as possible, this is written in assembler with passing data in
; registers
; Calling convention:
; In:
;    DX = port
;    AL,AX,EAX = data when port write
;    BX = function code
; Out:
;    DX = unchanged
;    Al,AX,EAX = return value or unchanged
;    Bx = destroyed
;
		.386p

retfd		macro
		db	066h, 0cbh	; 32 bit return
		endm

_io_call	proc	far
		assume	cs:_TEXT, ds:NOTHING, es:NOTHING
		and	bx,7		; only allow 0-7
		add	bx,bx		; build address
		add	bx,offset iotbl	; add offset
		jmp	cs:[bx]		; indirect jump
iotbl:		dw	iofret
		dw	iof1
		dw	iof2
		dw	iof3
		dw	iof4
		dw	iof5
		dw	iof6
		dw	iofret

; Note: be aware that this code is called via a 386 call gate, so
; the return adresses stored follow the 32 bit convention
; even if the base segment, which this code is in, is a FAR 16:16 segment.
;
iof1:		in	al,dx		; read byte
iofret:		retfd			; NOP exit 
iof2:		in	ax,dx		; read word
		retfd
iof3:		in	eax,dx		; read dword
		retfd
iof4:		out	dx,al		; write byte
		retfd
iof5:		out	dx,ax		; write word
		retfd
iof6:		out	dx,eax		; write dword
		retfd
_io_call	endp

_TEXT		ends
		end
