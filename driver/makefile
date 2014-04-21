.SUFFIXES: .obj .c .asm .lst

# WARNING! You need MSC 5.1 or 6.0 for running this makefile
# Adjust the paths as appropriate

CL = \c51\binp\cl
CFLAGS = -W3 -c -Asnw -NT_TEXT -G2s -Zl -Zp -O -nologo -Fa
INC = E:\c\tropez\ddk\base\inc
CINC = P:\MSC_51\include
H = E:\c\tropez\ddk\base\h
LINK = E:\c\tropez\ddk\base\tools\link
LFLAGS = /MAP /NOI /NOE /nod /exepack /packd /a:16 /far
MASM = masm
MFLAGS =  -MX -T -N
MAPSYM = mapsym
CLIB=P:\MSC_51\LIB
DDKLIB=E:\c\tropez\ddk\base\lib
LIBS=$(DDKLIB)\os2286.lib $(DDKLIB)\os2286p.lib $(CLIB)\SLIBCE.LIB
INCLUDE=.;$(INC);$(H);$(CINC)
LIB=$(CLIB);$(DDKLIB)

TARGET=fastio.sys
OBJS=fastio_a.obj fastio_c.obj
DEF=fastio.def

all:	$(TARGET)

clean:
	if exist *.obj del *.obj
	if exist *.sys del *.sys
	if exist *.sym del *.sym
	if exist *.lst del *.lst
	if exist *.map del *.map

.asm.obj:
	$(MASM) $(MFLAGS) $*.asm;

.c.obj:
	$(CL) $(CFLAGS) $(CINC) $*.c

.c.lst:
	$(CL) $(CFLAGS) /Fc $(CINC) $*.c
	copy $*.cod $*.lst
	del $*.cod

$(TARGET): $(OBJS) $(LIBS) $(DEF) makefile
	$(LINK) $(LFLAGS) $(OBJS),$(TARGET),,$(LIBS),fastio.def
	$(MAPSYM) fastio.map
	@echo .
	@echo .
	@echo Copy to \boot directory? Otherwise press CTRL C
	@pause
	copy fastio.sys m:\os2\boot\fastioA.sys
	
# [E:\C\FastIO2\driver]link  /MAP /NOI /NOE /nod /exepack /packd /a:16 /far fastio
# _a.obj fastio_c.obj,fastioAB.sys,,os2286.lib os2286p.lib SLIBCE.LIB,fastio.def

