bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll 
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 0  ;in dieser Variable speichern wir die gelesene Zahl fur a
    b dd 0  ;in dieser Variable speichern wir die gelesene Zahl fur b
    message_a db "a= ",0  
    message_b db "b= ",0
    format_a db "%d",0 ; %d <=>a decimal number (basis 10) 
    format_b db "%d",0 ; %d <=>b decimal number (basis 10)
    format_sum db "%x",0 ; %x <=>a hexadecimal number (basis 16)
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        ;will call printf(message_a) => will print "a= " 
        ;place parameters on stack 
        push dword message_a ; on the stack is placed the address of the string, not its value 
        call [printf]  ; call function printf for printing
        add esp,4*1    ; free parameters on the stack; 4=size of dword (doubleword); 1=number of parameters 
        
        ; will call scanf(format, a) => will read a number i nvariable a
        ; place parameters on stack from right to left
        push dword a ; adress of a, not value 
        push dword format_a 
        call [scanf]        ;call function scanf for reading 
        add esp,4*2      ; free parameters on the stack ; 4 size of a dword; 2=number of parameters 
        
        
        ;will call printf(message_b) => will print "b= " 
        ;place parameters on stack 
        push dword message_b ; on the stack is placed the address of the string, not its value 
        call [printf]  ; call function printf for printing
        add esp,4*1    ; free parameters on the stack; 4=size of dword (doubleword); 1=number of parameters 
        
        ; will call scanf(format, b) => will read a number in variable b
        ; place parameters on stack from right to left
        push dword b ; adress of b, not value 
        push dword format_b
        call [scanf]        ;call function scanf for reading 
        add esp,4*2      ; free parameters on the stack ; 4 size of a dword; 2=number of parameters 
        
        mov eax,[a] 
        add eax,[b]  ;eax: a+b
        mov edx,0 
        mov ecx,2 
        div ecx   ;in edx wird der Rest und in eax wird (a+b) div 2 sein
        
        push dword eax 
        push dword format_sum 
        call [printf]    ;call function printf for printing
        add esp,4*2   ;free parameters on the stack; 4=size of dword; 2 =number of parameters 
        
       
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
