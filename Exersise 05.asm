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
    s1 db 1, 3, 5, 7
    l equ $-s1; lange der Folge s1/s2(sie haben die gleiche Lange
    s2 db 2, 6, 9, 4
    d times l+l db 0; d wird 2 mal Lage von s1/s2 haben, weil enthalt alle Elemente dieser Folge
; our code starts here
segment code use32 class=code
    start:
        ; ...
    mov ecx, l; wir setzen die Lange l in ecx, um die Schleife zu machen 
    mov edx,0; diese Hilft in d bei der index fur s2, wie ein k, was hilft
    mov esi, 0 ; wir setzen den source index zu 0
    jecxz sfarsit ; short jump to sfarsit if ecx=0 
    repeta:
        mov al, [s1+esi] ; i-te Element von s1 
        mov bl, [s2+esi] ; i-te Element von s2
        mov [d+esi+edx],al; addiert zu Position i+k der i-te Element von s1
        inc edx ; wachst mit 1
        mov [d+esi+edx],bl; addiert zu Position i+k+1 der i-te Element von s2
        inc esi ; wachst mit 1
    loop repeta 
    sfarsit:
    ;Anhand der Beispiel sieht es so aus:
    ;(als Tabel werde ich es darstellen)    
    ;ecx:l=4,
    ;edx:0                  
    ;esi:0     
    ;al:1      al:3          al:5            al:7
    ;bl:2      bl:6          bl:9            bl:4
    ;d:1       d:1,2,3       d:1,2,3,6,5     d:1,2,3,6,5,9,7
    ;edx:1     edx:2         edx:3           edx:4
    ;d:1,2     d:1,2,3,6     d:1,2,3,6,5,9   d:1,2,3,6,5,9,7,4
    ;esi:1     esi:2         esi:3           esi:4
    ;ecx:3     ecx:2         ecx:1           ecx:0
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
