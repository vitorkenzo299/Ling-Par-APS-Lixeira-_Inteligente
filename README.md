# Ling-Par-APS-Lixeira-_Inteligente

### Descrição
Esse programa foi feito com o objetivo de poder ajudar as pessoas a se organizar com a reciclagem do lixo, podendo escolher entre materiais reciclaveis e não reciclaveis e decidindo onde colocar cada tipo de resíduo em seu determinado lugar.

## Estrutura da Linguagem (EBNF)

```ebnf
programa = { comando } ;

comando = atribuicao ";" 
         | acao ";" 
         | condicional 
         | loop ;

atribuicao = identificador "=" expressao ;

acao = "ChecarOLixo" "(" ")"                 
      | "EsseLixoEstragaFacil" "(" ")"       
      | "EsseLixopodeSerReapoveitado" "(" ")" 
      | "EsvaziarLixoFedido" "(" ")"         
      | "EsvaziarLixoCheiroso" "(" ")"       
      | "mostraAe" "(" expressao ")" ;        

condicional = "sepa" "(" expressao ")" "{" { comando } "}" 
              { "dependendo" "(" expressao ")" "{" { comando } "}" } 
              [ "naosepa" "{" { comando } "}" ] ;

loop = "_707070_SenNaoDer_70_Denovo_" "(" expressao ")" "{" { comando } "}" ;

expressao = logica ;
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

identificador = "reciclavel" | "organico" | "meuTipo" ;
numero = digito { digito } ;
digito = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
```

### VM

- Registradores

R1 → quantidade de lixo orgânico.

R2 → quantidade de lixo reciclável.

R3 → registrador temporário.

R4 → registrador temporário.

- Sensores (somente leitura)

S1 → capacidade máxima do lixo dos orgânicos.

S2 → capacidade máxima do lixo dos recicláveis.

S3 → tipo do lixo detectado (0 = orgânico, 1 = reciclável).

```A VM implementa instruções básicas como SET, MOV, INC, JZ, JMP, PRINT, LOADSENSOR, LOADVAR, STOREVAR, ADD, SUB, EQ, LT, etc.```

# Como Compilar e Executar
```
-> Compilar o projeto
    make

-> Limpar arquivos gerados
    make clean

-> Modo interativo
    ./analisador

-> Analisar arquivo de código
    ./analisador < exemplos/exemplo_if.lix

-> Teste rápido
    echo "reciclavel = 10; organico = 5;" | ./analisador

-> Rodar a VM manualmente
    python3 vm.py program.asm --caprec 20 --caporg 15 --tipolixo 1

-> Executar todos os testes automáticos 
    chmod +x run_tests_verbose.sh
    ./run_tests_verbose.sh

#Esse script compila o projeto, roda todos os exemplos e compara a saída com os arquivos .expected


```

### Exemplo 1 — Condicional (If / Else)
```
Código .lix

meuTipo = ChecarOLixo();
sepa (meuTipo == 1) {
    EsseLixopodeSerReapoveitado();
} naosepa {
    EsseLixoEstragaFacil();
}

Assembly gerado (program.asm)

LOADSENSOR R3 TIPO_LIXO
STOREVAR meuTipo R3
LOADVAR R3 meuTipo
SET R3 1
MOV R4 R3
EQ R3 R4 R3
JZ R3 L0
INC R2
PRINT R2
JMP L1
LABEL L0
INC R1
PRINT R1
LABEL L1
HALT

Saída da VM (tipolixo = 1)

1

-- VM final state --
R1 = 0
R2 = 1
meuTipo = 1
-- end --

```

### Exemplo 2 — Laço (While)
```
Código .lix

contador = 3;
_707070_SenNaoDer_70_Denovo_ (contador) {
    mostraAe(contador);
    contador = contador - 1;
}

Saída da VM

3

-- VM final state --
contador = 0
```

### Exemplo 3 — Múltiplas Ações
```
Código .lix

reciclavel = 0;
organico = 0;
EsseLixopodeSerReapoveitado();
EsseLixoEstragaFacil();
mostraAe(reciclavel);
mostraAe(organico);

Saída da VM

1
1
1
1

-- VM final state --
R1 = 1
R2 = 1
```

### Demonstração Rápida (Terminal)
```
make clean && make
./analisador < exemplos/exemplo_if.lix
cat program.asm
python3 vm.py program.asm --caprec 20 --caporg 15 --tipolixo 1
python3 vm.py program.asm --caprec 20 --caporg 15 --tipolixo 0
./run_tests_verbose.sh
```