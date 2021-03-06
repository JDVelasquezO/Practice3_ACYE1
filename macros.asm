include archivos.asm

imprimir macro cadena, color
    mov ax, @data ;Moviendo el segmento de data al registro de proposito general
    mov ds, ax

    mov ah, 09h ;Tipo de operacion de 21h muestra caracteres, basicamente print
    mov bl, color ;Color del texto de salida
    mov cx, lengthof cadena - 1 ;Pintar el texto en su totalidad
    int 10h ;Interrupcion para dar color
    lea dx, cadena ;Mostrando la cadena
    int 21h ;Interrupcion para mostrar print()
endm

; IMPRIMIR NUMERO DE DOS DIGITOS
; -------------------------------------------
ImprimirNumero macro registro
    push ax
    push dx


    mov dl,registro
    ;ah = 2
    add dl,48
    mov ah,02h
    int 21h


    pop dx
    pop ax
endm

Imprimir8bits macro registro
    local cualquiera,noz
    xor ax,ax
    mov al,registro
    mov cx,10
    mov bx,3
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,3
    noz:
    pop dx
    ImprimirNumero dl
    dec bx
    jnz noz
endm
; -------------------------------------------
VerNumero macro registro
    push ax
    push dx

    mov dl,registro
    ;ah = 2
    add dl,48
    mov bufferNumber1, dl

    pop dx
    pop ax
endm

convertir8bits macro registro
    local cualquiera,noz
    xor ax,ax
    mov al,registro
    mov cx,10
    mov bx,3
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,3
    noz:
    pop dx
    VerNumero dl
    dec bx
    jnz noz
endm

print macro string

    mov dx, offset string		; mover donde empieza el mensaje
	mov ah, 09h 				; Para imprimir un caracter en pantalla
	INT 21H
endm

printRegister macro register
	push ax
	push dx
	
	mov dl,register
	add dl,48 		; Se le suma 48 por el codigo ascii
	mov ah,02h
	int 21h
	
	pop dx
	pop ax
endm

clearTerminal macro   ; clear o cls
    mov ax, 03h 
    int 10h
endm

getIn macro
    mov ah, 01h
    int 21h
endm

readUntilEnter macro entrada
    local salto, fin

    xor bx, bx ;Limpiando el registro
    salto:
        mov ah, 01h
        int 21h
        cmp al, 0dh ;Verificar si es un salto de linea lo que se esta leyendo
        je fin
        mov entrada[bx], al
        inc bx
        jmp salto

    fin:
        mov al, 24h ;Agregando un signo de dolar para eliminar el salto de linea
        mov entrada[bx], al
endm

CrearEspacio macro registro
	push ax
	push dx
	
	mov dl,registro
	mov ah,02h
	int 21h
	
	pop dx
	pop ax
endm

ImprimirEspacio macro registro
	push ax
	push dx
	
	mov registro, 13
	CrearEspacio al
	mov registro, 10
	CrearEspacio al
	
	pop dx
	pop ax
endm

verificarValor macro
    mov color, 14d
    mov individual[0], "O"
endm

imprimirMatriz macro
    local ciclo, ciclo2, ciclo3, ciclo4, reinicio, reinicio2, regreso1, quitChars, blackToken, moveCellImpair, regresoImpair1, validateImpair, incrementForImpairBlack, incrementForImpair, validateImpair, pairFile, regresoPair1, validatePair, moveCell, fin, fillRow, fillRow2

    imprimir espacio, 0d    ; color negro
    imprimir espacio, 0d 
    xor si, si
    ; Ciclo para imprimir las cabeceras de columnas de la matriz
    ciclo:
        ; Se mueve hacia una variable que simula un caracter, porque el macro imprimir 
        ; realiza la impresion hasta que encuentra el simbolo de final de cadena
        mov bl, cabecerasC[si]
        mov individual[0], bl
        imprimir individual, 15d
        imprimir espacio, 0d
        imprimir espacio, 0d
        imprimir espacio, 0d
        inc si
        cmp si, 8d
        jnz ciclo

    imprimir salto, 0d
    xor si, si
    mov iteradorK, 0d
    ciclo2: ; Ciclo que imprime las caberas de las filas
        xor di, di
        mov bl, cabecerasF[si]
        mov individual[0], bl
        imprimir individual, 15d
        imprimir espacio, 0d
        mov iteradorI, 0d
        
        ciclo3: ;ciclo que imprime los valores de las celdas
            cmp si, 0
            je pairFile
            cmp si, 1
            je pairFile
            cmp si, 2
            je pairFile
            cmp si, 3
            je quitChars
            cmp si, 4
            je quitChars
            cmp si, 5
            je blackToken
            cmp si, 6
            je blackToken
            cmp si, 7
            je blackToken
            mov individual, " "

            ; printRegister ah
            regreso1:
            imprimir individual, color
            inc di
            inc iteradorI
            
            cmp iteradorI, 8d
            jz reinicio
 
            imprimir espacio, 0d
            mov bl, lineas[0]
            mov individual[0], bl
            imprimir individual, 15d
            imprimir espacio, 0d
            jmp ciclo3

        quitChars:
            mov individual, " "
            jmp regreso1

        blackToken:
            xor ax, ax
            xor dx, dx
            mov ax, si
            mov bl, 2
            div bl
            cmp ah, 0
            jne moveCellImpair

            regresoImpair1:
            xor ax, ax
            xor dx, dx
            mov ax, di
            mov bl, 2
            div bl
            cmp ah, 0
            je validateImpair
            mov individual, " "
            jmp regreso1

        moveCellImpair:
            cmp di, 0
            je incrementForImpair
            jmp regresoImpair1

        validateImpair:
            mov color, 14d
            mov individual[0], "B"

            cmp si, 5
            je fillRow2
            cmp si, 7
            je fillRow2

            mov pointer1, si
            mov pointer2, di
            obtenerIndice pointer1, pointer2
            mov pointerGeneral, di
            xor di, di
            mov di, indice
            mov tablero[di], 1d
            xor di, di
            mov di, pointerGeneral

            jmp regreso1

        fillRow2:
            mov pointer1, si
            dec di
            mov pointer2, di
            obtenerIndice pointer1, pointer2
            inc di
            mov pointerGeneral, di
            xor di, di
            mov di, indice
            mov tablero[di], 1d
            xor di, di
            mov di, pointerGeneral
            jmp regreso1

        pairFile:
            xor ax, ax
            xor dx, dx
            mov ax, si
            mov bl, 2
            div bl
            cmp ah, 0
            jne moveCell
            
            regresoPair1:
            xor ax, ax
            xor dx, dx
            mov ax, di
            mov bl, 2
            div bl
            cmp ah, 0
            je validatePair
            mov individual, " "
            jmp regreso1

        moveCell:
            cmp di, 0
            je incrementForImpair
            jmp regresoPair1
            
        incrementForImpair:
            inc di
            jmp regresoPair1

        validatePair:
            ; inc di
            mov color, 14d
            mov individual[0], "N"

            cmp si, 1
            je fillRow

            mov pointer1, si
            mov pointer2, di
            obtenerIndice pointer1, pointer2
            mov pointerGeneral, di
            xor di, di
            mov di, indice
            mov tablero[di], 2d
            xor di, di
            mov di, pointerGeneral
            jmp regreso1

        fillRow:
            mov pointer1, si
            dec di
            mov pointer2, di
            obtenerIndice pointer1, pointer2
            inc di
            mov pointerGeneral, di
            xor di, di
            mov di, indice
            mov tablero[di], 2d
            xor di, di
            mov di, pointerGeneral
            jmp regreso1

        reinicio: ;ciclo que imprime la linea divisoria entre filas
            ; printRegister ah
            cmp si, 8d
            jz reinicio2
            mov iteradorI, 0d
            imprimir salto, 0d  
            imprimir espacio, 0d
            imprimir espacio, 0d
            ciclo4:
                mov bl, lineas[1]
                mov individual[0], bl
                imprimir individual, 15d
                inc iteradorI
                cmp iteradorI, 32d
                jnz ciclo4

        reinicio2:
            imprimir salto, 0d
            inc si
            inc iteradorK
            cmp si, 8d
            jnz ciclo2
    fin:
endm

leerCelda macro name
    local inicio, ciclo, ciclo2, ciclo3, ciclo4, asignar, asignar2, asignar3, asignar4, badMoveVertical, badMoveHorizontal, fin, generateReport

    inicio:
        print name, 15d
        print digitEnter
        readUntilEnter bufferTeclado

        cmp bufferTeclado[0], "R"
        je generateReport

        xor ax, ax
        xor bx, bx
        xor si, si
        xor di, di

        mov ah, bufferTeclado[1]
        mov al, bufferTeclado[0]
        mov bh, bufferTeclado[4]
        mov bl, bufferTeclado[3]

        cmp ah, bh
        je badMoveVertical
        cmp al, bl
        je badMoveHorizontal

    ; CICLO PARA FILA 1
    ciclo:
        cmp cabecerasF[di], ah
        jz asignar
        inc di
        cmp di, 8d
        jnz ciclo

    imprimir salto, 0d
    imprimir name, 1100b
    imprimir valida, 1100b
    imprimir salto, 0d
    imprimir salto, 0d
    jmp inicio

    asignar:
        mov fila1, di

    ; CICLO PARA FILA 2
    ciclo2:
        cmp cabecerasF[si], bh
        jz asignar2
        inc si
        cmp si, 8d
        jnz ciclo2

    imprimir salto, 0d
    imprimir name, 1100b
    imprimir valida, 1100b
    imprimir salto, 0d
    imprimir salto, 0d
    jmp inicio

    asignar2:
        mov fila2, si

    xor di, di
    ; CICLO PARA COLUMNA 1
    ciclo3:
        cmp cabecerasC[di], al
        jz asignar3
        inc di
        cmp di, 8d
        jnz ciclo3

    imprimir name, 1100b
    imprimir valida, 1100b
    imprimir salto, 0d
    jmp inicio

    asignar3:
        mov columna1, di

    xor si, si
    ; CICLO PARA COLUMNA 2
    ciclo4:
        cmp cabecerasC[si], bl
        jz asignar4
        inc si
        cmp si, 8d
        jnz ciclo4

    imprimir name, 1100b
    imprimir valida, 1100b
    imprimir salto, 0d
    jmp inicio

    asignar4:
        mov columna2, si
        jmp fin

    badMoveVertical:
        imprimir salto, 0d
        imprimir name, 1100b
        imprimir mensajeBadMoveV, 1100b
        imprimir salto, 0d
        imprimir salto, 0d
        jmp inicio

    badMoveHorizontal:
        imprimir salto, 0d
        imprimir name, 1100b
        imprimir mensajeBadMoveH, 1100b
        imprimir salto, 0d
        imprimir salto, 0d
        jmp inicio

    generateReport:
        clearTerminal
        print mensajeReporte
        CreateFile input, handle
        OpenFile input, handle
        ; HEAD
        WriteFile handle, doctype, 15
        WriteFile handle, lang, 6
        WriteFile handle, initHead, 6
        WriteFile handle, linkBulma, 89
        WriteFile handle, titleReports, 22
        WriteFile handle, finHead, 7

        ; BODY
        WriteFile handle, initBody, 6
        ; HEADER
        WriteFile handle, initHeader, 8
        WriteFile handle, initNav, 87
        WriteFile handle, initNavbar, 26
        WriteFile handle, titleBody, 46
        WriteFile handle, endNavbar, 6
        WriteFile handle, endNav, 6
        WriteFile handle, endHeader, 9
        ; MAIN
        WriteFile handle, initMain, 29
        WriteFile handle, initCols, 21
        WriteFile handle, initTableCol, 28
        WriteFile handle, initThead, 7
        WriteFile handle, initRowPlayers, 4
        WriteFile handle, namePlayerHeader, 28
        WriteFile handle, scorePlayerHeader, 28
        WriteFile handle, endRowPlayers, 5
        WriteFile handle, endThead, 8

        WriteFile handle, initTbody, 7
        
        WriteFile handle, initRowPlayers, 4
        WriteFile handle, initTd, 4
        WriteFile handle, bufferP1, 2
        WriteFile handle, endTd, 5
        WriteFile handle, initTd, 4
        convertir8bits storeP1
        ; mov storeP1, bufferNumber
        WriteFile handle, bufferNumber1, 3
        WriteFile handle, endTd, 5
        WriteFile handle, endRowPlayers, 5

        WriteFile handle, initRowPlayers, 4
        WriteFile handle, initTd, 4
        WriteFile handle, bufferP2, 3
        WriteFile handle, endTd, 5
        WriteFile handle, initTd, 4
        convertir8bits storeP2
        ; mov storeP2, bufferNumber
        WriteFile handle, bufferNumber1, 3
        WriteFile handle, endTd, 5
        WriteFile handle, endRowPlayers, 5

        WriteFile handle, endTbody, 8

        WriteFile handle, endTableCol, 8

        WriteFile handle, initColTable, 20
        WriteFile handle, labelTable, 31
        WriteFile handle, tabForTable, 33
        
        WriteFile handle, initRowPlayers, 4
        printCol
        WriteFile handle, endRowPlayers, 5

        printRow

        WriteFile handle, endCols, 6

        WriteFile handle, endCols, 6
        WriteFile handle, endMain, 7

        WriteFile handle, endBody, 7
        WriteFile handle, endHtml, 7
        CloseFile handle
        readUntilEnter bufferKey

    fin:
endm

printCol macro
    local ciclo, fin
    xor di, di
    ciclo:
        WriteFile handle, initTd, 4
        mov bl, cabecerasC[di]
        mov individual[0], bl
        WriteFile handle, individual, 1
        WriteFile handle, endTd, 5
        inc di
        cmp di, 8d
        jne ciclo
        jmp fin
    
    fin:
endm

printRow macro
    local ciclo, fin
    xor si, si
    ciclo:
        WriteFile handle, initRowPlayers, 4
        
        WriteFile handle, initTd, 4
        mov bl, cabecerasF[si]
        mov individual[0], bl
        WriteFile handle, individual, 1
        WriteFile handle, endTd, 5

        printCell
        WriteFile handle, endRowPlayers, 5
        inc si
        cmp si, 8d
        jne ciclo
        jmp fin

    fin:
endm

printCell macro
    local ciclo, fin
    xor di, di
    ciclo:
        WriteFile handle, initTd, 4
        
        mov pointer1, si
        mov pointer2, di
        obtenerIndice pointer1, pointer2
        mov pointerGeneral, di
        xor di, di
        mov di, indice
        mov bl, tablero[di]
        verificarValor1 bl
        WriteFile handle, individual, 1
        xor di, di
        mov di, pointerGeneral
        WriteFile handle, endTd, 5
        inc di
        cmp di, 7d
        jne ciclo
        jmp fin
    
    fin:
endm

obtenerIndice macro row, column
    ;posicion[i][j] en el arreglo = i * numero columnas + j
    mov ax, row
    mov bx, 8d
    mul bx
    add ax, column
    mov indice, ax
endm

reImprimirMatriz macro
    local ciclo, ciclo2, ciclo3, ciclo4, reinicio, reinicio2, fin

    imprimir espacio, 0d    ; color negro
    imprimir espacio, 0d 
    xor si, si
    ; Ciclo para imprimir las cabeceras de columnas de la matriz
    ciclo:
        ; Se mueve hacia una variable que simula un caracter, porque el macro imprimir 
        ; realiza la impresion hasta que encuentra el simbolo de final de cadena
        mov bl, cabecerasC[si]
        mov individual[0], bl
        imprimir individual, 15d
        imprimir espacio, 0d
        imprimir espacio, 0d
        imprimir espacio, 0d
        inc si
        cmp si, 8d
        jnz ciclo

        imprimir salto, 0d
        xor si, si
        mov iteradorJ, 0d
        ciclo2: ; Ciclo que imprime las caberas de las filas
            xor di, di
            mov bl, cabecerasF[si]
            mov individual[0], bl
            imprimir individual, 15d
            imprimir espacio, 0d

            mov iteradorI, 0d
            ciclo3: ;ciclo que imprime los valores de las filas
                mov di, iteradorJ
                verificarValor1 tablero[di]
                inc iteradorJ
                imprimir individual, color

                inc iteradorI ;validacion para hacer linea divisioria
                cmp iteradorI, 8d
                jz reinicio

                imprimir espacio, 0d
                mov bl, lineas[0]
                mov individual[0], bl
                imprimir individual, 15d
                imprimir espacio, 0d            
                jmp ciclo3
            
            reinicio: ;ciclo que imprimie la linea divisoria entre filas
                cmp si, 8d
                jz reinicio2
                mov iteradorI, 0d
                imprimir salto, 0d  
                imprimir espacio, 0d
                imprimir espacio, 0d
                ciclo4:
                    mov bl, lineas[1]
                    mov individual[0], bl
                    imprimir individual, 15d
                    inc iteradorI
                    cmp iteradorI, 32d
                    jnz ciclo4
            
            reinicio2:
            imprimir salto, 0d
            inc si
            cmp si, 8d
            jnz ciclo2
            
    fin:
endm

verificarValor1 macro valor
    local cero, uno, dos, tres, cuatro, fin

    cmp valor, 0
    jz cero

    cmp valor, 1
    jz uno

    cmp valor, 2
    jz dos

    cmp valor, 3
    jz tres

    cmp valor, 4
    jz cuatro

    cuatro:
        mov color, 12d
        mov individual[0], "R"
        jmp fin

    tres:
        mov color, 13d
        mov individual[0], "R"
        jmp fin

    dos:
        mov color, 14d
        mov individual[0], "N"
        jmp fin

    uno:
        mov color, 11d
        mov individual[0], "B"
        jmp fin

    cero:
        mov color, 0d
        mov individual[0], " "

    fin:
endm

validateScore macro row1, row2, col1, col2
    local validateCols, getCol, markWin, fin, getIndex

    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor di, di

    mov ax, row1    ; 3
    mov bx, row2    ; 1
    sub ax, bx      ; 2
    cmp ax, 2       ; true
    je validateCols
    jmp fin

    validateCols:
        inc bx              ; 2
        mov rowKilled, bx   ; row -> 2
        
        xor ax, ax
        xor bx, bx
        mov ax, col1        ; 4
        mov bx, col2        ; 6

        cmp bx, ax          ; ??6 = 4?
        jl getCol           ; ir si 6<4
        mov cx, ax          ; 4
        inc cx              ; 5
        mov colKilled, cx   ; col -> 5
        jmp getIndex
    
    getCol:
        mov cx, bx              ; 0
        inc cx                  ; 1
        mov colKilled, cx       ; col -> 1

    getIndex:
        obtenerIndice rowKilled, colKilled
        mov di, indice
        cmp tablero[di], 0d
        jne markWin
        jmp fin

    markWin:
        mov tablero[di], 0d
        inc storeP1

    fin:
endm

validateScore2 macro row1, row2, col1, col2
    local validateCols, getCol, markWin, fin, getIndex
    
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor di, di

    mov ax, row1    ; 1
    mov bx, row2    ; 3
    sub bx, ax      ; 2
    cmp bx, 2       ; true
    je validateCols
    jmp fin

    validateCols:
        inc ax              ; 2
        mov rowKilled, ax   ; row -> 2
        
        xor ax, ax
        xor bx, bx
        mov ax, col1        ; 6
        mov bx, col2        ; 4

        cmp bx, ax          ; ??4 = 6?
        jl getCol           ; ir si 4<6
        mov cx, ax          
        inc cx              
        mov colKilled, cx   
        jmp getIndex
    
    getCol:
        mov cx, bx              ; 4
        inc cx                  ; 5
        mov colKilled, cx       ; col -> 5

    getIndex:
        obtenerIndice rowKilled, colKilled
        mov di, indice
        cmp tablero[di], 0d
        jne markWin
        jmp fin

    markWin:
        mov tablero[di], 0d
        inc storeP2

    fin:
endm

validateCheckers macro fila2, columna2
    local createCheckers, fin

    xor ax, ax
    xor di, di
    cmp fila2, 0d
    je createCheckers
    jmp fin

    createCheckers:
        ImprimirEspacio al
        print bufferP1
        print mensajeDama
        ; readUntilEnter bufferKey
        obtenerIndice fila2, columna2
        mov di, indice
        mov tablero[di], 3d
        verificarValor tablero[di]
        reImprimirMatriz
    fin:
endm

validateCheckers2 macro fila2, columna2
    local createCheckers, fin

    xor ax, ax
    xor di, di
    cmp fila2, 7d
    je createCheckers
    jmp fin

    createCheckers:
        ImprimirEspacio al
        print bufferP1
        print mensajeDama
        ; readUntilEnter bufferKey
        obtenerIndice fila2, columna2
        mov di, indice
        mov tablero[di], 4d
        verificarValor tablero[di]
        reImprimirMatriz
    fin:
endm

validateWinner macro
    local ciclo, ciclo2, fin, looser

    xor di, di
    ciclo:
        cmp tablero[di], 1d
        je fin
        inc di
        cmp di, 64
        jne ciclo
    
    xor si, si
    ciclo2:
        cmp tablero[si], 3d
        je fin
        inc si
        cmp si, 64
        jne ciclo2

    looser:
        ImprimirEspacio al
        print bufferP2
        print mensajeGanador
        ImprimirEspacio al
        print bufferP1
        print mensajePerdedor
        readUntilEnter bufferKey
        mov someWinner, 1d

    fin:
endm

validateWinner2 macro
    local ciclo, ciclo2, fin, looser

    xor di, di
    ciclo:
        cmp tablero[di], 2d
        je fin
        inc di
        cmp di, 64
        jne ciclo
    
    xor si, si
    ciclo2:
        cmp tablero[si], 4d
        je fin
        inc si
        cmp si, 64
        jne ciclo2

    looser:
        ImprimirEspacio al
        print bufferP1
        print mensajeGanador
        ImprimirEspacio al
        print bufferP2
        print mensajePerdedor
        readUntilEnter bufferKey
        mov someWinner, 1d

    fin:
endm