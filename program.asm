; Assembly gerado por LixeiraLang
; Registers: R1=organico, R2=reciclavel, R3=temp, R4=temp2

; load literal
SET R3 0
; STORE R3 -> reciclavel (R2)
MOV R2 R3
; load literal
SET R3 0
; STORE R3 -> organico (R1)
MOV R1 R3
; action ADD_RECICLAVEL -> INC R2
INC R2
PRINT R2
; action ADD_ORGANICO -> INC R1
INC R1
PRINT R1
MOV R3 R2
; action mostraAe -> PRINT R3
PRINT R3
MOV R3 R1
; action mostraAe -> PRINT R3
PRINT R3

HALT
