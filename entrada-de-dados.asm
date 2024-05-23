segment .data
  LF                  equ 0xA                    ; Nova Linha
  CHAMADA_SistemaOperacional equ 0x80            ; Envia informação ao SO
  ; EAX
  SAIR                equ 0x1                    ; Código de chamada para finalizar
  LER                 equ 0x3                    ; Operação de leitura
  ESCREVER            equ 0x4                    ; Operação de escrita
  ; EBX
  RET_SUCESSO         equ 0x0                    ; Operação realizada com Sucesso
  ENTRADA             equ 0x0                    ; Entrada padrão
  SAIDA               equ 0x1                    ; Saída padrão

section .data
  mensagem            db "Digite seu nome:", LF, 0
  tam_mensagem        equ $-mensagem
  saudacao            db "Olá, ", 0
  tam_saudacao        equ $-saudacao

section .bss
  nome                resb 32                    ; Reservando 32 bytes para o nome
  saudacao_completa   resb 64                    ; Espaço para a saudacao completa (saudacao + nome)

section .text  

global _start

_start:
  ; Escreve a mensagem na saída padrão
  mov eax, ESCREVER
  mov ebx, SAIDA
  mov ecx, mensagem
  mov edx, tam_mensagem
  int CHAMADA_SistemaOperacional

  ; Lê o nome da entrada padrão
  mov eax, LER
  mov ebx, ENTRADA
  mov ecx, nome
  mov edx, 32                              ; Ler até 32 bytes
  int CHAMADA_SistemaOperacional
  
  ; Substitui nova linha por nulo (final da string)
  mov ecx, nome
  mov edi, 0
encontrar_nulo:
  cmp byte [ecx + edi], LF
  je fim_encontrar_nulo
  inc edi
  jmp encontrar_nulo
fim_encontrar_nulo:
  mov byte [ecx + edi], 0

  ; Concatena "Olá, " com o nome
  ; Copia saudacao para saudacao_completa
  mov esi, saudacao
  mov edi, saudacao_completa
copiar_saudacao:
  lodsb
  stosb
  test al, al
  jnz copiar_saudacao

  ; Copia nome para saudacao_completa
  mov esi, nome
copiar_nome:
  lodsb
  stosb
  test al, al
  jnz copiar_nome

  ; Adiciona nova linha ao final
  mov al, LF
  stosb
  mov al, 0
  stosb

  ; Calcula o tamanho da saudacao completa
  mov edi, saudacao_completa
  mov ecx, 0
calcular_tamanho:
  lodsb
  inc ecx
  test al, al
  jnz calcular_tamanho
  dec ecx                           ; Subtrai 1 para não contar o nulo

  ; Escreve a saudacao completa na saída padrão
  mov eax, ESCREVER
  mov ebx, SAIDA
  mov ecx, saudacao_completa
  mov edx, ecx
  int CHAMADA_SistemaOperacional

  ; Finaliza o programa
  mov eax, SAIR
  mov ebx, RET_SUCESSO
  int CHAMADA_SistemaOperacional
