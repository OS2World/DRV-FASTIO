This is Holger Veits original fastio driver with little modifications. Please
read 'EDM/2 - 32-Bit I/O With Warp Speed' for more information. I need direct
I/O to some ports for a privat project and came across Holgers article in 
EDM/2. I don't like makefiles instead I'm used do work with various IDEs. For
this project I want to use Watcom (now OpenWatcom). As it tooks me some hours 
to get this driver working that way I want it, I think my findings maybe also
usefull for others. So I decided to make my version public.

Changes I made are mainly the Watcom project files but also some modifications
to the driver and the iolib. Please refer to the AB_changes.txt files in the
appropriate directories. If you are using watcom, a double click on the .wpj 
file should open the IDE. Pressing F5 within the IDE after any change to iolib
or example, should rebuild the necessary files. If you are a new programmer, 
try out the debugger. A good debugger is a real time saver. These printf-debug 
junkies out there don't even know what they miss ;-)   

At this time I didn't convert the driver itself to Watcom. It does what it is 
intended for and it makes it really fast. So I had no motivation to find out
the equivalent Watcom switches.

I make this package public by permission of Holger Veit. If you want to contact
me, send a mail to andreas.buchinger@gmx.net. DO NOT MAKE THIS EMAIL ADDRESS 
PUBLIC. DO NOT SEND ME SOME SORT OF ADVERTISING OR SPAM. For using and 
distributing this package see Holgers restrictions in \driver\readme.     

Installation:
-------------
Copy \driver\fastioA.sys somewhere on your disk and include it in your 
config.sys - e.g. Device=D:\OS2\boot\fastioA.sys. After a reboot the example 
FastIOAB.exe should work. 

Last time I struggled with assembler was back in the 8086/80286 days. I don't 
even understand all opcodes Holger used. This is also the first time I did 
some sort of device driver programming. So be warned. WITH THIS DRIVER YOU CAN
CRASH YOUR COMPUTER, DELETE YOUR DATA, OR EVEN DAMAGE SOME PEACES OF HARDWARE. 
USE IT WITH CARE. This driver works for me and it should work on all PC 
compatible hardware running any version of OS/2. I've tested it on eComStation
1.1 with newest kernel (Feb. 2005). Don't make me responsible for any problem 
you have with this software. READ HOLGERS README AND THE EDM/2 ARTICLE.




