CC = gcc
OBJFILES = lex.yy.o y.tab.o VSM.o 

rep3 : ${OBJFILES}
	${CC} ${OBJFILES} -ly -ll -lm -o rep3


VSM.o : VSM.c VSM.h

lex.yy.o: lex.yy.c y.tab.h VSM.h

lex.yy.c: rep3.l
	flex -l rep3.l

y.tab.o: y.tab.c VSM.h

y.tab.c y.tab.h : rep3.y
	bison -dv -y rep3.y


