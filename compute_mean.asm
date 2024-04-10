;**************************************************************************************************************************
;Program name: "compute_mean".  This a library function contained in a single file. The function loops through each       *
;element of the provided array (using provided size int) and computes the mean. The mean is then returned.                *
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
;  Function name: compute_mean
;  Programming language: X86 assembly in Intel syntax.
;  Date development began:  2024-March-7
;  Date version 1.0 finished: 2024-March-13
;  Files of this function: compute_mean.asm
;  System requirements: an X86 platform with nasm installed or other compatible assembler.
;  Prototype: double compute_mean(double arr[], int arr_size).
;
;Purpose
;  This function computes and returns the mean of all 64-bit floats in an array
;
;Translation information
;  Assemble: nasm -f elf64 -l compute_mean.lis -o compute_mean.o compute_mean.asm
;
;========= Begin source code ====================================================================================
;Declaration area

global compute_mean
extern printf
segment .data

segment .bss
backup_storage_area resb 832
align 64

segment .text
;********** Function **********
compute_mean:

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

; Set up array
mov r13, rdi ; r13 is the array
mov r14, rsi ; r14 is number of elements
cvtsi2sd xmm12, r14 ; Places the int in a float-division-compatible register
pxor xmm11, xmm11 ; Clears xmm11

mov r15, 0 ; r15 is the counter (0)

;********** Program Begins **********
beginLoop:

; counter == size? Quit if true
cmp r15, r14
je quitLoop

; Add index
addsd xmm11, [r13+r15*8]

; Increment counter
inc r15

; Restart loop
jmp beginLoop

quitLoop:

; Divide by # of elements
divsd xmm11, xmm12

; Move mean into xmm0 for returning
movsd xmm0, xmm11

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
