include C:\irvine\Irvine32.inc

.data
    mensaje byte " Ingrese cada valor del polinomio con la siguiente forma '*valorexponnenteP1*valorexponenteP1;*valorexponenteP2*valorexponenteP2.' ",0
    buffer byte 100 DUP(?)

.code
main PROC
    mov edx, OFFSET mensaje
    call WriteString
    call Crlf

    mov edx, OFFSET buffer ; Load address of buffer
    mov ecx, 100            ; Maximum number of characters to read
    call ReadString         ; Read string from user

    ; Your code to process the input goes here
    mov esi, OFFSET buffer ; Puntero al comienzo del buffer

evalLoop:
    mov al, [esi] ; Carga el byte apuntado por esi en al
    cmp al, '.'   ; Compara con '.'
    je salir      ; Si es un punto, salta a salir
    cmp al, '*'   ; Compara con ','
    je avanzar    ; Si es una coma, avanza al siguiente carácter
    cmp al, ';'   ; Compara con ';'
    je avanzar2 ; Si es un punto y coma, añade el valor a la segunda lista dinamica
    jmp anadirLista ; Si no es ni punto ni coma, añade el valor a la primera lista dinamica
    inc esi       ; Incrementa el puntero al buffer
    jmp evalLoop  ; Salta al siguiente ciclo

evalLoop2:
; Aqui se añade el valor a la segunda lista dinamica
    mov al, [esi] ; Carga el byte apuntado por esi en al
    cmp al, '.'   ; Compara con '.'
    je salir      ; Si es un punto, salta a salir
    cmp al, ','   ; Compara con ','
    je avanzar2    ; Si es una coma, avanza al siguiente carácter
    jmp anadirLista2 ; Si no es ni punto ni coma, añade el valor a la segunda lista dinamica
    inc esi       ; Incrementa el puntero al buffer
    jmp evalLoop  ; Salta al siguiente ciclo


avanzar:
    inc esi       ; Avanza al siguiente carácter
    jmp evalLoop  ; Salta al siguiente ciclo
avanzar2:
    inc esi       ; Avanza al siguiente carácter
	jmp evalLoop2  ; Salta al siguiente ciclo
anadirLista:                                                ;Quede aqui para hacer lo de los valores
; Aqui se añade el valor a la lista dinamica
    call WriteChar
    inc esi       ; Avanza al siguiente carácter
    jmp evalLoop  ; Salta al siguiente ciclo
 anadirLista2:
; Aqui se añade el valor a la segunda lista dinamica
	call WriteChar
    mov al, '2'
    call WriteChar
    inc esi       ; Avanza al siguiente carácter
    jmp evalLoop2  ; Salta al siguiente ciclo
    

salir:
    call Crlf     ; Imprime una nueva línea
    call ExitProcess ; Termina el programa

main ENDP
END main
