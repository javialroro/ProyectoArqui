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
    punteroNuevoNodo dd 0
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
    call evalLoop         ; Llama a evalLoop

main ENDP

cambioPolinomio:
    mov edx, freemem
    mov p2, edx
    add banderaPolinomio, 1
    mov nulo,0

    ; colocar el valor del puntero de nuevo nodo en 0
    mov punteroNuevoNodo, 0

    inc esi
    jmp evalLoop2

evalLoop:
    mov al, [esi] ; Carga el byte apuntado por esi en al
    cmp al, '.'   ; Compara con '.'
    je salir      ; Si es un punto, salta a salir
    cmp al, '*'   ; Compara con '*'
    je avanzar    ; Si es un asterisco, avanza al siguiente carácter
    cmp al, ';'   ; Compara con ';'
    je cambioPolinomio ; Si es un punto y coma, añade el valor a la segunda lista dinamica
    cmp al, '/'   ; Compara con '/'
    je exponente
    inc esi       ; Incrementa el puntero al buffer
    jmp evalLoop  ; Salta al siguiente ciclo

evalLoop2:
; Aqui se añade el valor a la segunda lista dinamica
    mov al, [esi] ; Carga el byte apuntado por esi en al
    cmp al, '.'   ; Compara con '.'
    je salir      ; Si es un punto, salta a salir
    cmp al, '*'   ; Compara con '*'
    je avanzar2    ; Si es un asterisco, avanza al siguiente carácter
    cmp al, ';'   ; Compara con ';'
    je avanzar2 ; Si es un punto y coma, añade el valor a la segunda lista dinamica
    cmp al, '/'   ; Compara con '/'
    je exponente
    inc esi       ; Incrementa el puntero al buffer
    jmp evalLoop2  ; Salta al siguiente ciclo


exponente:
    inc esi
    call LeerExponente
    call createNode
    inc esi
    jmp evalLoop
    
salir:
    call Crlf     ; Imprime una nueva línea

    ; guarda la posición en memoria del polinomio resultante
    mov edx, freemem
    mov p3, edx
    mov nulo,0

    call sumar
    mov ebx, p3
    call printp3

    call ExitProcess ; Termina el programa



avanzar:
    inc esi       ; Avanza al siguiente carácter
    call LeerNumero ; Lee el número
    inc esi       ; Avanza al siguiente carácter
    jmp evalLoop  ; Salta al siguiente ciclo
avanzar2:
    inc esi       ; Avanza al siguiente carácter
    call LeerNumero ; Lee el número
    inc esi       ; Avanza al siguiente carácter
	jmp evalLoop2  ; Salta al siguiente ciclo

; ////////////////Creacion de polinomios en lista dinamica////////////////
createNode PROC
	mov ebx, freemem

    ; almacenar el valor de memoria del nuevo nodo en la "variable"
    mov punteroNuevoNodo, ebx

    mov dx, coef
    mov [ebx], dx

    ; avanzar dos posiciones en memoria para llegar al exponente (2 bytes de coef)
    add ebx ,2
    mov dx, exp
    mov [ebx], dx

    ; avanzar dos posiciones en memoria para llegar al puntero del siguiente nodo (2 bytes de exp)
    add ebx, 2
    mov edx, nulo
    cmp nulo, 0
    je primeraCorrida

    ; colocar la direccion de memoria del siguiente nodo en el puntero del nodo anterior
    ; nulo almacena la posicion en memoria del puntero nulo anterior
    ; punteroNuevoNodo apunta a la direccion de memoria del nuevo nodo en el coeficiente
    
    mov ebx, nulo
    mov edx, punteroNuevoNodo
    mov [ebx], edx

    ; registro ebx toma direccion en memorio del nuevo nodo
    mov ebx, punteroNuevoNodo
    ; se le suma 4 para colocarse en la posicion de memoria del puntero nulo
    add ebx, 4
    ; nulo toma el valor de la posicion en memoria del nuevo nodo en la parte del puntero
    mov nulo, ebx

    ; se suma 4 a ebx para colocarse en la siguiente posicion de memoria para el siguiente nodo
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


; ////////////////Suma los polinomios////////////////

sumar PROC
    xor eax, eax
    xor ebx, ebx
    mov esi, p1
    mov edi, p2

    jmp sumLoop

    ; Aquí puedes continuar sumando los términos mientras haya nodos disponibles en las listas dinámicas

    ret
sumar ENDP

sumLoop:

    mov eax, [esi+2]
    mov ebx, [edi+2]

    cmp ax, bx

    je iguales

    jg p1mayor

    jl p2mayor



iguales:
    mov exp, bx
    mov ax, [esi]
    mov bx, [edi]
    add ax, bx
    mov coef, ax

    call createNode


    mov ax, [esi+4]
    cmp ax, 0
    je p1finalizadoiguales
    
    mov ax, [edi+4]
    cmp ax, 0
    je p2finalizadoiguales

    mov esi, [esi+4]
    mov edi, [edi+4]
    jmp sumLoop


p1mayor:
    mov exp,ax
    mov bx,[esi]
    mov coef,bx

    call createNode

    mov ax, [esi+4]
    cmp ax, 0
    je p1finalizado
    mov esi, [esi+4]
    jmp sumLoop


p2mayor:
    mov exp,bx
	mov bx,[edi]
	mov coef,bx
	call createNode
	mov ax, [edi+4]
	cmp ax, 0
	je p2finalizado
	mov edi, [edi+4]
	jmp sumLoop

salirSuma:
    ret

p1finalizadoiguales:
	; si el puntero del nodo del segundo polinomio es nulo se sale
    mov ax, [edi+4]
    cmp ax, 0
    je salirSuma

    ; si el puntero del nodo del segundo polinomio no es nulo se avanza al siguiente nodo
    mov edi, [edi+4]
    jmp p1finalizado

p2finalizadoiguales:
	; si el puntero del nodo del primer polinomio es nulo se sale
	mov ax, [esi+4]
	cmp ax, 0
	je salirSuma

	; si el puntero del nodo del primer polinomio no es nulo se avanza al siguiente nodo
	mov esi, [esi+4]
	jmp p2finalizado


p1finalizado:
    mov ax, [edi+4]
    cmp ax, 0
    je colocarultimop2
    mov ax, [edi]
    mov coef, ax
    mov ax, [edi+2]
    mov exp, ax
    call createNode
    mov edi, [edi+4]
    jmp p1finalizado


p2finalizado:
    mov ax, [esi+4]
    cmp ax, 0
    je colocarultimop1
    mov ax, [esi]
    mov coef, ax
    mov ax, [esi+2]
    mov exp, ax
    call createNode
    mov esi, [esi+4]
    jmp p2finalizado

colocarultimop1:
	mov ax, [esi]
	mov coef, ax
	mov ax, [esi+2]
	mov exp, ax
	call createNode
	jmp salirSuma

colocarultimop2:
	mov ax, [edi]
    mov coef, ax
    mov ax, [edi+2]
    mov exp, ax
    call createNode
    jmp salirSuma



;///////////////////////////// Imprimir polinomio /////////////////////////////
printp3 PROC
	mov ax, [ebx]
    test al, 80h
    jnz NegativeNumber
	add ax, 30h
	call WriteChar
    mov ax, '^'
    call WriteChar
	add ebx, 2
	mov ax, [ebx]
	add ax, 30h
	call WriteChar
	add ebx, 4
    mov ax, [ebx]
	cmp ax, 0
	je finprint
    add ebx, 2
    mov ax, ' '
    call WriteChar
	jmp printp3
printp3 ENDP

NegativeNumber:
    push ax
	mov ax, '-'
	call WriteChar
    pop ax
	neg ax
	add ax, 30h
	call WriteChar
    mov ax, '^'
    call WriteChar
    add ebx, 2
	mov ax, [ebx]
	add ax, 30h
	call WriteChar
	add ebx, 4
    mov ax, [ebx]
	cmp ax, 0
	je finprint
    add ebx, 2
    mov ax, ' '
    call WriteChar
	jmp printp3
	

finprint:
	ret


LeerNumero PROC
    xor dx,dx
    xor ax, ax    ; AX = 0, limpia el registro AX
    xor bx, bx    ; BX = 0, limpia el registro BX
    mov cx, 10    ; CX = 10, base 10 para números decimales
LeerLoop:
    mov dl, [esi] ; Carga el byte en la posición ESI en DL
    sub dl, '0'   ; Convierte el carácter ASCII a valor numérico (ej. '3' -> 3)
    add ax, dx
    mov bl , [esi+1]
    cmp bl, '/'
    je finLeer
    mul cx        ; Multiplica DX:AX por CX (10), resultado en DX:AX
    inc esi       ; Incrementa ESI para apuntar al siguiente carácter
    jmp LeerLoop  ; Repite el bucle
finLeer:
    mov coef, ax
    ret           ; Retorna
LeerNumero ENDP


LeerExponente PROC
    xor dx,dx
    xor ax, ax    ; AX = 0, limpia el registro AX
    xor bx, bx    ; BX = 0, limpia el registro BX
    mov cx, 10    ; CX = 10, base 10 para números decimales
LeerLoop:
    mov dl, [esi] ; Carga el byte en la posición ESI en DL
    sub dl, '0'   ; Convierte el carácter ASCII a valor numérico (ej. '3' -> 3)
    add bx, dx
    mov al , [esi+1]
    cmp al, '/'
    je finLeer
    cmp al, '*'
    je finLeer
    cmp al, ';'
    je finLeer
    cmp al, '.'
    je finLeer
    mul cx        ; Multiplica DX:AX por CX (10), resultado en DX:AX
    inc esi       ; Incrementa ESI para apuntar al siguiente carácter
    jmp LeerLoop  ; Repite el bucle
finLeer:
    mov exp, bx
    ret           ; Retorna
LeerExponente ENDP

END main
