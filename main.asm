include macros.asm

.model small
.stack 64h
.data
    headers db 	0ah,0dh,'JUEGO DE DAMAS - MICROSOFT MACRO ASSEMBLER',
                0ah,0dh,'FACULTAD DE INGENIERIA - USAC',
                0ah,0dh,'$'

	menu db 	0ah,0dh,'1) Crear Jugadores',
                0ah,0dh,'2) Nuevo Juego',
                0ah,0dh,'3) Salir',
                0ah,0dh, 'Escoja una opcion: ',
                0ah,0dh,'$'

    name1 db "Nombre de jugador 1: $"
    name2 db "Nombre de jugador 2: $"
    fichaBlanca db "Turno Ficha: Blanca $"
    fichaNegra db "Turno Ficha: Negra $"
    tokenP1 db "Color de ficha jugador 1 B/N [1/2]: $"
    digitEnter db " mueve la ficha de tu gusto: $"
    valida db " ingresa un valor valido. $"
    validaPlayer db "Debes ingresar nombre de jugador. Presiona enter para continuar... $"
    mensajeOcupada db "casilla ocupada, intenta otra vez$"
    mensajeBadMoveV db " no puedes moverte de forma vertical, solo diagonal$"
    mensajeBadMoveH db " no puedes moverte de forma horizontal, solo diagonal$"
    mensajeBadPlayer db " no puedes mover fichas que no son tuyas$"

    bufferP1 db 50 dup("$"), "$"
    bufferP2 db 50 dup("$"), "$"
    bufferTeclado db 50 dup("$"), "$"
    bufferKey db 50 dup("$"), "$"
    individual db " $"
    espacio db " $"
    dobleEspacio db '  ','$'
    lineas db "|-$"
    salto db 0ah, "$"
    pointer1 dw 0
    pointer2 dw 0
    pointerGeneral dw 0
    cellKilled dw 0
    colKilled dw 0
    rowKilled dw 0
    
    iteradorI dw 0
    iteradorJ dw 0
    iteradork dw 0
    iteradorTable db 0
    color db 0
    tablero db 64 dup(0), "$"
    tipoJugador1 db 0
    tipoJugador2 db 0
    fila1 dw 0
    fila2 dw 0
    columna1 dw 0
    columna2 dw 0
    indice dw 0
    msgStoreP1 db "Punteo P1: $"
    msgStoreP2 db "Punteo P2: $"
    storeP1 db 0
    storeP2 db 0
    
    cabecerasF db "12345678$"
    cabecerasC db "ABCDEFGH$"

.code
    main proc
        mov ax, @data
        mov ds, ax

        print headers

        menu_offset:
            clearTerminal
            print menu
            getIn

            cmp al, '1'
            je createPlayer
            cmp al, '2'
            je play
            cmp al, '3'
            je exit

            jmp menu_offset

        createPlayer:
            ImprimirEspacio al
            print name1
            ImprimirEspacio al
            readUntilEnter bufferP1
            ImprimirEspacio al
            print name2
            ImprimirEspacio al
            readUntilEnter bufferP2
            ImprimirEspacio al
            jmp menu_offset

        play:
            clearTerminal
            cmp bufferP1[0], "$"
            je invalidName
            cmp bufferP2[0], "$"
            je invalidName

            ImprimirEspacio al
            print tokenP1
            ImprimirEspacio al

            ; Impresion de tablero
            imprimirMatriz

            readUntilEnter bufferKey

            cmp bufferKey[0], "1"
            je whiteTurn
            jmp blackTurn

        invalidName:
            ImprimirEspacio al
            print validaPlayer
            readUntilEnter bufferTeclado
            jmp menu_offset

        whiteTurn:
            ; Impresiones de turno
            clearTerminal
            print name1
            print bufferP1
            ImprimirEspacio al
            print fichaBlanca
            ImprimirEspacio al
            print msgStoreP1
            
            xor bx, bx
            mov bl, storeP1
            printRegister bl

            ImprimirEspacio al
            ImprimirEspacio al
            
            reImprimirMatriz
            ImprimirEspacio al
            leerCelda bufferP1
            
            ; Obtener indice de fila y col, y validar si se puede mover
            xor di, di
            xor si, si
            xor ax, ax
            obtenerIndice fila2, columna2
            mov di, indice
            cmp tablero[di], 0d
            jnz ocupada
            mov tablero[di], 1d
            obtenerIndice fila1, columna1
            mov si, indice
            mov tablero[si], 0d
            validateScore fila1, fila2, columna1, columna2
            jmp blackTurn

        blackTurn:
            clearTerminal
            print name2
            print bufferP2
            ImprimirEspacio al
            print fichaNegra
            ImprimirEspacio al
            print msgStoreP2
            
            xor bx, bx
            mov bh, storeP2
            printRegister bh

            ImprimirEspacio al
            ImprimirEspacio al

            ; Impresion de tablero
            reImprimirMatriz
            ImprimirEspacio al
            leerCelda bufferP2

            xor di, di
            xor si, si
            xor ax, ax
            obtenerIndice fila2, columna2
            mov di, indice
            cmp tablero[di], 0d
            jnz ocupada
            mov tablero[di], 2d

            obtenerIndice fila1, columna1
            mov si, indice
            mov tablero[si], 0d
            validateScore2 fila1, fila2, columna1, columna2
            jmp whiteTurn

        ocupada:
            imprimir salto, 0d
            imprimir mensajeOcupada, 10001110b
            imprimir salto, 0d
            imprimir salto, 0d
            readUntilEnter bufferKey
            jmp whiteTurn

        exit:
            mov ah, 4ch
            INT 21H

    main endp
end