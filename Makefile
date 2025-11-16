CC = gcc
BISON = bison
FLEX = flex
CFLAGS = -Wall -g

all: analisador

parser.tab.c parser.tab.h: parser.y
	$(BISON) -d parser.y

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

analisador: parser.tab.c lex.yy.c codegen.c
	$(CC) $(CFLAGS) -o analisador parser.tab.c lex.yy.c codegen.c -lm

clean:
	rm -f analisador lex.yy.c parser.tab.c parser.tab.h program.asm
