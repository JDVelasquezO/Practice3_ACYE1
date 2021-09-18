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
    fichaNegra db "Turno Ficha Negra: $"
    tokenP1 db "Color de ficha jugador 1 B/N [1/2]: $"
    digitEnter db " mueve la ficha de tu gusto: $"
    bufferP1 db 50 dup("$"), "$"
    bufferP2 db 50 dup("$"), "$"
    bufferTeclado db 50 dup("$"), "$"
    bufferKey db 50 dup("$"), "$"
    individual db " $"
    espacio db " $"
    dobleEspacio db '  ','$'
    lineas db "|-$"
    salto db 0ah, "$"
    valida db " ingresa un valor valido $"
    validaPlayer db "Debes ingresar nombre de jugador $"
    
    iteradorI dw 0
    iteradorJ dw 0
    iteradork dw 0
    color db 0
    tablero db 64 dup(0), "$"
    fila dw 0
    columna dw 0
    
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
            cmp bufferP1[0], "$"
            je invalidName
            cmp bufferP2[0], "$"
            je invalidName

            ImprimirEspacio al
            print tokenP1
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
            print name1
            print bufferP1
            ImprimirEspacio al
            print fichaBlanca
            ImprimirEspacio al
            ImprimirEspacio al
            imprimirMatriz
            ImprimirEspacio al
            leerCelda bufferP1
            readUntilEnter bufferTeclado
            ; clearTerminal
            ; jmp menu_offset

        blackTurn:
            jmp menu_offset

        exit:
            mov ah, 4ch
            INT 21H

    main endp
end