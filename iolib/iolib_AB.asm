; Copyright (C) 1995 by Holger Veit (Holger.Veit@gmd.de)
;
; Use at your own risk! No Warranty! The author is not responsible for
; any damage or loss of data caused by proper or improper use of this
; device driver or related software.
;
; This file contains the FASTIO API for the MASM assembler (6.0)

;	TITLE	FASTIOA$ USER INTERFACE
	NAME	IOLIB

	.386

TEXT32	SEGMENT	DWORD PUBLIC 'CODE'
TEXT32	ENDS

BSS32	SEGMENT	DWORD PUBLIC 'BSS'
BSS32	ENDS


; global data used

	PUBLIC	ioentry	; public only for assembler code
BSS32	SEGMENT
ioentry	DD	0	; used for the indirect call
gdt	DW	0
BSS32	ENDS

TEXT32	SEGMENT
	ALIGN	4

	ASSUME	CS:FLAT, DS:FLAT

; performs fast output of a byte to an I/O port 
; this routine is intended to be called from gcc C code
;
; Calling convention:
;	void c_outb(short port,char data)
;
;
	PUBLIC	_c_outb
	PUBLIC	c_outb
_c_outb	PROC
c_outb:
	PUSH	EBP
	MOV	EBP, ESP		; set standard stack frame
	PUSH	EBX			; save register
	MOV	DX, WORD PTR [EBP+8]	; get port
	MOV	AL, BYTE PTR [EBP+12]	; get data
	MOV	BX, 4			; function code 4 = write byte
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore bx
	POP	EBP			; return
	RET
	ALIGN	4
_c_outb	ENDP

; performs fast output of a word to an I/O port 
; this routine is intended to be called from gcc C code
;
; Calling convention:
;	void c_outw(short port,short data)
;
;
	PUBLIC	_c_outw
	PUBLIC	c_outw
_c_outw	PROC
c_outw:
	PUSH	EBP
	MOV	EBP, ESP		; set standard stack frame
	PUSH	EBX			; save register
	MOV	DX, WORD PTR [EBP+8]	; get port
	MOV	AX, WORD PTR [EBP+12]	; get data
	MOV	BX, 5			; function code 5 = write word
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore bx
	POP	EBP			; return
	RET
	ALIGN	4
_c_outw	ENDP

; performs fast output of a longword to an I/O port 
; this routine is intended to be called from gcc C code
;
; Calling convention:
;	void c_outl(short port,long data)
;
;
	PUBLIC	_c_outl
	PUBLIC	c_outl
_c_outl	PROC
c_outl:
	PUSH	EBP
	MOV	EBP, ESP		; set standard stack frame
	PUSH	EBX			; save register
	MOV	DX, WORD PTR [EBP+8]	; get port
	MOV	EAX, DWORD PTR [EBP+12]	; get data
	MOV	BX, 6			; function code 6 = write longword
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore bx
	POP	EBP			; return
	RET
	ALIGN	4
_c_outl	ENDP

; performs fast input of a byte from an I/O port 
; this routine is intended to be called from gcc C code
;
; Calling convention:
;	char c_inb(short port)
;
;
	PUBLIC	_c_inb
	PUBLIC	c_inb
_c_inb	PROC
c_inb:
	PUSH	EBP
	MOV	EBP, ESP		; set standard stack frame
	PUSH	EBX			; save register
	MOV	DX, WORD PTR [EBP+8]	; get port
	MOV	BX, 1			; function code 1 = read byte
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	AND	EAX, 0FFH		; mask out required byte
	POP	EBX			; restore register
	POP	EBP			; return
	RET
	ALIGN	4
_c_inb	ENDP

; performs fast input of a word from an I/O port 
; this routine is intended to be called from gcc C code
;
; Calling convention:
;	short c_inw(short port)
;
;
	PUBLIC	_c_inw
	PUBLIC	c_inw
_c_inw	PROC
c_inw:
	PUSH	EBP
	MOV	EBP, ESP		; set standard stack frame
	PUSH	EBX			; save register
	MOV	DX, WORD PTR [EBP+8]	; get port
	MOV	BX, 2			; function code 2 = read word
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	AND	EAX, 0FFFFH		; mask out word
	POP	EBX			; restore register
	POP	EBP			; return
	RET
	ALIGN	4
_c_inw	ENDP

; performs fast input of a longword from an I/O port 
; this routine is intended to be called from gcc C code
;
; Calling convention:
;	lomg c_inl(short port)
;
;
	PUBLIC	_c_inl
	PUBLIC	c_inl
_c_inl	PROC
c_inl:
	PUSH	EBP
	MOV	EBP, ESP		; set standard stack frame
	PUSH	EBX			; save register
	MOV	DX, WORD PTR [EBP+8]	; get port
	MOV	BX, 3			; function code 3 = read longword
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore register
	POP	EBP			; return
	RET
	ALIGN	4
_c_inl	ENDP

;------------------------------------------------------------------------------

; performs fast output of a byte to an I/O port 
; this routine is intended to be called from gas assembler code
; note there is no stack frame, however 8 byte stack space is required
;
; calling convention:
;	MOV	DX, portnr
;	MOV	AL, data
;	CALL	a_outb
;
;
	PUBLIC	a_outb
a_outb	PROC
	PUSH	EBX			; save register
	MOV	BX, 4			; function code 4 = write byte
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore bx
	RET
	ALIGN	4
a_outb	ENDP

; performs fast output of a word to an I/O port 
; this routine is intended to be called from gas assembler code
; note there is no stack frame, however 8 byte stack space is required
;
; calling convention:
;	MOV	DX, portnr
;	MOV	AX, data
;	CALL	a_outw
;
;
	PUBLIC	a_outw
a_outw	PROC
	PUSH	EBX			; save register
	MOV	BX, 5			; function code 5 = write word
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore bx
	RET
	ALIGN	4
a_outw	ENDP

; performs fast output of a longword to an I/O port 
; this routine is intended to be called from gas assembler code
; note there is no stack frame, however 8 byte stack space is required
;
; calling convention:
;	MOV	DX, portnr
;	MOV	EAX, data
;	CALL	a_outl
;
;
	PUBLIC	a_outl
a_outl	PROC
	PUSH	EBX			; save register
	MOV	BX, 6			; function code 6 = write longword
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore bx
	RET
	ALIGN	4
a_outl	ENDP

; performs fast input of a byte from an I/O port 
; this routine is intended to be called from gas assembler code
; note there is no stack frame, however 8 byte stack space is required
;
; calling convention:
;	MOV	DX, portnr
;	CALL	a_inb
;	;data in AL
;
	PUBLIC a_inb
a_inb	PROC
	PUSH	EBX			; save register
	MOV	BX, 1			; function code 1 = read byte
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore register
	POP	EBP			; return
	RET
	ALIGN	4
a_inb	ENDP

; performs fast input of a word from an I/O port 
; this routine is intended to be called from gas assembler code
; note there is no stack frame, however 8 byte stack space is required
;
; calling convention:
;	MOV	DX, portnr
;	CALL	a_inw
;	;data in AX
;
	PUBLIC a_inw
a_inw	PROC
	PUSH	EBX			; save register
	MOV	BX, 2			; function code 2 = read word
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore register
	POP	EBP			; return
	RET
	ALIGN	4
a_inw	ENDP

; performs fast input of a longword from an I/O port 
; this routine is intended to be called from gas assembler code
; note there is no stack frame, however 8 byte stack space is required
;
; calling convention:
;	MOV	DX, portnr
;	CALL	a_inl
;	;data in EAX
;
	PUBLIC a_inl
a_inl	PROC
	PUSH	EBX			; save register
	MOV	BX, 3			; function code 3 = read byte
	CALL	FWORD PTR [ioentry]	; call intersegment indirect 16:32
	POP	EBX			; restore register
	POP	EBP			; return
	RET
	ALIGN	4
a_inl	ENDP

;------------------------------------------------------------------------------

; Initialize I/O access via the driver. 
; You *must* call this routine once for each executable that wants to do
; I/O.
;
; The routine is mainly equivalent to a C routine performing the 
; following (but no need to add another file):
;	DosOpen("/dev/fastio$", read, nonexclusive)
;	DosDevIOCtl(device, XFREE86_IO, IO_GETSEL32)
;	selector -> ioentry+4
;	DosClose(device)
;
; Calling convention:
;	int io_init(void)
; Return:
;	0 if successful
;	standard APIRET return code if error
;
	EXTRN	DosOpen:PROC
	EXTRN	DosDevIOCtl:PROC
	EXTRN	DosClose:PROC

	PUBLIC	_io_init
	PUBLIC	io_init
_io_init	PROC
io_init:
	PUSH	EBP
	MOV	EBP, ESP		; standard stack frame
	ADD	ESP, -16		; reserve memory
					; -16 = len arg of DosDevIOCtl
					; -12 = action arg of DosOpen
					; -8 = fd arg of DosOpen
					; -2 = short GDT selector arg
	PUSH	0			; (PEAOP2)NULL
	PUSH	66			; OPEN_ACCESS_READWRITE|OPEN_SHARE_DENYNONE
	PUSH	1			; FILE_OPEN
	PUSH	0			; FILE_NORMAL
	PUSH	0			; initial size
	LEA	EAX, DWORD PTR [EBP-12]	; Adress of 'action' arg
	PUSH	EAX
	LEA	EAX, WORD PTR [EBP-8]	; Address of 'fd' arg
	PUSH	EAX
	PUSH	OFFSET devname
	CALL	DosOpen		; call DosOpen
	ADD	ESP, 32			; cleanup stack frame 
	CMP	EAX, 0			; is return code zero?
	JE	goon			; yes, proceed
	ADD ESP, 16         ; Added by AB (20050223)
	POP	EBP				; no return error
	RET
devname:
;	DB	"/dev/fastioab$",0           ; Dosn't work. Probably because name is more than 8 characters 
	DB	"/dev/fastioa$",0
	ALIGN	4
goon:
	LEA	EAX, DWORD PTR [EBP-16]	; address of 'len' arg of DosDevIOCtl
	PUSH	EAX
	PUSH	2			; sizeof(short)
	LEA	EAX, DWORD PTR [EBP-2]	; address to return the GDT selector
	PUSH	EAX
	PUSH	0			; no parameter len
	PUSH	0			; no parameter size
	PUSH	0			; no parameter address
	PUSH	96			; function code IO_GETSEL32
	PUSH	118			; category code XFREE6_IO
	MOV	EAX, DWORD PTR [EBP-8]	; file handle
	PUSH	EAX
	CALL	DosDevIOCtl		; perform ioctl
	ADD	ESP, 36			; cleanup stack
	CMP	EAX, 0			; is return code = 0?
	JE	ok			; yes, proceed
	PUSH	EAX			; was error, save error code
	MOV	EAX, DWORD PTR [EBP-8]	; file handle
	PUSH	EAX
	CALL	DosClose		; close device
	ADD	ESP, 20			; clean stack, changed from 4 by AB (20050307)
	POP	EAX			; get error code
	POP	EBP			; return error
	RET
	ALIGN	4
ok:
	MOV	EAX, DWORD PTR [EBP-8]	; file handle
	PUSH	EAX			; do normal close
	CALL	DosClose
	ADD	ESP, 20			; clean stack, changed from 4 by AB (20050307)

	MOV	AX, WORD PTR [EBP-2]	; load gdt selector
	MOV	WORD PTR [gdt], AX	; store in ioentry address selector part
	XOR	EAX, EAX		; eax = 0
	MOV	DWORD PTR [ioentry], EAX	; clear ioentry offset part
					; return code = 0 (in EAX)
	POP	EBP			; clean stack frame
	RET				; exit
_io_init	ENDP

TEXT32	ENDS

	END
