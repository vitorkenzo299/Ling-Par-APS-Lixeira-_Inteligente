%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);

int parse_success = 0;
%}

%union {
    int num;
}

%token CHECAR_LIXO ADD_ORGANICO ADD_RECICLAVEL ESVAZIAR_ORGANICO ESVAZIAR_RECICLAVEL
%token MOSTRA_AE SEPA DEPENDENDO NAOSEPA LOOP
%token <num> NUMERO
%token RECICLAVEL ORGANICO CAP_RECICLAVEL CAP_ORGANICO TIPO_LIXO
%token IGUAL DIFERENTE MENOR_IGUAL MAIOR_IGUAL MENOR MAIOR
%token ATRIBUICAO MAIS MENOS MULT DIV
%token ABRE_PAR FECHA_PAR ABRE_CHAVE FECHA_CHAVE PONTO_VIRGULA

%type <num> expressao expressao_logica comparacao adicao multiplicacao primaria

%left MAIS MENOS
%left MULT DIV
%left MENOR MAIOR MENOR_IGUAL MAIOR_IGUAL
%left IGUAL DIFERENTE

%%

programa:
    { 
        printf("Análise sintática iniciada...\n"); 
    }
    | programa comando { 
        printf("Comando reconhecido\n"); 
    }
    ;

comando:
    atribuicao PONTO_VIRGULA { 
        printf("Atribuição reconhecida\n"); 
    }
    | acao PONTO_VIRGULA { 
        printf("Ação reconhecida\n"); 
    }
    | condicional { 
        printf("Condicional reconhecida\n"); 
    }
    | loop { 
        printf("Loop reconhecido\n"); 
    }
    ;

atribuicao:
    RECICLAVEL ATRIBUICAO expressao { 
        printf("Atribuição para reciclavel\n"); 
    }
    | ORGANICO ATRIBUICAO expressao { 
        printf("Atribuição para organico\n"); 
    }
    ;

acao:
    CHECAR_LIXO ABRE_PAR FECHA_PAR { 
        printf("Comando: ChecarOLixo\n"); 
    }
    | ADD_ORGANICO ABRE_PAR FECHA_PAR {
        printf("Comando: EsseLixoEstragaFacil\n"); 
    }
    | ADD_RECICLAVEL ABRE_PAR FECHA_PAR {
        printf("Comando: EsseLixopodeSerReapoveitado\n"); 
    }
    | ESVAZIAR_ORGANICO ABRE_PAR FECHA_PAR {
        printf("Comando: EsvaziarLixoFedido\n"); 
    }
    | ESVAZIAR_RECICLAVEL ABRE_PAR FECHA_PAR {
        printf("Comando: EsvaziarLixoCheiroso\n"); 
    }
    | MOSTRA_AE ABRE_PAR expressao FECHA_PAR {
        printf("Comando: mostraAe com expressão\n"); 
    }
    ;

condicional:
    SEPA ABRE_PAR expressao FECHA_PAR ABRE_CHAVE programa FECHA_CHAVE
    {
        printf("Condicional 'sepa' reconhecida\n");
    }
    dependendo_chain
    naosepa_opcional
    ;

dependendo_chain:
    | dependendo_chain DEPENDENDO ABRE_PAR expressao FECHA_PAR ABRE_CHAVE programa FECHA_CHAVE
    {
        printf("Condicional 'dependendo' reconhecida\n");
    }
    ;

naosepa_opcional:
    | NAOSEPA ABRE_CHAVE programa FECHA_CHAVE
    {
        printf("Bloco 'naosepa' reconhecido\n");
    }
    ;

loop:
    LOOP ABRE_PAR expressao FECHA_PAR ABRE_CHAVE programa FECHA_CHAVE
    {
        printf("Loop 'while' reconhecido\n");
    }
    ;

expressao:
    expressao_logica { $$ = $1; }
    ;

expressao_logica:
    comparacao { $$ = $1; }
    | expressao_logica IGUAL comparacao { $$ = ($1 == $3); }
    | expressao_logica DIFERENTE comparacao { $$ = ($1 != $3); }
    ;

comparacao:
    adicao { $$ = $1; }
    | comparacao MENOR adicao { $$ = ($1 < $3); }
    | comparacao MAIOR adicao { $$ = ($1 > $3); }
    | comparacao MENOR_IGUAL adicao { $$ = ($1 <= $3); }
    | comparacao MAIOR_IGUAL adicao { $$ = ($1 >= $3); }
    ;

adicao:
    multiplicacao { $$ = $1; }
    | adicao MAIS multiplicacao { $$ = $1 + $3; }
    | adicao MENOS multiplicacao { $$ = $1 - $3; }
    ;

multiplicacao:
    primaria { $$ = $1; }
    | multiplicacao MULT primaria { $$ = $1 * $3; }
    | multiplicacao DIV primaria { 
        if ($3 == 0) {
            yyerror("Divisão por zero!");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    ;

primaria:
    NUMERO { $$ = $1; }
    | RECICLAVEL { $$ = 0; }  // Placeholder
    | ORGANICO { $$ = 0; }    // Placeholder  
    | CAP_RECICLAVEL { $$ = 0; }  // Placeholder
    | CAP_ORGANICO { $$ = 0; }    // Placeholder
    | TIPO_LIXO { $$ = 0; }       // Placeholder
    | ABRE_PAR expressao FECHA_PAR { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}

int main() {
    printf("=== Analisador Sintático da Lixeira Inteligente ===\n");
    printf("Digite o código (Ctrl+D para finalizar):\n\n");
    
    int result = yyparse();
    
    if (result == 0) {
        printf("\n Análise sintática concluída com SUCESSO!\n");
    } else {
        printf("\n Análise sintática falhou!\n");
    }
    
    return result;
}