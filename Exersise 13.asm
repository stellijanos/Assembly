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
    a dd 23  ;a wird mit 23 deklariert /iitialisiert
    b dd 5   ; b wird mit 5 deklariert /initialisiert
    format db "%d mod %d=%d",0 ; mit Hilfe von diese wird "23 mod 5=3" auf den Bildschirm ausgedruckt sein 
    ; %d steht fur decimal, also der wert wird in basis 10 ausgedruckt sein
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax,[a]  ; eax wird 23 speichern
        mov edx,0    ; weil der Division des Doppelwortes von a durch Doppelwort b nicht funktioniert,soll deswegen a= 23 in edx:eax gespeicert sein ; edx:eax: 23, so wird Quadwort durch Doppelwort geteilt
        mov ecx,[b] ;ecx: 5, weil b Doppelwort ist
        div ecx     ;in eax wird a div b=23 div 5=4 liegen und in edx wird a mod b=23 mod 5=3 liegen
        mov eax,[a]  ;a wird wieder ins eax gesetzt, weil wir von Wert auf a auf den Stack push-en wollen
        push dword edx ;der Rest wird auf den Stack gepusht also 3 
        push dword ecx ;der Wert von b wird auf den Stack gepusht also 5 
        push dword eax ;der Wert von a wird auf den Stack gepusht also 25
        ;es wird in dieser Reihenfolge gepusht, weil ein Stapel ist und LIFO 
        push dword format ;"%d mod %d=%d" wird auf den Stack gepusht
        call [printf] ;"23 mod 5=3" wird auf den Bildschirm ausgedruckt sein
        add esp,4*4   ;clean-up (aufsaubern) der Stapel 
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
