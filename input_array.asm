;**************************************************************************************************************************
;Program name: "input_array".  This a library function contained in a single file. This function reads a sequence of      *
;floats entered by the user and places each inputted value into consecutive cells of an array. The loop terminates on     *
;<enter><ctrl+d> or upon reaching (long max) elements. The number of elements entered is also returned. Input validation  *
;is implemented to retry upon encountering an int or string.                                                              *
;**************************************************************************************************************************
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2**
;Author information
;  Author name: Owen Rotenberg
;
;Status
;  This software is not an application program, but rather it is a single function licensed for use by other applications.
;
;Function information
;  Function name: input_array
;  Programming language: X86 assembly in Intel syntax.
;  Date development began:  2024-March-7
;  Date version 1.0 finished: 2024-March-12
;  Files of this function: input_array.asm
;  System requirements: an X86 platform with nasm installed or other compatible assembler.
;  Prototype: long input_array(double *W, long max).
;
;Purpose
;  This function loops and reads user inputted 64-bit floats and puts them into an array.
;
;Translation information
;  Assemble: nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
;
;========= Begin source code ====================================================================================
;Declaration area

global input_array

extern isfloat ; Prof. Holliday's float verification function
extern atof    ; String to float
extern scanf   ; Scanning input
extern printf  ; Displaying messages

segment .data

stringform db "%s", 0
nan_disp db "The last input was invalid and not entered into the array.", 10, 0

segment .bss
backup_storage_area resb 832
align 64

segment .text
;********** Function **********
input_array:

; Backup general purpose registers (GPR's)
push rbp
mov  rbp,rsp
push rdi
push rsi
push rdx
push rcx
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
push rbx
pushf

; Backup other registers
mov rax, 7
mov rdx, 0
xsave [backup_storage_area]

; Set up array
mov r13, rdi ; r13 is array
mov r14, rsi ; r14 is max size
sub rsp, 1024 ; Gives us 1kb of room for float inputs

; Initialize rcx as index counter
mov r15, 0

; r13 = first element of arr
; r14 = max size
; r15 = counter

;********** Program Begins **********
beginLoop:

cmp r15, r14
je quitLoop

;********** Read Input **********
; Read input
mov rax, 0
mov rdi, stringform ; "%s"
mov rsi, rsp
call scanf

;********** Validate Input **********
; Check for CTRL+D
cdqe
cmp rax, -1
je quitLoop

; Validate recent input is valid float
mov rax, 0
mov rdi, rsp
call isfloat ; rax=0 if false

; Compare to 0 and jump if not float
cmp rax, 0
je badInput ; Jump to badInput if equal to 0

;********** Populate Array **********
; Convert string to float
mov rax, 0
mov rdi, rsp
call atof

; Copy number into array
movsd [r13+r15*8], xmm0 ; r15 is counter
inc r15

; Restart loop
jmp beginLoop

badInput:
; Print error message and re-loop
mov rax, 0
mov rdi, nan_disp
call printf
jmp beginLoop

quitLoop:
; Counter sub 1024
add rsp, 1024

;********** Finalize **********
; Restore values to non-GPRs
mov rax, 7
mov rdx, 0
fxrstor [backup_storage_area]

; Move counter (r15) to rax for returning
mov rax, r15

; Restore GPRs
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp

ret
