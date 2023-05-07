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
    a dw 0101011111100011b
    b dd 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
    
    mov ebx,0; wir bestimmen das Ergebnis in ebx, weil B ein Doppelwort ist
    or ebx,00000000000000000000000000000000b; Bits 0-3 von B sind 0 
    ;diese Reihe ist unbedigt wichtig, weil ebx am Anfang 0 ist
    
    mov ax,[a]; ax: 0101011111100011b=57E3h 
    and ax,0000111100000000b ; wir isolieren die Bits 8-11 von A
    ;ax: 0000011100000000b=700h
    mov cl, 4
    ror ax,cl; wir rotieren 4 Positionen nach rechts
    ;ax:0000000001110000b=70h
    push 0
    push ax 
    pop eax ; eax:00000000000000000000000001110000b=70h
    ; wir benutzen mit eax, weil B Doppelwort ist 
    or ebx, eax; ebx:00000000000000000000000001110000b=70h
    mov ax, [a]; ax: 0101011111100011b=57E3h 
    and ax,0000000000000011b; wir isolieren die Bits 0-1 von A
    ; ax: 0000000000000011b=3h
    mov cl, 8
    rol ax, cl; wir rotieren 8 Positionen nach links, weil die Bits 8-9 von B dieselbe sind
    ; ax: 0000001100000000b=300h
    push 0 
    push ax 
    pop eax ; eax: 00000000000000000000001100000000b=300h
    or ebx, eax; ebx: 00000000000000000000001101110000b=370h
    or ebx, 00000000000000001111000000000000b; Bits 12-15 von B sind 1 
    ;ebx:   00000000000000001111001101110000b=F370h
    push ebx 
    pop ax ;ax wird die Bits 0-15 von ebx haben 
    ; ax: 1111001101110000b=F370h
    mov bx,ax; bx wird auch die Bits 0-15 von ebx haben 
;bx: 1111001101110000b=F370h    
    push ax 
    push bx 
    pop ebx ;Bits 0-15 werden dieselbe sein wie Bits 16-31
    ;ebx:11110011011100001111001101110000b=F370F370h
    mov [b],ebx; wir verschieben das Ergebnis in B
    
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
