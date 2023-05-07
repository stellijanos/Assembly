bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 1100010101111000b
    b dw 0001111101010011b 
    c dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
    mov ebx, 0; ich berechne das Ergebnis in ebx, weil C doubleword ist
    ;ebx=00000000000000000000000000000000h
    mov ax, [a] ; ax=1100010101111000b=C578h 
    and ax,0000000111111000b; ich isoliere die Bits 3-8 von A 
    ;ax=0000000101111000b=178h
    push 0 
    push ax 
    pop eax; eax=00000000000000000000000101111000b=178h; weil C doubleword ist
    mov cl,3 
    ror eax, 3 ; ich rotiere 3 Positionen nach rechts, weil C diese als 0-5 Bits hat
    ; eax=00000000000000000000000000101111b=2Fh
    or ebx, eax; ich fuge die Bits in das Ergebnis ein
    ; ebx=00000000000000000000000000101111b=2Fh
    mov ax, [b] ; ax=0001111101010011b
    and ax,0000000000011100b ; ich isoliere die Bits 2-4 von B
    ; ax=0000000000010000b=10h 
    push 0 
    push ax 
    pop eax ; eax=00000000000000000000000000010000b=10h; weil C doubleword ist
    mov cl, 4 
    rol eax, cl; ich rotiere 4 Positionen nach links, weil C diese als 6-8 Bits hat
    ; eax=00000000000000000000000100000000b=100h
    or ebx, eax ; ich fuge die Bits in das Ergebnis ein
    ; ebx=00000000000000000000000100101111b=12Fh
    mov ax, [a] 
    and ax, 0001111111000000b ; ich isoliere die Bits 6-12 von A
    ;ax=0000010101000000b=540h 
    push 0 
    push ax 
    pop eax ; eax=00000000000000000000010101000000b=540h; weil C doubleword ist
    mov cl, 3
    rol eax, cl; ich rotiere Positionen nach links, weil C diese als 9-12 Bits hat
    ; eax=00000000000000000010101000000000b=2A00h
    or ebx, eax; ich fuge die Bits in das Ergebnis ein
    ; ebx=00000000000000000010101100101111b=2B2Fh
    and ebx, 00000000000000001111111111111111b; ich fuge 0-en auf Bits 16-31, weil C diese als 16-31 Bits hat
    ;ebx=00000000000000000010101100101111b=2B2Fh
    mov [c], ebx; verschiebe ich das Ergebnis 00000000000000000010101100101111b=2B2Fh aus dem Register in die Ergebnisvariable
    
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
