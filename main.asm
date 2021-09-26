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
    mensajeDama db " creaste una dama$"
    mensajePerdedor db " has perdido$"
    mensajeGanador db " has ganado$"
    salir db "Desea volver a jugar [y/n]: $"
    mensajeReporte db "Generando reporte... $"

    bufferP1 db 50 dup("$"), "$"
    bufferP2 db 50 dup("$"), "$"
    bufferTeclado db 50 dup("$"), "$"
    bufferKey db 50 dup("$"), "$"
    bufferNumber1 db 4 dup("$"), "$"
    bufferNumber2 db 4 dup("$"), "$"
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
    counterWhites dw 0
    counterBlack dw 0
    
    cabecerasF db "12345678$"
    cabecerasC db "ABCDEFGH$"
    someWinner db 0

    ; iniHtml db "<html><body><h1> $", 13, 10
    ; finHtml db "</h1></body></html> $"
    ; input db "report.htm", 00h              ; Assembler solo soporta 3 caracteres de extension
    ; container db 200 dup(0), "$"            ; Guardar lectura
    ; handle dw ?                             ; ? -> No importa el valor

    doctype db "<!DOCTYPE html> $", 13, 10
    lang db "<html> $", 13, 10
    initHead db "<head> $", 13, 10
    metaCharset db "<meta charset=", 34, "UTF-8", 34, "> $", 13, 10
    linkBulma db "<link rel=", 34, "stylesheet", 34, "href=", 34, "https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css", 34, "> $", 13, 10
    titleReports db "<title>Reports</title> $", 13, 10
    finHead db "</head> $", 13, 10
    initBody db "<body> $", 13, 10
    initHeader db "<header> $", 13, 10
    initNav db "<nav class=", 34, "navbar has-background-link", 34, " role=", 34, "navigation", 34, " aria-label=", 34, "main navigation", 34, "> $", 13, 10
    initNavbar db "<div class=", 34, "navbar-brand", 34, "> $", 13, 10
    titleBody db "<h1 class=", 34, "title has-text-white", 34, ">Reportes</h1>", "$", 13, 10
    endNavbar db "</div> $", 13, 10
    endNav db "</nav> $", 13, 10
    endHeader db "</header> $", 13, 10
    initMain db "<main class=", 34, "container mt-6", 34,"> $",13, 10
    initTd db "<td> $"
    endTd db "</td> $"
    initCols db "<div class=",34,"columns",34,"> $", 13, 10
    initTableCol db "<table class=",34,"column table", 34, "> $", 13, 10
    initThead db "<thead> $", 13, 10
    initRowPlayers db "<tr> $",13, 10
    namePlayerHeader db "<th><abbr>Nombre</abbr></th>", "$", 13, 10
    scorePlayerHeader db "<th><abbr>Punteo</abbr></th>", "$", 13, 10
    endRowPlayers db "</tr> $", 13, 10
    endThead db "</thead> $", 13, 10
    initTbody db "<tbody> $", 13, 10
    endTbody db "</tbody> $", 13, 10
    endTableCol db "</table> $", 13, 10
    initColTable db "<div class=", 34, "column", 34,"> $", 13, 10
    labelTable db "<p class=", 34, "subtitle", 34,">Tablero</p>"
    tabForTable db "<table class=", 34, "table is-bordered", 34,"> $",13, 10
    endColTable db "</div> $", 13, 10
    endCols db "</div> $",13, 10
    endMain db "</main> $", 13, 10
    endBody db "</body> $",13, 10
    endHtml db "</html> $", 13, 10
    tdColor db "<td class=", 34, "has-background-grey-light", 34, "> $", 13, 10
    
    input db "report.htm", 00h              ; Assembler solo soporta 3 caracteres de extension
    container db 200 dup(0), "$"            ; Guardar lectura
    handle dw ?   

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
            
            Imprimir8bits storeP1

            ImprimirEspacio al
            ImprimirEspacio al
            
            reImprimirMatriz
            ImprimirEspacio al
            leerCelda bufferP1
            
            ; Obtener indice de fila y col, y validar si se puede mover
            xor di, di
            xor si, si
            xor ax, ax

            ; Validar la ficha correcta
            obtenerIndice fila1, columna1
            mov di, indice
            cmp tablero[di], 2d
            je noTurnPlayer
            cmp tablero[di], 4d
            je noTurnPlayer

            ; Validar si posicion en tablero esta ocupada
            obtenerIndice fila2, columna2
            mov di, indice
            cmp tablero[di], 0d
            jnz ocupada
            
            ; Verificar si es reina
            obtenerIndice fila1, columna1
            mov si, indice
            cmp tablero[si], 3d
            je paintTableCheeckers

            ; Si no es reina, se pinta normal
            obtenerIndice fila2, columna2
            mov di, indice
            mov tablero[di], 1d
            
            movCheeckers:
            ; Dejar la posicion anterior vacía
            xor si, si
            obtenerIndice fila1, columna1
            mov si, indice
            mov tablero[si], 0d
            validateScore fila1, fila2, columna1, columna2
            validateCheckers fila2, columna2
            validateWinner
            validateWinner2

            cmp someWinner, 1d
            je repetir
            jmp blackTurn

        noTurnPlayer:
            imprimir salto, 0d
            imprimir mensajeBadPlayer, 10001110b
            imprimir salto, 0d
            imprimir salto, 0d
            readUntilEnter bufferKey
            jmp whiteTurn

        paintTableCheeckers:
            xor di, di
            obtenerIndice fila2, columna2
            mov di, indice
            mov tablero[di], 3d
            jmp movCheeckers

        blackTurn:
            clearTerminal
            print name2
            print bufferP2
            ImprimirEspacio al
            print fichaNegra
            ImprimirEspacio al
            print msgStoreP2
            
            Imprimir8bits storeP2

            ImprimirEspacio al
            ImprimirEspacio al

            ; Impresion de tablero
            reImprimirMatriz
            ImprimirEspacio al
            leerCelda bufferP2

            xor di, di
            xor si, si
            xor ax, ax

            ; Validar la ficha correcta
            obtenerIndice fila1, columna1
            mov di, indice
            cmp tablero[di], 1d
            je noTurnPlayer2
            cmp tablero[di], 3d
            je noTurnPlayer2

            ; Verificar si está ocupada
            obtenerIndice fila2, columna2
            mov di, indice
            cmp tablero[di], 0d
            jnz ocupada2

            ; Verificar si es reina
            obtenerIndice fila1, columna1
            mov si, indice
            cmp tablero[si], 4d
            je paintTableCheeckers2

            obtenerIndice fila2, columna2
            mov di, indice
            mov tablero[di], 2d

            movCheeckers2:
            xor si, si
            obtenerIndice fila1, columna1
            mov si, indice
            mov tablero[si], 0d
            validateScore2 fila1, fila2, columna1, columna2
            validateCheckers2 fila2, columna2
            validateWinner
            validateWinner2

            cmp someWinner, 1d
            je repetir
            jmp whiteTurn

        noTurnPlayer2:
            imprimir salto, 0d
            imprimir mensajeBadPlayer, 10001110b
            imprimir salto, 0d
            imprimir salto, 0d
            readUntilEnter bufferKey
            jmp blackTurn
        
        paintTableCheeckers2:
            xor di, di
            obtenerIndice fila2, columna2
            mov di, indice
            mov tablero[di], 4d
            jmp movCheeckers2

        ocupada:
            imprimir salto, 0d
            imprimir mensajeOcupada, 10001110b
            imprimir salto, 0d
            imprimir salto, 0d
            readUntilEnter bufferKey
            jmp whiteTurn

        ocupada2:
            imprimir salto, 0d
            imprimir mensajeOcupada, 10001110b
            imprimir salto, 0d
            imprimir salto, 0d
            readUntilEnter bufferKey
            jmp blackTurn

        repetir:
            imprimir salto, 0d
            imprimir salto, 0d
            imprimir salir, 15d
            readUntilEnter bufferTeclado
            cmp bufferTeclado[0], "y"
            jz play
            jmp exit

        exit:
            mov ah, 4ch
            INT 21H

    main endp
end