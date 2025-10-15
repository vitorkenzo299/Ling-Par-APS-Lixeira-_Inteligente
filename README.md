# Ling-Par-APS-Lixeira-_Inteligente

### Descrição
Esse programa foi feito com o objetivo de poder ajudar as pessoas a se organizar com a reciclagem do lixo, podendo escolher entre materiais reciclaveis e não reciclaveis e decidindo onde colocar cada tipo de resíduo em seu determinado lugar.

### EBNF
```
programa = { comando } ;

comando = atribuicao ";" 
         | acao ";" 
         | condicional 
         | loop ;

atribuicao = identificador "=" expressao ;

acao = "ChecarOLixo" "(" ")"                 /* Tipo a SCAN */
      | "EsseLixoEstragaFacil" "(" ")"       /* Vai adicionar organico */
      | "EsseLixopodeSerReapoveitado" "(" ")" /* Vai adicionar reciclavel */
      | "EsvaziarLixoFedido" "(" ")"         /* Vai esvaziar lixo organico */
      | "EsvaziarLixoCheiroso" "(" ")"       /* Vai esvaziar lixo reciclavel */
      | "mostraAe" "(" expressao ")"         /* é tipo um print */

condicional = "sepa" "(" expressao ")" "{" { comando } "}" /* if */
              ( "dependendo" "(" expressao ")" "{" { comando } "}" )* / else if */
              [ "naosepa" "{" { comando } "}" ] ; /* else */

loop = "_707070_SenNaoDer_70_Denovo_" "(" expressao ")" "{" { comando } "}" ; /* while */

expressao = expressao_logica ;

logica = comparacao [ ("==" | "!=") comparacao ] ;

comparacao = adicao [ ("<" | ">" | "<=" | ">=") adicao ] ;

adicao = multiplicacao [ ("+" | "-") multiplicacao ] ;

multiplicacao = primaria [ ("*" | "/") primaria ] ;

primaria = numero 
                   | identificador 
                   | "capReciclavel"
                   | "capOrganico" 
                   | "tipoLixo"
                   | "(" expressao ")" ;

identificador = "reciclavel" | "organico" ;

numero = digito { digito } ;
digito = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;

```
### VM

- Registradores

R1 → quantidade de lixo orgânico.

R2 → quantidade de lixo reciclável.

- Sensores (somente leitura)

S1 → capacidade máxima do lixo dos orgânicos.

S2 → capacidade máxima do lixo dos recicláveis.

S3 → tipo do lixo detectado (0 = orgânico, 1 = reciclável).

# Como Compilar e Executar
```
-> Compilar o projeto
    make

-> Limpar arquivos gerados
    make clean

-> Modo interativo
    ./analisador

-> Analisar arquivo de código
    ./analisador < teste_sintaxe.txt

-> Teste rápido
    echo "organico = 50; reciclavel = 30;" | ./analisador

```

### Exemplo 1
```
ChecarOLixo();
sepa (tipoLixo == 1) {
    sepa (reciclavel < capReciclavel) {
        EsseLixopodeSerReapoveitado();
    } dependendo (reciclavel >= capReciclavel) {
        EsvaziarLixoCheiroso();
    }
} naosepa {
    sepa (organico < capOrganico) {
        EsseLixoEstragaFacil();
    } dependendo (organico >= capOrganico) {
        EsvaziarLixoFedido();
    }
}

```

### Exemplo 2
```
_707070_SenNaoDer_70_Denovo_ (organico < 100) {
    ChecarOLixo();
    sepa (tipoLixo == 0) {
        EsseLixoEstragaFacil();
        mostraAe(organico);
    }
}

```