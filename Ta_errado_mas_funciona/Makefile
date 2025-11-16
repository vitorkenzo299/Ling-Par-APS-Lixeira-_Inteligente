CC = gcc
CFLAGS = -g -Wall

all: parser

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

parser: lex.yy.c parser.tab.c parser.tab.h
	$(CC) $(CFLAGS) -o parser lex.yy.c parser.tab.c -lm

clean:
	rm -f parser lex.yy.c parser.tab.c parser.tab.h

test: parser
	./parser < teste.txt