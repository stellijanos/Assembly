bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fread,fclose,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll 
import printf msvcrt.dll 

                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
file_name db "input.txt",0 ;filename to be read
access_mode db "r",0       ;file access mode: r for reading 

file_descriptor dd -1; variable to hold the file descriptor 
len equ 4000          ; maximum number of charcters to be read 

text times (len+1) db 0 ; string to hold the text which is read from file 

 buchstaben db "abcdefghijklmnopqrstuvwxyz"
 formatchar db "%c",0
 formatzahl db ", %d",0
 losung db 0
 max db 0



; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        ;call fopen() to create the file 
        ;fopen() will return a file descriptor in the eax or 0 in case of error 
        ;eax =fopen(file_name,access_mode) 
        push dword access_mode
        push dword file_name 
        call [fopen] 
        add esp,4*2    ;clean-up the stack 
        
        mov [file_descriptor],eax  ;store the file descriptor returned by fopen 
        
        
        ; check if fopen() has successfully created the file(EAX != 0)
        cmp eax, 0 
        je final 
        ; read the text from file using fread()
        ; after the fread() call, EAX will contain the numberof chars we've read
        ; eax = fread(text, 1, len, file_descriptor)
        push dword [file_descriptor] 
        push dword len 
        push dword 1 
        push dword text 
        call [fread] 
        add esp,4*4
         
        ;de aici incepe ce am facut eu 
         
        mov ecx,26 ;26 wegen die lange des englischen Alphabets
        mov esi,0  ;source index wird 0 initialisiert um alle Elemente der buchstaben Variable durchzufuhren zu konnen
        jecxz sfarsit  
        repeta:
            mov al,[buchstaben+esi]   ;in al werden der Reihe nach die Buchstaben gespecihert
            mov edi,0                 ;index mit 0 initialisiert, was fur den test benutzt wird
            mov edx,0                 ;edx bracuht man fur die Anzahl jeder Kleinbuchstabe
            repeta_text:  
                cmp edi,len      
                jg ende_repeta_text ;if edx ist grosser als Langa des Textes, dann ende der Schleife
                mov bl,[text+edi]   ;jede Charakter des eingelesenen Textes wird in bl nach der Reihe nach gespeichert
                cmp bl,'a'          
                jl skip           ; jump if lower to skip wenn bl kleinere Ordung im Ascii Tabelle als a hat
                cmp bl,'z' 
                jg skip           ; jump if greater to skip wenn bl grossere Ordnung im Ascii Tabelle als z hat 
                cmp al,bl         ; vergleicht ob al mit bl gleich sind, um die Heufigkeit von al zu zahlen
                jnz skip
                inc edx           ; hier wachst die Haufigkeit wenn al=bl
                skip:
                inc edi           ;wachst der Index mit 1
                jmp repeta_text    
            ende_repeta_text:
            cmp edx,[max]   
            jl kleiner
            mov [max],edx         ;wenn max kleiner als edx ist, also es gibt ein haufigere Kleinbuchstabe 
            mov [losung],al      ;dann wird max dieses Wert haben und Losung speichert auch den Wert dieser Buchstabe
        
            kleiner:
            inc esi
        loop repeta 
        sfarsit:
        push dword [losung] 
        push dword formatchar
        call [printf] 
        add esp,4*2
        push dword [max] 
        push dword formatzahl
        call [printf]
        add esp,4*2                  ;hier werden die verlangene Werte ausgedruckt sein
         
        ;aici se termina ce am facut eu 
        final : 
        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_descriptor] 
        call [fclose] 
        add esp,4 
     
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

        
        