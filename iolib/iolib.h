/* Copyright (C) 1995 by Holger Veit (Holger.Veit@gmd.de) */
/* Use at your own risk! No Warranty! The author is not responsible for
 * any damage or loss of data caused by proper or improper use of this
 * device driver or related software
 */

#ifndef _IOLIB_H_
#define _IOLIB_H_

extern int io_init(void);

extern char c_inb(short port);
extern short c_inw(short port);
extern long c_inl(short port);
extern void c_outb(short port, char data);
extern void c_outw(short port,short data);
extern void c_outl(short port,long data);

#endif
