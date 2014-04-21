/* Copyright (C) 1995 by Holger Veit (Holger.Veit@gmd.de) */
/* Use at your own risk! No Warranty! The author is not responsible for
 * any damage or loss of data caused by proper or improper use of this
 * device driver.
 */

#define INCL_ERRORS
#define INCL_DOS
#include <os2.h>
#include "rp_priv.h"

extern USHORT io_gdt32;
extern void io_call(void);
extern FPFUNCTION Device_Help;
extern char DiscardData;
extern void DiscardProc(void);
extern void SegLimit(USHORT,USHORT far*);
extern int Verify(FPVOID,int,int);
extern void acquire_gdt(void);

/*
 * io_init:
 *   just print a startup message and set the segment sizes
 *
 */
char start_msg[] = "\r\nFASTIOA$(EDM/2) Copyright (C)1995 by Holger Veit and AB\r\n";

static int io_init(RP rp)
{
	Device_Help = rp->pk.init.devhlp;

#define GETSEL(ptr) ((USHORT)(((ULONG)((void far*)ptr)>>16)&0xffff))
	SegLimit(GETSEL(DiscardProc),&rp->pk.initexit.cs);
	SegLimit(GETSEL(&DiscardData),&rp->pk.initexit.ds);

	DosPutMessage(1,sizeof(start_msg),start_msg);
	return RPDONE;
}

/*
 * io_ioctl:
 *   process the supported ioctls
 */
#define FASTIO_IO	0x76
#define IO_GETSEL32	0x60

static int io_ioctl(RP rp)
{
	USHORT far *d = IODATA(rp);
  
	/* only accept class FASTIO_IO */
	if (IOCAT(rp) != FASTIO_IO)
		return RP_EINVAL;

	switch (IOFUNC(rp)) {
	case IO_GETSEL32:
		if (Verify(d,sizeof(USHORT),1) == 0 && io_gdt32) {
			*d = io_gdt32;
			return RPDONE;
		}
		break;
	}

	/* break from case */
	return RP_EINVAL;
}

/*
 * Open routine
 */
int io_open(void)
{
	return acquire_gdt() ? RPDONE : RP_EGEN;
}

/*
 * io_strategy:
 *   open, close always succeed, I/O always fail, ioctl performs a function
 */
int iostrategy(RP rp)
{
	switch (rp->rp_cmd) {
	case CMDInit:
		return io_init(rp);
	case CMDClose:
		return RPDONE;
	case CMDOpen:
		return io_open();
	case CMDShutdown:
		return RPDONE;
	case CMDGenIOCTL:
		return io_ioctl(rp);
	default:
		return RP_EBAD;
	}	
}

/* NO MORE PROCEDURES BELOW THIS POINT! */
void DiscardProc(void) {}

/* NO MORE DATA DECLARATIONS BELOW THIS POINT! */
char DiscardData = 0;

