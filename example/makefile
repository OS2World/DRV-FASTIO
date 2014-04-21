CC = gcc
CFLAGS = -O -I../iolib
RM = del
LIBS = -L../iolib -liolib

ioexam.exe: ioexam.c
	$(CC) $(CFLAGS) -o ioexam.exe ioexam.c $(LIBS)

clean:
	$(RM) *.exe
	$(RM) *.o
