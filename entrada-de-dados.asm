segment .data
  LF        equ 0xA                    ; Nova Linha
  NULO      equ 0xD                    ; Final da String
  CHAMADA_SistemaOperacional equ 0x80  ; Envia informação ao SO
  ; EAX
  SAIR      equ 0x1    ; Código de chamada para finalizar
  LER       equ 0x3    ; Operação de leitura
  ESCREVER  equ 0x4    ; Operação de escrita
  ; EBX
  RET_SUCESSO equ 0x0  ; Operação realizada com Sucesso
  ENTRADA   equ 0x0    ; Entrada padrão
  SAIDA     equ 0x1    ; Saída padrão

section .data
  mensagem db "Digite seu nome:", LF, NULO
  tam_msg  equ $- mensagem

section .bss
  nome resb 1  

section .text  

global _start

_start:
  ; Escreve a mensagem na saída padrão
  mov EAX, ESCREVER
  mov EBX, SAIDA
  mov ECX, mensagem
  mov EDX, tam_msg
  int CHAMADA_SistemaOperacional

  ; Lê o nome da entrada padrão
  mov EAX, LER
  mov EBX, ENTRADA
  mov ECX, nome
  mov EDX, 0xA
  int CHAMADA_SistemaOperacional

  ; Finaliza o programa
  mov EAX, SAIR
  mov EBX, RET_SUCESSO
  int CHAMADA_SistemaOperacional
