include C:\irvine\Irvine32.inc


.data
    mensaje byte " Ingrese cada valor del polinomio con la siguiente forma '*valorexponnenteP1*valorexponenteP1;*valorexponenteP2*valorexponenteP2.' ",0
    buffer byte 100 DUP(?)
    mensajeExponente1 byte "El siguiente exponente del polinomio 1 es: ",0
    mensajeValor1 byte "El siguiente valor del polinomio 1 es: ",0
    mensajeExponente2 byte "El siguiente exponente del polinomio 2 es: ",0
    mensajeValor2 byte "El siguiente valor del polinomio 2 es: ",0

    coef dw 0
    exp dw 0
    nulo dd 0
    banderaPolinomio dd 0
    heap db 4096 dup(?)
    freemem dd ?
    p1 dd ?
    p2 dd ?
    p3 dd ?
.code
main PROC
    lea edx, heap
    mov freemem, edx
    mov p1, edx

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
    je avanzar    ; Si es una coma, avanza al siguiente car�cter
    cmp al, ';'   ; Compara con ';'
    je cambioPolinomio ; Si es un punto y coma, a�ade el valor a la segunda lista dinamica
    jmp anadirLista ; Si no es ni punto ni coma, a�ade el valor a la primera lista dinamica
    inc esi       ; Incrementa el puntero al buffer
    jmp evalLoop  ; Salta al siguiente ciclo

evalLoop2:
; Aqui se a�ade el valor a la segunda lista dinamica
    mov al, [esi] ; Carga el byte apuntado por esi en al
    cmp al, '.'   ; Compara con '.'
    je salir      ; Si es un punto, salta a salir
    cmp al, '*'   ; Compara con ','
    je avanzar2    ; Si es una coma, avanza al siguiente car�cter
    cmp al, ';'   ; Compara con ';'
    je avanzar2 ; Si es un punto y coma, a�ade el valor a la segunda lista dinamica
    jmp anadirLista2 ; Si no es ni punto ni coma, a�ade el valor a la primera lista dinamica
    inc esi       ; Incrementa el puntero al buffer
    jmp evalLoop2  ; Salta al siguiente ciclo


cambioPolinomio:
    mov edx, freemem
    mov p2, edx
    add banderaPolinomio, 1
    mov nulo,0
    jmp avanzar2


avanzar:
    inc esi       ; Avanza al siguiente car�cter
    jmp evalLoop  ; Salta al siguiente ciclo
avanzar2:
    inc esi       ; Avanza al siguiente car�cter
	jmp evalLoop2  ; Salta al siguiente ciclo

anadirLista:                                                
; Aqui se a�ade el valor a la lista dinamica
    mov edx, OFFSET mensajeValor1
    call WriteString
    call WriteChar
    mov coef, ax
    inc esi       ; Avanza al siguiente car�cter
    mov al,[esi] ; Carga el byte apuntado por esi en al]
    call Crlf
    mov edx, OFFSET mensajeExponente1
    call WriteString
    call WriteChar
    mov exp, ax
    call Crlf
    sub coef, 30h
    sub exp, 30h
    call createNode
    ; Meter a lista dinamica

    inc esi       ; Avanza al siguiente car�cter
    jmp evalLoop  ; Salta al siguiente ciclo
 
 
 anadirLista2:
; Aqui se a�ade el valor a la lista dinamica
    mov edx, OFFSET mensajeValor2
    call WriteString
    call WriteChar
    mov coef, ax
    inc esi       ; Avanza al siguiente car�cter
    mov al,[esi] ; Carga el byte apuntado por esi en al]
    call Crlf
    mov edx, OFFSET mensajeExponente2
    call WriteString
    call WriteChar
    mov exp, ax
    call Crlf
    sub coef, 30h
    sub exp, 30h
    call createNode
    ; Meter a lista dinamica

    inc esi       ; Avanza al siguiente car�cter
    jmp evalLoop2  ; Salta al siguiente ciclo
    

salir:
    call Crlf     ; Imprime una nueva l�nea
    call ExitProcess ; Termina el programa

main ENDP

createNode PROC
	mov ebx, freemem
    mov dx, coef
    mov [ebx], dl

    add ebx ,1
    mov dx, exp
    mov [ebx], dl

    add ebx, 1
    mov edx, nulo
    cmp nulo, 0
    je primeraCorrida
    sub ebx, 6
    mov edx,nulo
    mov [ebx], edx
	add ebx, 6
    mov nulo, ebx
    add ebx, 4
    mov freemem, ebx
	ret
createNode ENDP

primeraCorrida:
    mov edx, nulo
	mov [ebx], edx
	mov nulo, ebx
	add ebx, 4
	mov freemem, ebx
	ret


END main
