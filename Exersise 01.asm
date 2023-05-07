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
    a dw 0011101110000011b 
    b db 10110001b 
    c dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
    mov ebx, 0 ; ich berechne das Ergebnis in ebx, weil C doubleword ist
    or ebx, 00000000000000000000000000001111b ;ich fuge die Bits 1 auf Positionen 0-3 in das Ergebnis ein, weil Bits 0-3 von C haben den Wert 1  
    ;ebx=00000000000000000000000000001111b=Fh
    
    mov ax, [a]; ax=0011101110000011b=3B83h 
    push 0 
    push ax 
    pop eax; eax=00000000000000000011101110000011b=3B83h; weil C doubleword ist
    and eax, 00000000000000000000000000001111b ; wir isolieren die Bits 0-3 von A in ax um zur bx zu addieren; eax=00000000000000000000000000000011b=3h
    mov cl, 4
    rol eax, cl; wir rotieren 4 positionen nach links um die 0-3 Bits auf 4-7 zu haben 
    ;eax=00000000000000000000000000110000b=30h
    or ebx, eax; wir fugen die Bits in das Ergebnis ein;
    ;ebx=00000000000000000000000000111111b=3F
    and ebx, 11111111111111111100000011111111b; ebx=00000000000000000000000000111111b=003Fh 
    ; 8-13 Bits von C sind 0 en und mit Bitmaske and-en
    mov ax, [a] ; ax=0011101110000011b 
    push 0 
    push ax 
    pop eax ; eax=00000000000000000011101110000011b=3B83h 
    and eax,      00000000000000000011111111110000b; isolieren wir die 4-13 Bits von A;
    ;eax=00000000000000000011101110000000b
    mov cl, 10 
    rol eax, cl ; eax=00000000111011100000000000000000b=EE0000h; rotieren wir nach links 10 Positionen weil in C diese sind die 14-23 Bits 
    or ebx, eax;  ebx=00000000111011100000000000111111b=EE003Fh 
    mov al, [b] ; al=10110001b
    mov ah, 0 ; ax=0000000010110001b
    push 0 
    push ax 
    pop eax ; eax=00000000000000000000000010110001b=B1h; weil C dword ist
    and eax,00000000000000000000000011111100b; isolieren wir die Bits 2-7 von B
    ; eax=00000000000000000000000010110000b
    mov cl, 22 
    rol eax, cl; rotieren wir 22 Positionen nach links, weil C diese als Bits 24-29 hat
    ; eax=00101100000000000000000000000000b 
    or ebx, eax; ebx=00101100111011100000000000111111b=2CEE003F 
    or ebx,11000000000000000000000000000000b; Bits 30-31 von C sind 1 und diese fugen wir in das Ergebnis
    ; ebx=11101100111011100000000000111111b=ECEE003F
    mov [c], ebx; verschieben wir das Ergebnis aus dem Register in die Ergebnisvariable 
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
