CC = gcc
CFLAGS = -g -Wall
FLEX = flex
BISON = bison

all: analisador

parser.tab.c parser.tab.h: parser.y
	$(BISON) -d parser.y

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

analisador: lex.yy.c parser.tab.c
	$(CC) $(CFLAGS) -o analisador lex.yy.c parser.tab.c -lm

clean:
	rm -f analisador lex.yy.c parser.tab.c parser.tab.h

test: analisador
	echo "organico = 50; reciclavel = 30;" | ./analisador