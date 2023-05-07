bits 32
global start 
extern exit
import exit msvcrt.dll 


; we import the "afisare" and "permutation" 
; from Stelli_Janos_713_5_function.asm 
;extern permutation 
extern afisare,permutation 

global a 
global p 
global format 
global pformat 
segment data use32 class=data public 

a dd 123456789
p dd 0 
format db "%x ",0 
pformat db "Permutationen:",0
segment code use32 class=code public 
start:
    ;there is no need to do anything with the 
    ;parameters. They are already accessible to 
    ;the other module (because they are global). 
    
    ;call the functions 
    call afisare
    call permutation  
    
    ;auf den Bildschirm wird "75bcd15 Permutationen:5075bcd1 15075bcd d15075bc cd15075b bcd15075 5bcd1507 75bcd150 75bcd15" stehen 
    
    ;the result in already placed in p by the 
    ;permutation function 
    
    ;call exit(0) 
    push dword 0 
    call [exit] 
    
    
