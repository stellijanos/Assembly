bits 32
;we export the 'afisare' and 'permutaion' functions 
; in order to be used in the main module 

global afisare 
global permutation 


import printf msvcrt.dll 
extern printf 
;import the a,p variables from the other module 
extern a,p,format,pformat

segment code use32 class=code public 
; the code segment contains only the afisare
;and permutaion functions 

afisare: 
    push dword [a]  ;push dword 123 auf den Stack 
    push dword format ;"%x" bedeutet in basis 16 
    call [printf]  ;"75bcd15" wird auf den Bildschirm ausgedruckt
    add esp,4*2  ;clean-up the Stack; 4-bytes weil dword
                   ; 2-Anzahl der Parametern (2-mal pushen)
    ret 
    
permutation:
    push dword pformat
    call [printf] 
    add esp, 4
     
    mov ebx,8
    bucla: 
        cmp ebx,0 
        je sfarsit ;jump if egal to sfarsit wenn ebx=0 
        mov eax,[a] ;eax wird nach der Reihe nach den Wert von a speichern 
        mov cl,4   ;4 weil in Basis 16 (von 0-F ist je 4 dargestellt ) 
        ror eax,cl ;rotieren nach rechts mit 4 Positionen 
        mov [a],eax ; a wird die nach rechts hexa Permutierte Wert speichern 
        push dword [a]   ;Wert von a auf den Stack 
        push dword format ; "%x" auf den Stack 
        call [printf]   ;call printf 
        add esp,4*2    ;clean-up the stack 
        dec ebx   ;decrementieren von ebx 
    jmp bucla    ;jump zur bucla: 
    sfarsit:   ;Ende der Schleife 
    ret 