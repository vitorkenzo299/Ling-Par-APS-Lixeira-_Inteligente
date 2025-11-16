#include <stdio.h>
#include <stdlib.h>

int yyparse(void);
extern FILE *yyin;

int main(int argc, char *argv[]) {
    printf("LixeiraLang - Analisador Léxico e Sintático\n");
    printf("Uso: ./lixeira [arquivo.lix]\n\n");

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Erro ao abrir o arquivo");
            return 1;
        }
    } else {
        yyin = stdin;
    }

    int result = yyparse();

    if (result == 0)
        printf("\nAnalise concluida: sintaxe aceita.\n");
    else
        printf("\nAnalise concluida: erros detectados.\n");

    if (argc > 1 && yyin != stdin) fclose(yyin);

    return (result == 0) ? 0 : 1;
}
