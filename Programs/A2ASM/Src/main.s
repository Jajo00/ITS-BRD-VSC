;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke    
;* Version            : V1.0
;* Date               : 01.06.2021
;* Description        : This is a simple main to demonstrate data transfer
;                     : and manipulation.
;                     : 
;
;*******************************************************************************
    EXTERN initITSboard ; Helper to organize the setup of the board

    EXPORT main         ; we need this for the linker - In this context it set the entry point,too

ConstByteA  EQU 0xaffe
    
;* We need some data to work on
    AREA DATA, DATA, align=2    
VariableA   DCW 0xbeef
VariableB   DCW 0x1234
VariableC   DCW 0x0000
	ALIGN

;* We need minimal memory setup of InRootSection placed in Code Section 
    AREA  |.text|, CODE, READONLY, ALIGN = 3    
    ALIGN   
main
    BL initITSboard             ; needed by the board to setup
;* swap memory - Is there another, at least optimized approach?
    ldr     R0,=VariableA   ; Anw01
    ldrb    R2,[R0]         ; Anw02
    ldrb    R3,[R0,#1]      ; Anw03
    lsl     R2, #8          ; Anw04
    orr     R2, R3          ; Anw05
    strh    R2,[R0]         ; Anw06 
    
;* const in var
    mov     R5,#ConstByteA  ; Anw07
	ldr	    R0,=VariableC   ; Anw08
	strh    R5,[R0]         ; Anw0D
	ldrb	R8,[R0]         ; Anw09
	ldrb	R9,[R0,#1]      ; Anw0A
	lsl     R8, #8          ; Anw0B
	orr     R8, R9          ; Anw0C
	strh	R8,[R0]         ; Anw0D
    
;* Change value from x1234 to x4321
    ldr     R1,=VariableB   ; Anw0E
    ldrh    R6,[R1]         ; Anw0F
    mov     R7, #0x21DE     ; Anw10
    add     R6, R6, R7      ; Anw11
    strh    R6,[R1]         ; Anw12
    b .                     ; Anw13
    
    ALIGN
    END