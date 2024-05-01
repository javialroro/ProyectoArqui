include C:\irvine\Irvine32.inc

.data
    mensaje byte "Ingrese los valores de los polinomios separados por una coma y al terminar incluya un punto",0
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
    

    
    exit
main ENDP
END main
