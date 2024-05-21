; Compilar - Transformar o programa para linguagem máquina
;   nasm -f elf64 hello.asm
; Linkeditar - Transformar o programa em linguagem de máquina para um executável
;   ld -s -o hello hello.o

section .data
    msg db 'Hello World!', 0xA, 0xD    ; Define uma string "Hello World!" seguida por uma nova linha e um retorno de carro (CR)
    tam equ $- msg                     ; Calcula o tamanho da string 'msg', similar ao len() em Python

section .text

global _start                          ; Define o ponto de entrada do programa

_start:
    mov EAX, 0x4                       ; Chama a função de sistema 'sys_write' (número 4) para escrever dados
    mov EBX, 0x1                       ; Indica que a escrita será feita no arquivo de saída padrão (stdout), cujo descritor é 1
execucao:
    mov ECX, msg                       ; Coloca o endereço da mensagem 'msg' no registrador ECX
    mov EDX, tam                       ; Coloca o tamanho da mensagem 'msg' no registrador EDX
    int 0x80                           ; Chama a interrupção 0x80 para solicitar ao sistema operacional a execução da chamada de sistema

saida:
    mov EAX, 0x1                       ; Chama a função de sistema 'sys_exit' (número 1) para encerrar o programa
    mov EBX, 0x0                       ; Define o código de saída como 0 (sem erros)
    int 0x80                           ; Chama a interrupção 0x80 para solicitar ao sistema operacional a execução da chamada de sistema
