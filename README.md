# Torre de Hanói em Assembly

O programa recebe um inteiro de 0 a 499 e imprime a sequência de movimentos da torre A para a C, usando a B como auxiliar. Com 0 discos, ele termina sem imprimir movimentos. O arquivo do programa é `torre.asm`.

## Como rodar no Linux x86 ou x86-64

No Ubuntu ou Debian, instale as ferramentas e rode os comandos na pasta do projeto.

```sh
sudo apt update
sudo apt install -y nasm binutils
mkdir -p build
nasm -f elf32 torre.asm -o build/torre.o
ld -m elf_i386 build/torre.o -o build/torre
./build/torre
```

Digite `3` e pressione Enter. O programa imprime um movimento por linha, na ordem em que deve ser executado.

```text
Mova o disco 1 da torre A para a torre C
Mova o disco 2 da torre A para a torre B
Mova o disco 1 da torre C para a torre B
Mova o disco 3 da torre A para a torre C
Mova o disco 1 da torre B para a torre A
Mova o disco 2 da torre B para a torre C
Mova o disco 1 da torre A para a torre C
```

## Como rodar no macOS com Docker

Abra o Docker Desktop. Na pasta do projeto, execute o comando abaixo. Ele monta o código e roda o binário Linux de 32 bits com o QEMU, inclusive em Macs com Apple Silicon.

```sh
docker run --rm -it -v "$PWD:/projeto:ro" -w /projeto debian:bookworm-slim sh -c '
  apt-get update &&
  apt-get install -y nasm binutils-i686-linux-gnu qemu-user &&
  nasm -f elf32 torre.asm -o /tmp/torre.o &&
  i686-linux-gnu-ld -m elf_i386 /tmp/torre.o -o /tmp/torre &&
  qemu-i386 /tmp/torre
'
```

## Como explicar a recursão

`hanoi(n, origem, destino, auxiliar)` termina imediatamente se `n = 0`. Para `n > 0`, ela faz três coisas.

1. Move os `n - 1` discos menores da origem para a auxiliar.
2. Imprime o movimento do maior disco da origem para o destino.
3. Move os `n - 1` discos menores da auxiliar para o destino.

Em Assembly, cada chamada coloca os quatro argumentos na pilha com `push`. A função usa `ebp` para acessar seus próprios argumentos após cada chamada recursiva. O `ret 16` remove os quatro argumentos de 4 bytes ao retornar. Ao todo, o programa imprime `2ⁿ − 1` movimentos.

O programa imprime os movimentos à medida que os encontra e usa espaço de pilha proporcional a `n`. Com 100 discos, já são cerca de 1,27 × 10³⁰ movimentos, então é possível ver o início da sequência, mas imprimir a solução inteira é impraticável. Para interromper uma execução longa, pressione Ctrl+C.
