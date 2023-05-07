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
;diese werden importiert weil C Funktionen aus einer Bibliothek sind
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
file_name db "input.txt",0 ;Name der Datei aus welche wir lesen
access_mode db "r",0       ;file access mode: r for reading 
;Zugriff Mod zu der Datei wird mit r initialisiert: r fur lesen  

file_descriptor dd -1; variable to hold the file descriptor ;Dateideskriptor wird -1 sein 
len equ 4000          ; maximum number of charcters to be read 
;maximale Anzahl der Charakters zu lesen 
text times (len+1) db 0 ; string to hold the text which is read from file 
;Zeichenkette(String) fur das Speichern der Inhalt des eingelesenen Textes aus der Datei 
format db "%d",0 ;um den Anzahl in basis 10 ausdrucken zu konnnen

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        ;call fopen() to create the file 
        ;fopen() will return a file descriptor in the eax or 0 in case of error 
        ;eax =fopen(file_name,access_mode) 
        push dword access_mode
        push dword file_name 
        call [fopen]  ;offnen der Datei "input.txt"
        add esp,4*2    ;clean-up the stack (saubern der Stapel)
        
        mov [file_descriptor],eax  ;store the file descriptor returned by fopen 
        ;speichern der Dateideskriptor in eax was fopen zuruckgeschickt hat 
        
        ; check if fopen() has successfully created the file(EAX != 0)
        cmp eax, 0 
        je final ;jump if equal to final wenn eax 0 ist 
        ; read the text from file using fread()
        ; after the fread() call, EAX will contain the numberof chars we've read
        ; eax = fread(text, 1, len, file_descriptor)
        push dword [file_descriptor] 
        push dword len 
        push dword 1 
        push dword text 
        call [fread]     ;lesen der Datei und text wird Inhalt von der Datei "input.tzt" speichern
        add esp,4*4   ;clean-up the stack (saubern der Stapel)
         
         
        mov edx,0 ;in edx werde ich die gerade Ziffern zahlen; (Anzahl der geraden Ziffern)
        mov esi,0 ; source Index wird mit 0 initialisiert 
        mov ecx,len; Lange des textes in ECX
        jecxz sfarsit
            repeta: 
                mov bl,[text+esi] ;in bl wird jeder Charakter des Textes der Reihe nach gespeichert
                cmp bl,'0' 
                jne skip1  ;jump if not equal to skip1 wenn bl<>0
                inc edx   ;edx wird um 1 grosser sein wenn bl ist gleich mit 0 (bl=0)
                skip1:
                cmp bl,'2' 
                jne skip2   ;jump if not equal to skip2 wenn bl<>2
                inc edx   ;edx wird um 1 grosser sein wenn bl ist gleich mit 2 (bl=2)
                skip2:
                cmp bl,'4' 
                jne skip3  ;jump if not equal to skip3 wenn bl<>4
                inc edx   ;edx wird um 1 grosser sein wenn bl ist gleich mit 4 (bl=4)
                skip3:
                cmp bl,'6' 
                jne skip4   ;jump if not equal to skip4 wenn bl<>6
                inc edx     ;edx wird um 1 grosser sein wenn bl ist gleich mit 6 (bl=6)
                skip4:
                cmp bl,'8' 
                jne skip5    ;jump if not equal to skip5 wenn bl<>8
                inc edx   ;edx wird um 1 grosser sein wenn bl ist gleich mit 8 (bl=8)
                skip5:
                inc esi  ;source Index wird inkrementiert (um 1 grosser sein) 
            loop repeta
        sfarsit:
        
        push dword edx   ; die Anzahl der geraden Ziffern wird auf den Stapel gelegt (gepusht)
        push dword format ; "%d" wird auf den Stapel gepusht
        call [printf]   ;wird die Anzahl der geraden Ziffern in Basis 10 ausgedruckt
        add esp,4*2    ;clean-up den Stapel 
        
        final : 
        
        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_descriptor] 
        call [fclose]    ;schliessen der Datei "input.txt"
        add esp,4     ;clean-up Stack ;4=grosse der dword (4 Bytes) und 1 push gibt (*1 schreibt man nicht)
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

        
        