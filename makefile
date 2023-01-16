CC = gcc
OBJFILES = lex.yy.o y.tab.o VSM.o SymTable.o NameTable.o JumpChain.o LabelDef.o 

Rep : ${OBJFILES}
	${CC} ${OBJFILES} -ly -ll -lm -o Rep


JumpChain.o : JumpChain.c VSM.h

LabelDef.o : LabelDef.c VSM.h

SymTable.o : SymTable.c

NameTable.o : NameTable.c

VSM.o : VSM.c VSM.h

lex.yy.o: lex.yy.c y.tab.h VSM.h

lex.yy.c: rep3.l
	flex -l rep3.l

y.tab.o: y.tab.c VSM.h

y.tab.c y.tab.h : rep3.y
	bison -dv -y rep3.y

clean :
	-rm *.o
	-echo "delete object files"
