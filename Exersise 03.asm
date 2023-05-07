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
    a dw 0010111000000111b
    b dw 0111101010100000b
    c dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
    
    mov ebx,0 ; wir bestimmen das Ergebnis in ebx 
    or ebx,00000000000000000000000000011111b ;Bits 0-4 haben den Wert 1
    ; ebx: 00000000000000000000000000011111b=1Fh
    mov ax,[a]; ax: 0010111000000111b=2E07h
    and ax,0000000001111111b ;wir isolieren die Bits 0-6 von A
    ;al: 0000000000000111b=7h
    push 0 
    push ax 
    pop eax ; eax: 00000000000000000000000000000111b=7h, weil A in eax, weil C doppelwort ist
    mov cl,5 
    rol eax,cl; wir rotieren mit 5 Positionen nach links die Bits 0-6 von A, weil die Bits 5-11 von C gleich diese sind
    ;eax: 00000000000000000000000011100000b=E0h
    or ebx, eax; wir fugen die Bits in das Ergebnis ein
    ;ebx:  00000000000000000000000011111111b=FFh
    or ebx,00000000011001010000000000000000b; die Bits 16-31 von C haben den Wert 0000000001100101b 
    ;ebx: 00000000011001010000000011111111b=6500FFh
    mov ax, [b] ;ax:0111101010100000b=7AA0h
    and ax, 0000111100000000b; ax:0000101000000000b=A00h
    push 0 
    push ax 
    pop eax ; eax:00000000000000000000101000000000b=A00h 
    ;verschieben in eax, weil C ein Doppelwort ist
    mov cl,4 
    rol eax,cl ; wir rotieren 4 Positionen nach links
    ;weil die Bits 12-15 von C die Bits 8-11 von B sind
    ;eax:00000000000000001010000000000000b=A000h
    or ebx, eax; wir fugen die Bits in das Ergebnis ein 
    ;ebx:00000000011001011010000011111111b=65A0FFh
    mov [c],ebx; wir verschieben das Ergebnis in C
    
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
