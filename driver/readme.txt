This directory:
---------------
This directory contains the driver source code for the fastio driver.
You need Microsoft C 5.1 (which I used) or 6.0 to rebuild it.

A precompiled version, FASTIO.SYS, together with a SYM file for the kernel 
debugger is also present.

Installation:
-------------
You could install this driver with the function 'install device driver' from
the system configuration folder. However, it is much easier to copy the 
FASTIO.SYS file directly to the \OS2\BOOT directory on your boot drive,
add the line

	DEVICE=bootdriveletter:\OS2\BOOT\FASTIO.SYS

to your config.sys file. If you want to debug the driver with the kernel
debugger, don't forget to copy the FASTIO.SYM file into the same directory.
This is not required for normal usage.

Note for programmers:
---------------------
The driver provides a 32 bit R3->R0 call gate for a user process. This means
that 
1. You cannot use this entry point from 16 bit software. The system will
   crash in such a case. Use the traditional IOPL segment for 16 bit code.
   There is no real benefit to extend the driver to return an additional
   16 bit call gate.
2. The I/O is done at ring 0 level, rather than ring 2, as with an IOPL
   segment. This means, that an additional protection has been taken away.
   In ring 2 the processor checks an I/O permission table and issues an
   exception if you try to access certain ports (like DMA or IRQ controller
   registers). This driver does not have this protection any longer, so
   you can crash the system severely by improper use. Don't play with this.
You have been warned!

Note for commercial users:
--------------------------
You are permitted to use this driver with your product and ship a binary
copy of it with your software, provided the copyright message displayed
on bootup is preserved (you may also ship the source code, if you like,
but you are not forced to do this).

You may also add your own features or modify it to suit your own requirements
as long as the binary still contains the machine readable copyright message
pointing out the original authorship (you are then no longer forced to
print it on the screen). However, in any case of modification to this code,
you are requested to change the name of the driver to a different one
than 'FASTIO$' to avoid future confusion.

FASTIO$ is part of a larger driver which is released some time in the future
to suit a certain purpose. Therefore, you are urged not to change the
provided mechanism of interfacing (indirect call via a single call gate, with
specific function codes in BX), since you then can profit from the larger 
driver.


Last but not least: note the following disclaimer (everyone):
-------------------------------------------------------------
This code comes without any warranty! Use it at your own risk! Neither the
author nor keepers of archives where you might have found this code or
publishers of the EDM/2 journal are responsible for any damage of hardware
or software, loss of profit, and other problem resulting from proper or 
improper use of this or its accompanying code.

