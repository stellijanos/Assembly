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
    s1 db 1, 2, 3,4 
    l equ $-s1; Lange der Folge s1  
    s2 db 5 , 6, 7, 8
    d times l db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
    mov ecx, l; ecx wird die Langa von s1, also 4 speichern
    mov esi,0; source index wird mit 0 initalisiert
    ;diese fur die Indexen de s1,s2
    jecxz sfarsit; jump to sfarsit if ecx is 0
    repeta:
        mov al,[s1+esi] 
        mov bl,[s2+esi] 
        test esi,1 ; operatie and intre esi si 1
        jnz dacaimpar
        adc al,bl ; addition mit carryflag
        jmp dacapar
        dacaimpar:
        sbb al,bl; subtraktion mit carryflag
        dacapar:
        mov [d+esi],al; d wird al auf index esi speichern 
        inc esi
    loop repeta; geht zuruck zur repeta und macht dec ecx(= ecx=ecx-1)
    
    sfarsit: ;ende des Programms
    
    ;Nummerisch sieht es so aus:
    ;ecx=4; esi=0; al=1 und bl=5; al=al+bl=> d: 6
    ;ecx=3; esi=1; al=2 und bl=6; al=al-bl=-4=> d:6, -4 
    ;ecx=2; esi=2; al=3 und bl=7; al=al+bl=10=> d:6,-4,10
    ;ecx=1; esi=3; al=4 und bl=8; al=al-bl=-4=>d:6,-4,10,-4 
    ;ecx=0=>sfarsit:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
