include C:\irvine\Irvine32.inc

; Define la estructura de un nodo de la lista enlazada
Node STRUCT
    valor       DWORD ?
    exponente   DWORD ?
    next        DWORD ?
Node ENDS

; Define una macro para crear un nuevo nodo
.code
CreateNode PROC 
    LOCAL newNode
    mov   newNode, 0
    call GetProcessHeap
    invoke HeapAlloc, eax, HEAP_ZERO_MEMORY, SIZEOF Node
    mov   newNode, eax
    mov   eax, 3
    mov   [newNode].Node.valor, eax
    mov   eax, 2
    mov   [newNode].Node.exponente, eax
    ret
CreateNode ENDP

ImprimirLista PROC
    LOCAL currentNode:DWORD

    ; Puntero al primer nodo de la lista
    mov   currentNode, OFFSET listaDinamica1

printLoop:
    ; Verifica si el nodo actual es nulo (fin de la lista)
    cmp   [currentNode], 0
    je    printEnd

    ; Imprime los valores del nodo actual
    mov   eax, [currentNode].Node.valor      ; Valor del nodo
    call  WriteDec                           ; Imprime el valor
    mov   eax, [currentNode].Node.exponente  ; Exponente del nodo
    call  WriteDec                           ; Imprime el exponente
    call  Crlf                               ; Nueva línea

    ; Avanza al siguiente nodo en la lista
    mov   eax, [currentNode].Node.next      ; Dirección del siguiente nodo
    mov   currentNode, eax                  ; currentNode apunta al siguiente nodo
    jmp   printLoop                         ; Repite el proceso

printEnd:
    ret
ImprimirLista ENDP


