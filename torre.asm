segment .data ; Lida com os dados na memória principal
   
    mensagem_inicial db 'Digite a quantidade de discos: ', LF
    len_mensagem equ $ - mensagem_inicial
    
    exibir1 db 'Algoritmo da Torre de Hanoi com "'
    len_exb1 equ $ - exibir1
    
    exibir2 db '" discos', LF
    len_exb2 equ $ - exibir2
    
    inv db 'Caracter invalido! (insira um valor entre 1 e 9)', LF
    len_inv equ $ - inv

    mensagem_final:
                          db "Mova o disco "                      
        n_disco:          db " "
                          db " da torre "
        torre_origem:     db " "
                          db " para a torre "     
        torre_destino:    db " ", LF
    len_f equ $ - mensagem_final
        
    concluido db 'Concluido!', LF
    len_c equ $ - concluido

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

section .bss
    n resb 5 ; Reserva o espaço na memória para o número que o usuário vai digitar

section .text ; Instruções
    global _start ; Declarar como global serve para que a função fique visível fora do arquivo "principal"
    global str_para_int ; Aqui no caso declarar como global ou não não afetaria o programa
    global torre_hanoi ; Pois ele é um arquivo apenas
    global fim
    global imprime

_start:                                                         
    push ebp                        
    mov ebp, esp                    

    ; Solicita o número ao usuário
    mov eax, ESCREVER
    mov ebx, SAIDA
    mov ecx, mensagem_inicial
    mov edx, len_mensagem
    int CHAMADA_SistemaOperacional

    ; Lê o número do usuário
    mov eax, LER
    mov ebx, ENTRADA
    mov ecx, n
    mov edx, 5  ; Número de bytes a serem lidos
    int CHAMADA_SistemaOperacional
    
    ; Escreve a mensagem "torre de hanoi com n discos"
    mov eax, ESCREVER
    mov ebx, SAIDA
    mov ecx, exibir1
    mov edx, len_exb1
    int CHAMADA_SistemaOperacional
    
    mov eax, ESCREVER
    mov ebx, SAIDA
    mov ecx, n
    mov edx, 1  ; Tamanho de um caractere 
    int CHAMADA_SistemaOperacional
    
    mov eax, ESCREVER
    mov ebx, SAIDA
    mov ecx, exibir2
    mov edx, len_exb2
    int CHAMADA_SistemaOperacional
    
    mov edx, n                  
    call str_para_int

    cmp eax, 1
    jl invalido
    cmp eax, 9
    jg invalido
    
    ; 3 pilhas
    push dword 18 ; torre auxiliar, o valor é o endereço da pilha
    push dword 19 ; torre destino
    push dword 17 ; torre de origem
    push eax ; eax na pilha

    call torre_hanoi
    
    ; Imprime a mensagem "concluido!"
    mov eax, ESCREVER
    mov ebx, SAIDA
    mov ecx, concluido
    mov edx, len_c
    int CHAMADA_SistemaOperacional

    ; Finaliza o programa
    mov eax, SAIR                      
    mov ebx, RET_SUCESSO                      
    int CHAMADA_SistemaOperacional                        

str_para_int:
    xor eax, eax ; Limpando o registrador eax
    xor ecx, ecx
    mov ebx, LF 
    
    .loop: ; converte para retirar os 0s da string de entrada
        movzx ecx, byte [edx]
        cmp ecx, LF
        je .done ; Se encontrar newline, termina
        inc edx
        cmp ecx, '0'
        jb .done ; Se for menor, vá para .done
        cmp ecx, '9'
        ja .done ; Caso for maior, vá para .done
        
        sub ecx, '0' ; Subtrai a "string" de "zero", irá "transformar em int"
        imul eax, ebx ; Multiplica por EBX
        add eax, ecx
        jmp .loop
    
    .done:
        test eax, eax
        jz invalido
        ret

invalido:
    mov eax, ESCREVER
    mov ebx, SAIDA
    mov ecx, inv
    mov edx, len_inv
    int CHAMADA_SistemaOperacional
    
    jmp _start

torre_hanoi:
    push ebp        ; Salva o registrador ebp na pilha
    mov ebp, esp    ; Ebp recebe o endereço do topo da pilha

    mov eax, [ebp+8] ; Pega o a posição do primeiro elemento
    cmp eax, 0
    jle fim ; Caso eax for menor ou igual a 0, vai para o fim
    
    dec eax
    push dword [ebp+16] ; Coloca na pilha a torre auxiliar
    push dword [ebp+20] ; Coloca na pilha a torre destino
    push dword [ebp+12] ; Coloca na pilha a torre de origem
    push dword eax ; Põe eax na pilha
    call torre_hanoi

    add esp, 16 ; Libera 16 bytes de espaço
    push dword [ebp+16] ; Pega o pino de origem referenciado pelo parâmetro ebp+16
    push dword [ebp+12] ; Coloca na pilha o pino de origem
    push dword [ebp+8] ; Coloca na pilha o número de disco inicial
    call imprime

    add esp, 12 ; Libera mais 12 bytes de espaço
    push dword [ebp+12] ; Coloca na pilha a torre origem
    push dword [ebp+16] ; Coloca na pilha a torre auxiliar
    push dword [ebp+20] ; Coloca na pilha a torre destino
    mov eax, [ebp+8] ; Coloca no registrador o espaço do número de discos atuais
    dec eax

    push dword eax ; Põe eax na pilha
    call torre_hanoi

fim:
    mov esp, ebp
    pop ebp ; Desempilha
    ret ; Retorna

imprime:
    push ebp ; Empilha
    mov ebp, esp ; Recebe o endereço do topo da pilha
    
    mov eax, [ebp + 8] ; Exibindo qual disco estamos movendo
    add al, '0' ; Convertendo para ASCII
    mov [n_disco], al
    
    mov eax, [ebp + 12] ; Torre de origem
    add al, '0' 
    mov [torre_origem], al ; Movendo o disco de al para torre de origem
    
    mov eax, [ebp + 16] ; Torre de destino
    add al, '0'
    mov [torre_destino], al ; Movendo o disco de al para a torre de destino
    
    ; Mostrando a mensagem "mova o disco n..."
    mov eax, ESCREVER
    mov ebx, SAIDA
    mov ecx, mensagem_final
    mov edx, len_f
    int CHAMADA_SistemaOperacional

    mov esp, ebp
    pop ebp ; Pega o valor do topo da pilha e coloca em EBP
    ret ; Retorna
