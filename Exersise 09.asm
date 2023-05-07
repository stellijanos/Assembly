bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll ; tell the assembler that the printf function can be found in library msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 40
    b dd 10
    format db "%x",0 ;um das Ergebinis in Basis 16 auf den Bildschirm zu zeigen; &x wird mit a-b ersetzt; a-b wird in eax gespecihert

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax,[a] ; eax wird den Wert 40 haben
        mov ebx,[b] ; ebx wird den Wert 10 haben
        sbb eax,ebx; vorzeichenbehaftete Subtraktion von a-b, weil a kann grosser als b sein
        
        ;will call printf(format,30) =>will print "1E" 
        push dword eax 
        push dword format; on the stack is placed the adress of the string, not its value
        call [printf]; call function printf for printing 
        add esp, 4*2; free parameters on the stack; 4=size of dword (4 Bytes); 2=number of parameters
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program