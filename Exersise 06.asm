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
    s db 1, 2, 3, 4 
    l equ $-s; lange der Folge s
    d times l dw 0 ; l-1 bytes werden mit Null initialisiert
    
    

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, l; wegen der Schleife l in ecx
        dec ecx; weil d lange von s-1 ist
        mov esi, 0; index zahler mit 0 initialisieren
        jecxz sfarsit; jump short if ecx is 0
        repeta:
            mov al, [s+esi] ; i -te element von s in al
            mov bl, [s+esi+1] ; i+1 -te element von s in bl
            mul bl ; ax=al*bl
            mov [d+esi],ax ; in dx ax=al*bl speichern
            inc esi; indexzahler steigt mit 1
        loop repeta
        
        ;Dieser Beispiel sieht nummerisch folgenderweise aus:
        ; ecx: 3; esi: 0; al:1; bl:2; ax:1*2=2; d: 2 
        ; ecx: 2; esi:1; al:2 bl:3; ax:2*3=6; d:2, 6 
        ;ecx: 1; esi:0; al:3; bl:4; ax:3*4=12; d:2, 6, 12 
        
        sfarsit: ; das Programm spring hier wenn in ecx 0 ist
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
