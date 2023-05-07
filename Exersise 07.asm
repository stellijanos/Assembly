bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    format db "a = %d (Basis 10), a = %x (Basis 16)",0 ;%d wird mit a ersezt (Basis 10) und %x wird mit a ersetzt (Basis 16)
    a dd 25
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, [a] ;eax wird den Wert 25 speichern
        push dword eax
        push dword eax
        push dword format;Adresse der format auf den Stack 
        call [printf]; aufrufen der Funktion printf; "a = 25 (Basis 10), a = 19 (Basis 16)"
        add esp, 4*3; free parameters on the stack; 4=size of dword; 3=number of parameters
        
        ;Auf dem Bildschrim wird folgendes ausgedruckt werden: 
        ; "a = 25 (Basis 10), a = 19 (Basis 16)"
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program