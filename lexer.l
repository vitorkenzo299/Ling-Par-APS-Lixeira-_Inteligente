%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"

void yyerror(const char *s);
%}

%option noyywrap nounput noinput

DIGITO   [0-9]
ID       [a-zA-Z_][a-zA-Z0-9_]*

%%

"ChecarOLixo"                 { return CHECAR_LIXO; }
"EsseLixoEstragaFacil"        { return ADD_ORGANICO; }
"EsseLixopodeSerReapoveitado" { return ADD_RECICLAVEL; }
"EsvaziarLixoFedido"          { return ESVAZIAR_ORGANICO; }
"EsvaziarLixoCheiroso"        { return ESVAZIAR_RECICLAVEL; }
"mostraAe"                    { return MOSTRA_AE; }
"sepa"                        { return SEPA; }
"dependendo"                  { return DEPENDENDO; }
"naosepa"                     { return NAOSEPA; }
"_707070_SenNaoDer_70_Denovo_" { return LOOP; }

"reciclavel"                  { return RECICLAVEL; }
"organico"                    { return ORGANICO; }
"capReciclavel"               { return CAP_RECICLAVEL; }
"capOrganico"                 { return CAP_ORGANICO; }
"tipoLixo"                    { return TIPO_LIXO; }

{DIGITO}+      { yylval.num = atoi(yytext); return NUMERO; }

"=="           { return IGUAL; }
"!="           { return DIFERENTE; }
"<="           { return MENOR_IGUAL; }
">="           { return MAIOR_IGUAL; }
"<"            { return MENOR; }
">"            { return MAIOR; }
"="            { return ATRIBUICAO; }
"+"            { return MAIS; }
"-"            { return MENOS; }
"*"            { return MULT; }
"/"            { return DIV; }
"("            { return ABRE_PAR; }
")"            { return FECHA_PAR; }
"{"            { return ABRE_CHAVE; }
"}"            { return FECHA_CHAVE; }
";"            { return PONTO_VIRGULA; }

[ \t\r\n]      ; /* Ignora espaços, tabs e newlines */
.              { 
    fprintf(stderr, "Caractere inválido: '%c'\n", *yytext); 
}

%%