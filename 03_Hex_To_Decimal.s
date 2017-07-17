;   Hexadecimal to Decimal through Console
;   Ethan Johnston

;   Assignment 05
;   Computer Organization II - CS 2400
;   Spring 2015

;   This program takes a hexadecimal value from the input console and converts
;       the value to decimal, outputting the decimal value to console as a string with
;       a binary negation if the hexadecimal is negative in two's complement
;   Registers Used:
;       R0  - buffer used to store input and output from console
;       R1  - buffer used to store hexadecimal input for base conversion
;       R2  - memory address of the reverse decimal string
;       R3  - memory address of the final decimal string output to console
;       R4  - buffer used to reverse the order of string in R2
;       R5  - input loop iteration counter
;       R11 - auxillary register used for decimal division subroutine
;       R12 - auxillary register used for intermediate storage

;    AREA    HexToString, CODE, READONLY
;    ENTRY

    AREA    HexToDecimal, CODE, READONLY
    EXPORT  main                    ;   required by the startup code
    ENTRY

main
    MOV     R1, #0x0                ;   [R1] <-- 0
    MOV     R5, #0x0                ;   [R5] <-- 0

LOOP_Input
    CMP     R5, #8                  ;   are there more than eight inputs ([R5] >= 8)?
    BGE     DONE_Input              ;   more than eight digits - stop reading

NumCheck
    ;SWI     0x4                     ;   read input from console
    SVC     #0x4

    CMP     R0, #'0'                ;   is the input >= ASCII 0?
    BLT     DONE_Input              ;   input is < ASCII 0 - out of range

    CMP     R0, #'9'                ;   is the input <= ASCII 9?
    BGT     UpperCheck              ;   input is > ASCII 9 - check A-F

    SUB     R0, R0, #'0'            ;   convert from ASCII to hexadecimal

    B       HexShift                ;   return to process values A-F

UpperCheck
    CMP     R0, #'A'                ;   is the input >= ASCII A?
    BLT     DONE_Input              ;   input is < ASCII A - out of range

    CMP     R0, #'F'                ;   is the input <= ASCII F?
    BGT     LowerCheck              ;   input is > ASCII F - check a-f

    SUB     R0, R0, #'A'            ;   convert from ASCII to decimal 0-5
    ADD     R0, R0, #0xA            ;   shift value from decimal to hexadecimal

    B       HexShift                ;   return to process values A-F

LowerCheck
    CMP     R0, #'a'                ;   is the input >= ASCII a?
    BLT     DONE_Input              ;   input is < ASCII a - out of range

    CMP     R0, #'f'                ;   is the input <= ASCII f?
    BGT     DONE_Input              ;   input is > ASCII f - out of range

    SUB     R0, R0, #'a'            ;   convert from ASCII to decimal 0-5
    ADD     R0, R0, #0xA            ;   shift value from decimal to hexadecimal

    ;B       HexShift                ;   return to process values A-F

HexShift
    ;MOV     R1, R1, LSL #4          ;   [R1] <-- original [R1] * 16
    LSL     R1, #4                  ;   [R1] <-- original [R1] * 16
    ADD     R1, R1, R0              ;   [R1] <-- original [R1] * 16 + [R0]

    ADD     R5, R5, #1              ;   [R5]++
    B       LOOP_Input              ;   return to beginning of input check

DONE_Input
    LDR     R12, =TwosComp          ;   [R12] <-- the address TwosComp
    STR     R1, [R12]               ;   store the two's complement input to memory

    LDR     R2, =RvsDecStr          ;   [R2] <-- the address RvsDecStr
    LDR     R3, =DecStr             ;   [R3] <-- the address DecStr

    MOV     R0, #0xA                ;   [R12] <-- ASCII line feed
    SWI     0x0                     ;   prints a new line character to the console

    LDR     R12, =0x80000000        ;   AND bitmask for MSB
    TST     R1, R12                 ;   is R1 positive (MSB = zero)?
    BPL     PositiveHex             ;   R1 is positive, skip '-'

NegativeHex
    MOV     R12, #'-'               ;   [R12] <-- ASCII -
    STRB    R12, [R3], #1           ;   store '-' to decimal string

    MVN     R1, R1                  ;   convert negative hex to one's complement
    ADD     R1, R1, #1              ;   convert one's complement to two's complement

PositiveHex
    BL      DIV_HextoDec            ;   call the divison subroutine for an input value

    ADD     R12, R12, #'0'          ;   convert decimal remainder to ASCII
    STRB    R12, [R2], #1           ;   store decimal remainder to reverse string

    CMP     R1, #0x0                ;   is the divison complete (quotient = 0)?
    BEQ     DONE_HextoDec           ;   division is complete - terminate loop

    B       PositiveHex             ;   return to process next hexadecimal value

DONE_HextoDec
    SUB     R2, R2, #1              ;   account for addition in PositiveHex loop
    LDR     R4, =RvsDecStr          ;   [R4] <-- the address RvsDecStr]

ReverseString
    LDRB    R12, [R2], #-1          ;   load reverse ASCII value to register, R2--
    STRB    R12, [R3], #1           ;   store ASCII value to decimal string, R3++

    CMP     R2, R4                  ;   is the string done processing?
    BHS     ReverseString           ;   string is done processing - continue program

    MOV     R12, #0x0               ;   [R12] <-- 0
    STRB    R12, [R3]               ;   store null value to end of decimal string

    LDR     R0, =DecStr             ;   [R0] <-- the address DecStr

    SWI     0x2                     ;   print the decimal string to console

DONE
    MOV     R0, #0x18               ;   angel_SWIreason_ReportException
    LDR     R1, =0x20026            ;   ADP_Stopped_ApplicationExit
    SVC     #0x11                   ;   previously SWI
;   BKPT    #0xAB                   ;   for semihosting - isn't supported in Keil's uV

;   Decimal Division Subroutine

;   Divides an input by ten

;   Inputs:     R1 is the address of a hexadecimal number to be divided
;   Outputs:    R1 stores the quotient of the division
;               R12 stores the remainder of the divison

DIV_HextoDec
    MOV     R12, #0x0
    MOV     R11, #0x0

    SUB     R12, R1, #10
    SUB     R1, R1, R1, LSR #2
    ADD     R1, R1, R1, LSR #4
    ADD     R1, R1, R1, LSR #8
    ADD     R1, R1, R1, LSR #16
    MOV     R1, R1, LSR #3
    ADD     R11, R1, R1, LSL #2
    SUBS    R12, R12, R11, LSL #1
    ADDPL   R1, R1, #1
    ADDMI   R12, R12, #10

    BX      LR


    AREA    Data, DATA

TwosComp    DCD 0x0                 ;   Hexadecimal input from the console

DecStr      %   12                  ;   Decimal output string to console

RvsDecStr   %   12                  ;   Storage string of the decimal value in reverse


    END
