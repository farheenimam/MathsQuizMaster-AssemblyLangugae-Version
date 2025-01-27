.model small
.stack 100h 

; Define a macro 

; To print messages
print_mssg macro message
   lea dx, message
   mov ah, 09h
   int 21h
endm    

;************ PRINT OPERATORS MACRO********************
;to print =? in question
equal macro 
   print_mssg equals 
endm
;to print "+" sign
plus macro
   mov dl, ' '  ;FOR SPACING WE LEFT EMPTY SPACES(for indentation)
   mov ah, 2h
   int 21h
   mov dl, '+'
   mov ah, 2h
   int 21h 
   mov dl, ' '
   mov ah, 2h
   int 21h
endm    

;to print "-" sign
minus macro 
   mov dl, ' '
   mov ah, 2h
   int 21h
   mov dl, '-'
   mov ah, 2h
   int 21h
   mov dl, ' '
   mov ah, 2h
   int 21h
endm

;to print "*" sign
multi macro
   mov dl, ' '
   mov ah, 2h
   int 21h
   mov dl, 'x'
   mov ah, 2h
   int 21h
   mov dl, ' '
   mov ah, 2h
   int 21h
endm

;to print "/" sign
divi macro 
   mov dl, ' '
   mov ah, 2h
   int 21h
   mov dl, '/'
   mov ah, 2h
   int 21h
   mov dl, ' '
   mov ah, 2h
   int 21h
endm  

ques macro value   ;value we are mainting for question no basically count q1,q2,q3 etc
   print_mssg space
   print_mssg quest
   mov bl, value ; Since first operand cannot be immediate value
   add bl, 48
   display bl
   print_mssg brckt 
endm    

;display character
display macro char
   mov dl, char
   mov ah, 2h
   int 21h
endm     
;taking input from user (macro for input)
input macro
   mov ah, 1h
   int 21h
endm  
 

.data  
; Variables for userinput
username db 30 dup('$')
id db 4 dup('$')
ans db 3 dup('$')  
; Variable for level
level db 0
count db 1  
lp1 dw 2
lp2 dw ?
cnt_star db 0  
star dw 1      
temp dw 0    
counter db 0 
rghtAns db 0
wrongAns db 0
atmpQues dw 0 
vld db 0
result db ? 
resultW dw ?
; Varaiable to store the number
num1 db ?  
num dw ?   

; Variables to handle messages 
msg1 db 0Dh,0Ah, '     ARISHA$'
msg2 db 0Dh,0Ah, '     FARHEEN$'
msg3 db 0Dh,0Ah, '     ALVINA$'   
mathsQuizMaster db 13, 10, '---------------------------- " MATHS QUIZ MASTER " -----------------------------$'
nameOutput db 0Dh,0Ah, '     Name: $'
idOutput db 0Dh,0Ah, '     Id: $'
prompt db 0Dh,0Ah, '     How many characters are there? $'
nameMsg db 0Dh,0Ah, '     Enter your name(lower case only): $'
idMsg db 0Dh,0Ah, '     Enter your id (3 digit ID): $' 
resultMsg db 0Dh, 0Ah, '     You entered: $'   
levelMsg db 0Dh, 0Ah, '     Choose the level$'  
levelMsg1 db 0Dh, 0Ah, '     Press "b" for Basic, "m" for Medium, "a" for Advance: $' 
bscMsg db 13, 10, '     ------------------ BASIC LEVEL ---------------$'
advMsg db 13, 10, '     ------------------ ADVANCE LEVEL ---------------$'
medMsg db 13, 10, '     ------------------ MEDIUM LEVEL ---------------$'
agnMsg db 13, 10, '     To play again press ESC if not then ENTER: $'     
resultMsg0 db 13, 10, '     Number of questions attempted: $'
resultMsg1 db 13, 10, '     Total correct answers: $'
resultMsg2 db 13, 10, '     Got wronged: $'
ansMsg db 0Dh, 0Ah,'     Answer: $'
crrctMsg db 0Dh, 0Ah, '     Correct$'
invalid db 0Dh, 0Ah, '     Invalid Input$'
wrngMsg db 0Dh, 0Ah, '     Incorrect, Answer is: $'
newline db 0Dh, 0Ah, '     $'   
line db 13, 10, '     -----------------------------------------------$'
space db  '     $'
equals db ' = ? $'          
quest db 13, 10, '     Ques $'          
brckt db ') $'

;-------------------- " MAIN PROCEDURE " ------------------------ 
.code             
main proc
    mov ax, @data
    mov ds, ax
    
    print_mssg mathsQuizMaster
    print_mssg newline
    call name_inp
    
; Calling procedures
end:
   print_mssg newline
   print_mssg nameOutput   
   print_mssg username
   print_mssg idOutput
   print_mssg id    
   print_mssg newline 
   print_mssg resultMsg0
   mov ax, 0
   mov ax, atmpQues
   
   call PrintNum 
   print_mssg resultMsg1 
   mov ax, 0
   mov al, rghtAns
   call PrintNum
    
   print_mssg resultMsg2
   mov ax, 0
   mov al, wrongAns
   call PrintNum
     
   mov ah, 4ch 
   int 21h     
main endp

; ------------ PROCEDURES TO HANDLE LEVELS CALLING  ------------------- 
; To switch to the level accordingly
switch_lvl proc 
  print_mssg levelMsg
  print_mssg levelMsg1
  mov ah, 1h
  int 21h 
    
; mov in level variable
   ; For basic level
    mov level, al  ;whatever user inputs will come in al and goes in level variable declared in data segment  
    
    cmp level, 98    ;b ascii code for basic level comparing with b
    je basic 
    
    cmp level, 109    ;m ascii code for medium level comparing with m

    je medium 
    
    cmp level, 97     ;a ascii code for advance level comapring with 97
    je hard  
    
    cmp level, 98
    jne switch_lvl
    
    basic:        
        print_mssg newline
        print_mssg bscMsg
        print_mssg newline 
        call basic_lvl
        jmp again
        
    ; For medium level      
    medium:        
        print_mssg newline
        print_mssg medMsg 
        print_mssg newline
        call med_lvl
        jmp again   
        
    ; For hard level    
    hard:     
        print_mssg newline   
        print_mssg advMsg
        print_mssg newline 
        call adv_lvl
        jmp again

does1:
    print_mssg invalid
    jmp switch_lvl 
does:
    print_mssg invalid
    jmp again         
    
again:      ;it will run until we enter escape or enter key 
    print_mssg agnMsg 
    input
    cmp al, 27   ;escape key ascii code
    je switch_lvl
    
    cmp al, 27
    ja does
    
    cmp al, 27
    ja does
    
    cmp al, 13
    je end            
    
    cmp al, 13
    jb does            
    
    cmp al, 13
    ja does
switch_lvl endp            
  
name_inp proc
restart:  
  print_mssg nameMsg
  mov si, 0    
  lea si, username
  mov bl, 13
; Loop to take input of the user
user_input:
   mov ah, 1h
   int 21h
   cmp al, bl
   je error2
   cmp al, 13
   je id_input
   call validate
   mov [si], al  
   mov bl, 23
   inc si  
   jmp user_input    
                         
; To take id input
id_input:
   print_mssg idMsg
   lea si, id 
   
   mov cx, 3
L1:           
   mov ah, 1h
   int 21h
   call validate1
   mov [si], al
   inc si
   loop l1 
   call switch_lvl
   ret   
name_inp endp    
 
; ------------ PROCEDURE FOR EACH LEVEL CALLING -------------------   
 
; To take name as input 
input_ans proc
   mov ah, 0
   mov al, 0
   lea si, ans 
   mov cx, 3
answer: 
   mov ah, 1h
   int 21h    
   cmp al, 13
   je process
   mov [si], al 
   inc si   
   loop answer
   mov ax, resultW
   call check
   jmp endss
process:   
   mov ax, resultW
   call check 
   jmp endss
endss:    
    ret
input_ans endp        

; Procedure to handle the basic level
basic_lvl proc 
   mov count, 1
   mov lp1, 5
   mov cx, lp1
basicQues:   
   ques count 
   call generate_pattern  
   call input_ans
   print_mssg line 
   
   inc count 
   dec lp1
   cmp lp1, 0
   je char         
   Loop basicQues
char:
   call count_chars
   ret      
basic_lvl endp         

; Procedure to handle the medium level
med_lvl proc
   mov count, 1
   mov lp1 , 2
   mov cx, lp1
medQues:   
   ques count 
   call OneDigitsAdd
   call input_ans
   print_mssg line
   inc count 
   
   ques count
   inc count
   Call OneDigitsdivide
   call input_ans
   print_mssg line  
          
   ques count
   inc count
   Call OneDigitsmulti              
   call input_ans
   print_mssg line
   
   ques count
   inc count
   Call OneDigitsSub 
   call input_ans
   print_mssg line
   dec lp1    
   cmp lp1, 0
   je continue1      
   Loop medQues
continue1:
   ret       
med_lvl endp

; Procedure to handle the medium level                                            
adv_lvl proc
   mov count, 1 
   mov lp1,2
   mov cx, lp1
advQues:   
   ques count 
   call TwoDigitsAdd
   call input_ans
   print_mssg line
   inc count 
   
   ques count
   inc count
   Call DivTwoNumbers
   call input_ans
   print_mssg line  
   
   ques count
   inc count
   Call MultiTwoNumbers
   call input_ans
   print_mssg line
   
   ques count
   inc count
   Call SubtractTwoNumbers
   call input_ans
   print_mssg line
   dec lp1    
   cmp lp1, 0
   je continue     
   Loop advQues
continue:  
   ret
adv_lvl endp 
   
; To count the characters   
count_chars proc
   mov resultW, 0
   ques count    
   mov resultW, 6
   print_mssg msg1
   print_mssg newline
   print_mssg ansMsg
   call input_ans
   print_mssg line
   
   mov resultW, 0
   inc count
   ques count    
   mov resultW, 7
   print_mssg msg2
   print_mssg newline
   print_mssg ansMsg
   call input_ans     
   print_mssg line
   
   mov resultW, 0
   inc count
   ques count    
   mov resultW, 6
   print_mssg msg3
   print_mssg newline
   print_mssg ansMsg
   call input_ans
   print_mssg line
   ret
count_chars endp 

; To generate a random pattern
generate_pattern proc 
   call rndgnPttrn
   mov ah, 0
   mov resultW, 0    ;resultw tracks the total stars
   mov star, 1  
   mov lp2, ax 
   print_mssg newline
   mov cx, lp2
n2:                    ;outer loop for rows
   mov lp2, cx
   mov cx, star; cx = 1, 2  
n1:                    ;inner loop is printing stars
   inc resultW 
   mov dl, '*' 
   mov ah, 2h
   int 21h
   inc cnt_star 
   Loop n1     
   inc star
   print_mssg newline
   dec lp2
   cmp lp2, 0
   je proceed    
   mov cx, lp2
   Loop n2  
proceed:
   print_mssg ansMsg   
   ret       
generate_pattern endp
                                
; ------------ PROCEDURE TO HANDLE GENERATING RANDOM NUMBER -------------------             
; Random number generation procedure (range: 0 to 7)            
randgen proc
    mov ah, 2Ch        ; Get system time
    int 21h            ; Call DOS interrupt
    mov al, dl         ; Use the low byte of seconds as randomness
    and al, 07h        ; Limit range to 0-7
    add al, 2          ; Adjust range to 2-9
    ret
randgen endp
 
; Random number generation procedure (range: 2 to 5) 
rndgnPttrn proc
    mov ah, 2Ch        ; Get system time
    int 21h            ; Call DOS interrupt
    mov al, dl         ; Use the low byte of seconds as randomness
    and al, 05h  
    add al, 2         ; Adjust range to 2-5
    ret
rndgnPttrn endp

; Random number generation procedure (range: 18 to 81)
rndmTwoDgt proc
    mov ah, 2Ch         ; Get system time
    int 21h             ; Call DOS interrupt
    mov al, dl          ; Use the low byte of seconds as randomness
    and al, 07h         ; Limit range to 0-7
    add al, 2           ; 
    mov bx, 9
    mul bx              ; multiply by 9 to get the range from 18 to 63
    ret
rndmTwoDgt endp 

; Random number generation procedure (range: 11 to 20)
rndmElvnToTwnty proc
    mov ah, 2Ch         ; Get system time
    int 21h             ; Call DOS interrupt
    mov al, dl          ; Use the low byte of seconds as randomness
    and al, 09h         ; Limit range to 0-7
    add al, 10          ; Range: 11 - 20
    ret
rndmElvnToTwnty endp  
                                
;-------------  PROCEDURE TO HANDLE RESULTS -------        

; To handle the errors
error proc
    print_mssg invalid
    jmp restart
    ret
error endp 

error2 proc
    cmp al, 13
    je error
    ret
error2 endp 

error1 proc
    print_mssg invalid
    jmp id_input    
    ret 
error1 endp

; To handle the empty input
empty proc
    cmp al, 13
    je error
empty endp

; To validate the input
validate1 proc 
    cmp si, 00h    ;if we enter null so it goes to empty proc which has error proc called which contains invalid message and jump to restart until correct input is provided.
    je empty   
   
    cmp al, 48
    jb error1     ; jump if below 0,we have symbols
    
    cmp al, 57
    ja error1      ; jump if above 9,we have symbols
    ret
validate1 endp 

validate proc    ;only username accepts lowercase validation applied only.
    cmp al, 48
    jb error
    
    cmp al, 57
    jbe error
    
    cmp al, 65
    jb error
    
    cmp al,97
    jb error
    ret 
validate endp    
                
; To check the answers                
check proc 
    inc atmpQues
      
    cmp ax, 10
    jb rght_wrong_1
    
    cmp ax, 99
    jle rght_wrong_2 
    
    cmp ax, 99
    jg rght_wrong_3 
    
    ret
check endp    

; Procedures to handle single-digit results
rght_wrong_1 proc
    xor ax, ax               
    
    mov si, offset ans     
    mov al, [si]           
    sub al, 30h           
    mov ah, 0 
    mov bx, resultW        
 
    cmp al, bl            
    jne wrong 
    je right          

right:
    print_mssg crrctMsg 
    inc rghtAns    
    jmp ended            

wrong:
    print_mssg wrngMsg 
    inc wrongAns     
    mov ax, resultW          
    call PrintThreeDigits            

ended:
    print_mssg newline
    ret       
rght_wrong_1 endp


; Procedures to handle two-digit results    
rght_wrong_2 proc
    ; Reconstruct the number from the array
    xor ax, ax              ; AX = 0 (clear AX)
    mov si, offset ans      ; Load the address of the array

    ; Loop through the array to reconstruct the number
    mov cx, 2               ; Number of digits in the array
reconstruct:
    mov bl, [si]  
    sub bl, 30h          ; Load the current digit from the array
    inc si                 ; Move to the next digit
    mov bh, 0               ; Clear BH
    shl ax, 1               ; Multiply AX by 10
    mov dx, ax              ; Backup AX
    shl ax, 2               ; Multiply AX by 4
    add ax, dx              ; AX = AX * 10
    add ax, bx              ; Add the digit to AX
    loop reconstruct   ; Repeat for all digits
    ; Compare the reconstructed number with the variable 'number'
    mov bx, resultW; Load the variable 'number' into BX    
    cmp ax, bx  
     
    jne wrong              ; If not equal, jump to not_equal
    je right
    ret
rght_wrong_2 endp
        

; Procedures to handle three-digit results        
rght_wrong_3 proc
    ; Reconstruct the number from the array
    xor ax, ax             ; AX = 0 (clear AX)
    mov si, offset ans     ; Load the address of the array

    ; Loop through the array to reconstruct the number
    mov cx, 3              ; Number of digits in the array
recnstrct_loop:
    mov bl, [si]           ; Load the current digit from the array
    inc si                 ; Move to the next digit
    mov bh, 0              ; Clear BH
    shl ax, 1              ; Multiply AX by 10
    mov dx, ax             ; Backup AX
    shl ax, 2              ; Multiply AX by 4
    add ax, dx             ; AX = AX * 10
    add ax, bx             ; Add the digit to AX
    loop recnstrct_loop  ; Repeat for all digits
    
    add ax, 48 
    mov bh, 0
    ; Compare the reconstructed number with the variable 'number'
    mov bx, resultW; Load the variable 'number' into BX    
    cmp al, bl             ; Compare the reconstructed number with 'number'
    jne wrong              ; If not equal, jump to not_equal
    je right
    ret
rght_wrong_3 endp       

;------------- PROCEDURE TO HANDLE DIGITS PRINTING ------- 
; To switch the procedure according to the value
PrintNum proc
    cmp al, 10
    jl PrintSingleDigit
    
    cmp al, 10
    jge PrintTwoDigits 
    
    ret
PrintNum endp    

; Procedure to print single digits
PrintSingleDigit proc
    add al, 48        
    mov dl, al        
    mov ah, 02h
    int 21h
    ret
PrintSingleDigit endp
         
; Procedure to print two digits         
PrintTwoDigits proc
    aam
    mov cl, al
    mov dl, ah
    add dl, 48
    mov ah, 2h
    int 21h
    mov dl, cl                   
    add dl, 48
    mov ah, 2h
    int 21h 
    ret 
PrintTwoDigits endp  
     
; Procedure to print two digits
PrintThreeDigits proc  
    ;initialize count
    mov cx,0
    mov dx,0
    label1:
        ; if ax is zero
        cmp ax,0
        je print1      
         
        ;initialize bx to 10
        mov bx,10        
         
        ; extract the last digit
        div bx                  
         
        ;push it in the stack
        push dx              
         
        ;increment the count
        inc cx              
         
        ;set dx to 0 
        xor dx,dx
        jmp label1
    print1:
        ;check if count 
        ;is greater than zero
        cmp cx,0
        je exit
         
        ;pop the top of stack
        pop dx
         
        ;add 48 so that it 
        ;represents the ASCII
        ;value of digits
        add dx,48
         
        ;interrupt to print a
        ;character
        mov ah,02h
        int 21h
         
        ;decrease the count
        dec cx
        jmp print1
exit:
     
ret
PrintThreeDigits endp
        
;------------- MATHS OPERATION PROCEDURES------- 

;______ Operations for 1 digits _______ 
                                    
                                    
; Handles the calling of addition procedure     
OneDigitsAdd proc
    call randgen
    mov ah, 0
    mov num,ax    
    call PrintNum
    plus

    call randgen
    mov ah, 0
    mov bl, al
    call PrintNum
    equal
         
    call AddTwoNumbers  
    print_mssg ansMsg
    ret
OneDigitsAdd endp
           
; Handles the calling of mulitple procedure           
OneDigitsmulti proc
    call randgen
    mov bl, al
    mov ah, 0    
    mov num, ax 
    call PrintNum
    multi

    call randgen
    mov bh, 0
    mov bl, al        
    call PrintNum
    equal
    
    call MultiTwo
    print_mssg ansMsg 
    ret
OneDigitsmulti endp
   
; Handles the calling of divide procedure   
OneDigitsdivide proc
    call rndmElvnToTwnty
    mov bl, al
    mov ah, 0    
    mov num, ax 
    call PrintNum
    divi

    call randgen
    mov bl, al
    call PrintNum
    equal
         
    call DivTwo  
    print_mssg ansMsg
    ret
OneDigitsdivide endp
              
; Handles the calling of substract procedure                         
OneDigitsSub proc
    call rndmElvnToTwnty
    mov bl, al
    mov ah, 0    
    mov num, ax 
    call PrintNum
    minus

    call randgen
    mov bl, al
    call PrintNum
    equal
         
    call SubtractTwo
    print_mssg ansMsg
    ret
OneDigitsSub endp 


;______ Operations for 2 digits _______  


; Performs addition
AddTwoNumbers proc
    mov bh, 0
    mov ax, num      
    add ax, bx
    mov resultW, ax 
    ret              
AddTwoNumbers endp   

; Handles the calling of addition procedure
TwoDigitsAdd proc
    call rndmTwoDgt
    mov bl, al
    mov ah, 0
    mov num, ax    
    call PrintNum
    plus

    call rndmTwoDgt
    mov bl, al
    mov ah, 0      
    mov bx, ax         
    call PrintNum
    equal
         
    call AddTwoNumbers 
    print_mssg ansMsg 
    ret
TwoDigitsAdd endp 
  
; Handles the calling of divide procedure                                     
DivTwoNumbers proc
    call rndmTwoDgt
    mov bl, al
    mov ah, 0
    mov num, ax   ; Load the fixed number (9)
    call PrintNum
    divi

    call randgen
    mov bl, al        
    call PrintNum
    equal
    
    call DivTwo
    print_mssg ansMsg  
    ret
DivTwoNumbers endp 

; Performs division
DivTwo proc
    mov ax, num        ; Load the fixed number (9) into AL (dividend)          ; Load the random number (1-8) into DL (divisor)
    div bl  
    mov ah, 0           ; Perform division: AL / DL -> Quotient in AL, Remainder in AH
    mov resultW, ax  
    ret
DivTwo endp
 
; Handles the calling of mulitple procedure   
MultiTwoNumbers proc
    call rndmElvnToTwnty
    mov bl, al
    mov ah, 0    
    mov num, ax 
    call PrintNum
    multi

    call randgen
    mov bh, 0
    mov bl, al        
    call PrintNum
    equal
    
    call MultiTwo
    print_mssg ansMsg 
    ret
MultiTwoNumbers endp  
 
; Performs multiplication 
MultiTwo proc
    mov resultW, 0
    mov ax, 0 
    mov ax, num  
    mov bh, 0
    mul bx
    mov resultW, ax 
    ret
MultiTwo endp    
    
; Handles the calling of substract procedure    
SubtractTwoNumbers proc
    call rndmTwoDgt
    mov bl, al
    mov ah, 0
    mov num, ax   ; Load the fixed number (9)
    call PrintNum
    minus

    call randgen
    mov bl, al        
    call PrintNum
    equal
    
    call SubtractTwo
    print_mssg ansMsg 
    ret
SubtractTwoNumbers endp 
   
; Performs subtracts   
SubtractTwo proc
    mov resultW, 0 
    mov ax, num       ; Load fixed number (9)
    sub ax, bx 
    mov resultW, ax
    mov ax, resultW        ; Subtract BL from AL
  ;  call PrintNum
    ret
SubtractTwo endp       

end main
   
        
 
    
     