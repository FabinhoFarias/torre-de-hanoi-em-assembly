section .data
    pergunta db 'Digite a quantidade de discos (0 a 499): '
    tam_pergunta equ $ - pergunta
    erro db 'Digite um numero inteiro de 0 a 499.', 10
    tam_erro equ $ - erro

    movimento db 'Mova o disco '
    tam_prefixo equ $ - movimento
    disco times 3 db ' '
    sufixo db ' da torre '
    origem db ' '
    db ' para a torre '
    destino db ' ', 10
    fim_movimento:

section .bss
    entrada resb 1

section .text
    global _start

_start:
    mov ecx, pergunta
    mov edx, tam_pergunta
    call escrever

    xor esi, esi                ; valor acumulado
    xor edi, edi                ; indica se ja leu um digito
    mov ecx, entrada
    mov edx, 1

.ler:
    mov eax, 3                  ; read(stdin, entrada, 1)
    xor ebx, ebx
    int 0x80
    test eax, eax
    js .invalido
    jz .resolver
    movzx eax, byte [entrada]
    cmp al, 10
    je .resolver
    sub eax, '0'
    cmp eax, 9
    ja .invalido
    imul esi, esi, 10
    add esi, eax
    cmp esi, 500
    jae .invalido
    mov edi, 1
    jmp .ler

.resolver:
    test edi, edi
    jz .invalido
    push dword 'B'              ; auxiliar
    push dword 'C'              ; destino
    push dword 'A'              ; origem
    push esi                    ; n
    call hanoi

    xor ebx, ebx
    jmp .sair

.invalido:
    mov ecx, erro
    mov edx, tam_erro
    call escrever               ; deixa ebx = 1 (codigo de erro)

.sair:
    mov eax, 1                  ; exit(ebx)
    int 0x80

; hanoi(n, origem, destino, auxiliar)
hanoi:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]          ; n
    test eax, eax
    jz .fim

    dec eax
    push dword [ebp + 16]       ; destino vira auxiliar
    push dword [ebp + 20]       ; auxiliar vira destino
    push dword [ebp + 12]       ; mesma origem
    push eax
    call hanoi

    mov al, [ebp + 12]
    mov [origem], al
    mov al, [ebp + 16]
    mov [destino], al
    mov ecx, movimento
    mov edx, tam_prefixo
    call escrever

    mov eax, [ebp + 8]
    mov ebx, 10
    mov ecx, sufixo
.decimal:
    xor edx, edx
    div ebx                     ; eax = quociente, edx = ultimo digito
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .decimal

    mov edx, fim_movimento
    sub edx, ecx                ; imprime do primeiro digito ate a quebra de linha
    call escrever

    mov eax, [ebp + 8]
    dec eax
    push dword [ebp + 12]       ; origem vira auxiliar
    push dword [ebp + 16]       ; mesmo destino
    push dword [ebp + 20]       ; auxiliar vira origem
    push eax
    call hanoi

.fim:
    pop ebp
    ret 16                     ; remove os quatro argumentos

escrever:
    mov eax, 4                  ; write(stdout, ecx, edx)
    mov ebx, 1
    int 0x80
    ret
