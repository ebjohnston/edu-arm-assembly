;   Hex (to Binary) Subtraction
;   Ethan Johnston

;   Assignment 04 - Part A
;   Computer Organization II - CS 2400
;   Spring 2015

;   This program converts two hexadecimal numbers into their appropriate
;       two's complement and then adds them together with the first operand
;       being negative and the second operand being positive, storing the
;       contents of the difference of "b - a" into RESULT

;   Inputs: a negative integer "a" and a positive integer "b"
;       The hexadecimal digits of a are contained within A_MSD and A_LSD
;       The hexadecimal digits of b are contained within B_MSD and B_LSD

;   Output: a two's complement representation of the hexadecimal difference "b-a"
;       This value is stored in the reserved memory space RESULT

;   Registers Used:
;       R0 - memory address of most significant digit (MSD) of current input
;       R1 - memory address of lease significant digit (LSD) of current input
;       R2 - buffer to convert stored input to binary hexadecimal value
;       R3 - buffer to store individal digits of input
;       R4 - two's complement representation of "-a"
;       R5 - two's complement representation of "b"
;       R6 - memory address of RESULT, where difference is stored
;       R7 - two's complement representation of "b - a"
;       R8 - loop iteration counter for HexToBin

    AREA    HexSubtraction, CODE, READONLY
    EXPORT  main                    ;   required by the startup code
    ENTRY

main
    ;   first, store two's complement of "-a" in R4
    LDR     R0, =A_MSD              ;   [R0] <-- the address A_MSD
    LDR     R1, =A_LSD              ;   [R1] <-- the address A_LSD
    BL      Hex2Bin
    MVN     R4, R2                  ;   [R4] <-- a's one's complement
    ADD     R4, R4, #1              ;   [R4] <-- a's two's complement

    ;   second, store two's complement of "b" in R5
    LDR     R0, =B_MSD              ;   [R0] <-- the address B_MSD
    LDR     R1, =B_LSD              ;   [R1] <-- the address B_LSD
    BL      Hex2Bin
    MOV     R5, R2                  ;   [R5] <-- b's two's complement

    ;   third, store two's complement of "b - a" in RESULT
    ADD     R6, R4, R5              ;   [R6] <-- (b - a)'s two's complement
    LDR     R7, =RESULT
    STR     R6, [R7]                ;   {RESULT} <-- [R6]

DONE
    MOV    R0, #0x18                ;   angel_SWIreason_ReportException
    LDR    R1, =0x20026             ;   ADP_Stopped_ApplicationExit
    SVC    #0x11                    ;   previously SWI
;   BKPT   #0xAB                    ;   for semihosting - isn't supported in Keil's uV


;   Hexadecimal to Binary Subroutine

;   Converts a positive hex value to two's complement
;       Range of the hex must be between 0x0 and 0xFFFFFFFF
;       R3 is assigned the value "0xFFFFFFFF" if the hex is invalid

;   Inputs:     R0, R1
;   Outputs:    R2
;   Buffers:    R3, R8

Hex2Bin
    MOV     R2, #0                  ;   clear result register
    MOV     R8, #1                  ;   initialize loop counter

LOOP_Hex2Bin
    MOV     R3, #0                  ;   clear register taking a digit
    LDRB    R3, [R0], #1            ;   get next digit of Hex

    CMP     R3, #0x0                ;   is it lower than 0?
    BLO     InvalidHex              ;   not a valid digit

    CMP     R3, #0xF                ;   is it higher than F (15)?
    BHI     InvalidHex              ;   not a valid digit

    CMP     R8, #8                  ;   are there more than 8 digits?
    BHI     InvalidHex              ;   overflow | more than 8 digits

    LSL     R2, #4                  ;   [R2] <-- original [R2] * 16
    ADD     R2, R2, R3              ;   [R2] <-- original [R2] * 16 + [R3]

    CMP     R0, R1                  ;   have we reached the LSD?
    BHI     DONE_Hex2Bin            ;   LSD has been added

    ADD     R8, R8, #1              ;   increment loop counter
    B       LOOP_Hex2Bin

InvalidHex                          ;   a digit beyond 0-F or out-of-range
    LDR     R3, =0xFFFFFFFF
    B       DONE

DONE_Hex2Bin
    BX      LR                      ;   [PC] <-- LR | return of Hex2Bin


    AREA    Data, DATA

A_MSD       DCB    0xA              ;   a's Most Significant Digit
            DCB    0x0
            DCB    0x5
            DCB    0xE
            DCB    0x6
A_LSD       DCB    0x5              ;   a's Least Significant Digit
            ALIGN

B_MSD       DCB    0xF              ;   b's Most Significant Digit
            DCB    0xA
            DCB    0x2
            DCB    0x4
            DCB    0x8
            DCB    0xB
            DCB    0x6
B_LSD       DCB    0xE              ;   b's Least Significant Digit
            ALIGN

RESULT      DCD 0x0                 ;   ASCII code of '-' if negative


    END
