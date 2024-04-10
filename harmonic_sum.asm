;**************************************************************************************************************************
;Program name: "harmonic_sum".  This a library function contained in a single file. This function computes the sum of the *
;harmonic series of the given array of floats. This is call the harmonic sum.                                             *
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
;  Function name: harmonic_sum
;  Programming language: X86 assembly in Intel syntax.
;  Date version 1.0 finished: 2024-March-211
;  Files of this function: harmonic_sum.asm
;  System requirements: an X86 platform with nasm installed or other compatible assembler.
;  Prototype: double harmonic_sum(double arr[], int arr_size).
;
;Purpose
;  This function computes and returns harmonic sum of all 64-bit floats in the array
;
;Translation information
;  Assemble: nasm -f elf64 -l harmonic_sum.lis -o harmonic_sum.o harmonic_sum.asm
;
;========= Begin source code ====================================================================================
;Declaration area

global harmonic_sum
extern printf

segment .data
one dq 1.0

segment .bss
backup_storage_area resb 832
align 64

segment .text
;********** Function **********
harmonic_sum:

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
pxor xmm10, xmm11

mov r15, 0 ; r15 is the counter (0)

;********** Program Begins **********
beginLoop:

; counter == size? Quit if true
cmp r15, r14
je quitLoop

; Put 1.0 in xmm11
movsd xmm11, [one]

; Divide float by 1 (get reciprocal)
divsd xmm11, [r13+r15*8]

; Add to running sum
addsd xmm10, xmm11

; Increment counter
inc r15

jmp beginLoop

quitLoop:

; move harmonic sum to xmm0 for returning
movsd xmm0, xmm10

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