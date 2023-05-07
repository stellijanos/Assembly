;The file "pruefung.txt" is given. The file contains a text (max. 200 characters) with uppercase and lowercase letters, spaces and dots. 
;Save in the file "output.txt" only the words that contain at least one uppercase letter and a minimum of 5 letters. 
;Explain the algorithm to solve the task (in 2-3 lines).

;Example:
;pruefung.txt:
;Anamaria are Meere.
;output.txt:
;Anamaria Meere

;Example:
;pruefung.txt:
;Ana are Mere.
;output.txt:
;Keine Worter.


bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
extern fopen,fclose,fread,fprintf 
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll                           
import fprintf msvcrt.dll   
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
    file_1_name db 'pruefung.txt',0 ; Datei was geoffnet wird 
    access_1_mode db 'r',0 ;r pentru citire din fisier 
    file_1_descriptor dd -1 ;
    len equ 200 
    text times (len+1) db 0 ;string to hold the text 
    format db '%s ',0 
    
    file_2_name db 'output.txt',0 ;file in welche geschrieben wird 
    access_2_mode db 'w',0 ;w pentru writing 
    file_2_descriptor dd -1 
    
    zahl dd 5
    
    wort resb 201   ;201 byte reservieren, weil 200 max. Lange und 1 byte 0 am Ende muss bleiben    
    format_string db '%s',0
    
    space db 32,0  ;32 in decimal ist space (Ascii)
    verificare dd 0  ;um zu uberprufen ob Wort mit mindesten Lange zahl inclusiv existiert 
    keine db 'Keine Worter',0    ;Text was in ouput.txt sein soll, falls keine worter mit minim Lange 5 und min eine Grossbuchstabe einthalten
    gross_buchstabe dd 0   ;kontor fur die gross_buchstabe ; wachst wenn Grossbuchstabe gibt 
    
; our code starts here
segment code use32 class=code
    start:
        ; ...

        
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or0 in case of error
        ; eax = fopen(file_name, access_mode)
        push dword access_1_mode
        push dword file_1_name
        call [fopen]
        add esp, 4*2     

        mov [file_1_descriptor], eax ; store the filedescriptor returned by fopen
        
        
        ; check if fopen() has successfully created the file(EAX != 0)
        cmp eax, 0 
        je final
        
        
        ; read the text from file using fread()
        ; after the fread() call, EAX will contain the numberof chars we've read
        ; eax = fread(text, 1, len, file_descriptor)
        push dword [file_1_descriptor]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4*4
        
        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_1_descriptor]
        call [fclose]
        add esp, 4

        
        
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or 0 in case of error
        ; eax = fopen(file_name, access_mode)
        push dword access_2_mode
        push dword file_2_name
        call [fopen]
        add esp, 4*2  ; clean-up the stack
        
        mov [file_2_descriptor], eax  ; store the filedescriptor returned by fopen
        
        ; check if fopen() has successfully created the file(EAX != 0)
        cmp eax, 0
        je final
         
        
        ;hier beginnt meine modifizierung
        
        ;durchfuhren der Datei um jedes Wort zu verglechen und desse Lange auch
            ;parcurgerea textului ca sa obtinem fiecare cuvant si sa il cumparam lungimea acestui 
        mov esi,0
        mov edi,0
           
        ;mov edx,0 ;kontor fur Grossbuchstabe
           
        repeta:
           mov al,[text+esi]     ;jede Buchstabe der Text wird hier in al sein 
           
           cmp al,0               
           je vergleich          ;jump equal to vergleich Teil(label), wenn al=0, also ende des Textes ist 
           
           cmp al,20h            ; 20h=' ' (space in hexa)
           je vergleich          ; wenn al=' ', dann jump to vergleich Teil (label)
           
           cmp al,2eh            ; 2eh='.' (point in hexa) 
           je vergleich          ; wenn al='.', dann jump to vergleich Teil (label)
            
           cmp al,2ch            ; 2ch=',' (Komma) 
           je vergleich 
           
           cmp al, 65 
           jb keine_gb  ;uberpurft ob die Buchstabe zwischen 'A' und 'Z' ist
           cmp al,90 
           ja keine_gb 
           inc dword [gross_buchstabe] ;wenn al zwischen 'A' und 'Z' (ascii table) ist dann wachst um 1 diese gross_buchstabe kontor
           keine_gb: ;keine Grossbuchstabe
           
           mov [wort+edi],al     ;wort wird jede Zeichen von text haben, falls diese Kein ' ' oder '.' ist
           
           inc esi               ; increment extended source index
           inc edi               ; increment extended destination index 
           
           jmp repeta            ; jump to repeta 
           
           vergleich:
               cmp edi,[zahl]   ;destination index wird mit zahl (gelesen; lange des gesuchten Worter vergleicht) 
               jb skip         ; wenn streng kleiner als 5 ist, dann skip 
               
               
               mov edx,0 
               cmp edx, dword [gross_buchstabe]  ;uberprift man ob eine Grossbuchstabe in Wort existiert, falls keine gibt, skip mit jump equal 
               je skip
               inc dword [verificare] ;increment verificare, um zu wissen, ob ein wort mit langa 'zahl' existiert
               ;afisare cuvant
               pushad                 ; um registern Werte unverandert nach den fprintf zu haben
               ; append the text to file using fprintf();fprintf(file_descriptor,format, text)
               push dword wort
               push dword format_string
               push dword [file_2_descriptor] 
               call [fprintf] 
               add esp,4*3 
               popad 
               ;final afisare cuvant 
               
               ;ausdrucken der Leerzeichen in Datei (' ')
               pushad 
               push dword space
               push dword [file_2_descriptor]
               call [fprintf] 
               add esp,4*2
               popad   
               ;ende ausdruck der Leerzeichen ' ' (space)
               skip: 
               cmp al, 0    ;al wird mit 0 verglichen
               je sfarsit  ; wenn 0 ist, also ende des textes, dann sfarsit
               
               ;resetare de cuvant (toti bitii sa fie 0
               mov edi,0 
               reset_wort:
                 mov al,[wort+edi] 
                 cmp al,0 
                 je gata_reset_wort
                 mov al,0 
                 mov [wort+edi],al 
                 inc edi 
                 jmp reset_wort
                gata_reset_wort:
               mov edx,0 
               mov [gross_buchstabe],edx ;reinitialisiert man die Kontor der Grossbuchstabe
               
               mov edi,0   ;destination index, was fur wort ist, wird mit 0 reinitialisiert
               inc esi     ;wachst source index mit 1
               mov al, [text+esi] ;in al wird das nachste charakter von text gespeichert
               cmp al,20h   ; wird mit ' ' verglichen, wegen '. ' (also punkt danach space) 
               jne repeta   ; wenn nicht ' ' ist, dann jump zur repeta zuruck 
               inc esi      ; wenn ' ' ist, dann wachst source index mit 
               jmp repeta   ; jump to repeta 
           
           sfarsit:   ;ende der loop 
           
           mov eax,0   ; eax word 0 haben 
           cmp eax, dword [verificare] ; verificare wird mit eax verglichen 
           jne nicht_gleich ; wenn existiert wort mit Lange 'zahl', dann sprung zur nicht_gleich (mit 0)
           pushad          ;der text "KEINE" wird ausgedruckt, falls kein wort min Lange zahl exisiert 
            push dword keine
            push dword format_string
            push dword [file_2_descriptor] 
            call [fprintf] 
            add esp,4*3 
           popad        
           nicht_gleich:
        
    
        
        ;hier endet mein modifizierung 
        
        

        ; append the text to file using fprintf(); fprintf(file_descriptor,format, text)
    ;    push dword text
    ;    push dword format
    ;    push dword [file_2_descriptor] 
    ;    call [fprintf] 
    ;    add esp,4*3 
        
        ; call fclose() to close the file; fclose(file_descriptor)
        push dword [file_2_descriptor]
        call [fclose]
        add esp, 4
        
        
        final: 
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
