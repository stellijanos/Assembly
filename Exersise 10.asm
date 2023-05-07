bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fprintf,fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fprintf msvcrt.dll 
import fclose msvcrt.dll 

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db "output.txt",0; filneme to be read
    access_mode db "w",0       ; file access mode: w-writes to a file and creates if does not exist, and overwrites content of existing file
    
    file_descriptor dd -1; variable to hold the file descriptor
    text db ".Heute 3 12 * @ ist ? Montag.",0; gegebene text
    l equ $-text; l-Lange der gegebenen Text
    

; our code starts here
segment code use32 class=code
    start:
        ; ...
    ; call fopen() to create the file
    ; fopen() will return a file descriptor in the EAX or0 in case of error
    ; eax = fopen(file_name, access_mode)
    
    
    push dword access_mode 
    push dword file_name 
    call [fopen] 
    add esp, 4*2; clean-up the stack 
    
    mov [file_descriptor],eax ;store the file descriptor returned by fopen
    
    ; check if fopen() has successfully created the file (EAX!=0)
    cmp eax,0 
    je final 
    
    ;
    mov ecx,l 
    mov esi,0
    jecxz sfarsit 
    repeta: 
        mov al,[text+esi] 
        cmp al,'a' 
        jl skip  ;wenn ascii code von al ist kleiner als ascii code von 'a'
        cmp al,'z' 
        jg skip ;wenn ascii code von al ist grosser als ascii code von 'z'
        sub al,32 ;macht aus kleine Buchstabe grosse Buchstabe
        mov [text+esi],al; zuruckfugen die Umgewandelte Buchstabe (von klein zur gross) in text
    skip:
    inc esi
    loop repeta
    sfarsit:
    ;
    
    
    ; append the text to file using fprintf()
    ; fprintf(file_descriptor, text)
    push dword text 
    push dword [file_descriptor] 
    call [fprintf] 
    add esp,4*2
    
    ; call fclose() to close the file 
    ; fclose(file_descriptor)
    push dword [file_descriptor] 
    call [fclose] 
    add esp,4 
    
    final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
