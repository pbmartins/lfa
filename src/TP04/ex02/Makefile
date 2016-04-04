CC = g++
CFLAGS = -Wall
CXX = g++
CXXFLAGS = -Wall
LEX = flex
YACC = bison

all:	calc

calc:	calc.o calc-parse.o calc-lex.o ast.o symbol-table.o
	$(CC) -o $@ $^

calc.o:	calc-parse.h calc-lex.h calc-data.h ast.h

calc-parse.o:	calc-lex.h calc-data.h ast.h

calc-lex.o:	calc-parse.h ast.h

calc-parse.c calc-parse.h:	calc-parse.y
	$(YACC) calc-parse.y -o calc-parse.c

calc-lex.c calc-lex.h:	calc-lex.l
	$(LEX) -ocalc-lex.c calc-lex.l


clean:	
	rm -f *.o calc-parse.h calc-lex.h calc-parse.c calc-lex.c
	rm -f *.output

cleanall:	clean
	rm -f calc
