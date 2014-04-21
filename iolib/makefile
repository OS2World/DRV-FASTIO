
# Set the path of tools, if necessary
LIB = f:\ddkx86\tools\lib
MASM= f:\tools\os2\masm
AS = d:\emx\bin\as
AR = d:\emx\bin\ar


# Targets:	make iolib.lib
#		make iolib.a
#		make clean	

iolib.lib: iolib.obj
	$(LIB) iolib, iolib.obj;
	del iolib.obj

iolib.obj: iolib.asm
	$(MASM)	-Mx -T -N iolib;

iolib.a: iolib.o
	$(AR) cq iolib.a iolib.o
	del iolib.o

iolib.o: iolib.s
	$(AS) -o iolib.o iolib.s

clean:
	-del *.o
	-del *.obj
	-del *.lib
	-del *.a
	-del *.lst
