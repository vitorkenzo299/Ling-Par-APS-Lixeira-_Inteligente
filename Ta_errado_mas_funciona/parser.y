%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);

int organico = 0;
int reciclavel = 0;
const int capOrganico = 100;
const int capReciclavel = 100;
int tipoLixo = 0;

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
    /* vazio */
    | programa comando
    ;

comando:
    atribuicao PONTO_VIRGULA
    | acao PONTO_VIRGULA
    | condicional
    | loop
    ;

atribuicao:
    RECICLAVEL ATRIBUICAO expressao { 
        reciclavel = $3; 
        printf("reciclavel = %d\n", reciclavel);
    }
    | ORGANICO ATRIBUICAO expressao { 
        organico = $3; 
        printf("organico = %d\n", organico);
    }
    ;

acao:
    CHECAR_LIXO ABRE_PAR FECHA_PAR { 
        printf("Checando tipo do lixo...\n");
        tipoLixo = rand() % 2; // Simula detecção do tipo
        printf("Tipo detectado: %s\n", tipoLixo ? "Reciclável" : "Orgânico");
    }
    | ADD_ORGANICO ABRE_PAR FECHA_PAR {
        if (organico < capOrganico) {
            organico++;
            printf("Lixo orgânico adicionado. Total: %d/%d\n", organico, capOrganico);
        } else {
            printf("Lixo orgânico cheio! Esvazie antes de adicionar mais.\n");
        }
    }
    | ADD_RECICLAVEL ABRE_PAR FECHA_PAR {
        if (reciclavel < capReciclavel) {
            reciclavel++;
            printf("Lixo reciclável adicionado. Total: %d/%d\n", reciclavel, capReciclavel);
        } else {
            printf("Lixo reciclável cheio! Esvazie antes de adicionar mais.\n");
        }
    }
    | ESVAZIAR_ORGANICO ABRE_PAR FECHA_PAR {
        organico = 0;
        printf("Lixo orgânico esvaziado.\n");
    }
    | ESVAZIAR_RECICLAVEL ABRE_PAR FECHA_PAR {
        reciclavel = 0;
        printf("Lixo reciclável esvaziado.\n");
    }
    | MOSTRA_AE ABRE_PAR expressao FECHA_PAR {
        printf("Mostrando: %d\n", $3);
    }
    ;

condicional:
    SEPA ABRE_PAR expressao FECHA_PAR ABRE_CHAVE programa FECHA_CHAVE
    {
        if ($3) {
            printf("Condição 'sepa' verdadeira\n");
        }
    }
    dependendo_chain
    naosepa_opcional
    ;

dependendo_chain:
    /* vazio */
    | dependendo_chain DEPENDENDO ABRE_PAR expressao FECHA_PAR ABRE_CHAVE programa FECHA_CHAVE
    {
        if ($4) {
            printf("Condição 'dependendo' verdadeira\n");
        }
    }
    ;

naosepa_opcional:
    /* vazio */
    | NAOSEPA ABRE_CHAVE programa FECHA_CHAVE
    {
        printf("Executando bloco 'naosepa'\n");
    }
    ;

loop:
    LOOP ABRE_PAR expressao FECHA_PAR ABRE_CHAVE programa FECHA_CHAVE
    {
        printf("Loop while executado\n");
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
    | RECICLAVEL { $$ = reciclavel; }
    | ORGANICO { $$ = organico; }
    | CAP_RECICLAVEL { $$ = capReciclavel; }
    | CAP_ORGANICO { $$ = capOrganico; }
    | TIPO_LIXO { $$ = tipoLixo; }
    | ABRE_PAR expressao FECHA_PAR { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main() {
    printf("=== Sistema Inteligente de Reciclagem ===\n");
    printf("Estado inicial:\n");
    printf("  Lixo Orgânico: %d/%d\n", organico, capOrganico);
    printf("  Lixo Reciclável: %d/%d\n\n", reciclavel, capReciclavel);
    
    return yyparse();
}