;   Valid Int Counter and Accumulator

;   Exam One - Part Two
;   Computer Organization II - CS 2400
;   Spring 2015

;   This program takes an array of 10 integers and counts the number
;       of integers within a valid range, then calculating the sum
;       of the valid integers. The number of valid integers processed
;       as well as the Sumand an ASCII character representing the
;       sign of the Sum are all stored to memory.
;   Registers Used:
;       R0 - buffer used to process integers in the array
;       R1 - integer array pointer
;       R2 - Counter for number of integers added
;       R3 - Sum of integers within valid range
;       R4 - while-loop Counter
;       R5 - temporary memory address buffer


    AREA    CountValidInt, CODE, READONLY
    EXPORT  main                    ;   required by the startup code
    ENTRY

main
    LDR     R1, =intArray           ;   [R1] <-- the address intArray
    MOV     R2, #0x0                ;   [R2] <-- 0
    MOV     R3, #0x0                ;   [R3] <-- 0
    MOV     R4, #0x0                ;   [R4] <-- 0

LOOP_Main
    CMP     R4, #10                 ;   is [R4] < 10?
    BGE     DONE_Loop               ;   [R4] >= 10, end while loop

    LDR     R0, [R1], #4            ;   load an array integer into the R0 buffer
    CMP     R0, #-100               ;   is [R0] >= -100?
    BLT     OutOfRange              ;   [R0] < -100, skip summation
    CMP     R0, #100                ;   is [R0] <= 100?
    BGT     OutOfRange              ;   [R0] > 100, skip summation

    ADD     R2, R2, #1              ;   [R2]++
    ADD     R3, R3, R0              ;   [R3] <-- [R3] + [R0]

OutOfRange
    ADD     R4, R4, #1              ;   [R4]++
    B       LOOP_Main               ;   return to LOOP_Main

DONE_Loop
    LDR     R5, =Counter            ;   [R5] <-- the address Counter
    STR     R2, [R5]                ;   stores R2 to Counter in memory

    LDR     R5, =Sum                ;   [R5] <-- the address sum
    STR     R3, [R5]                ;   stores R3 to Sumin memory

    LDR     R5, =Sign               ;   [R5] <-- the address Sign
    LDR     R12, =0x80000000        ;   AND bitmask for MSB
    TST     R3, R12                 ;   is R3 negative (MSB = one)?
    BMI     Negative                ;   [R3]'s MSB is one - store 'N'

Positive
    MOV     R0, #'P'                ;   [R0] <-- 'P'
    STRB    R0, [R5]                ;   Stores 'P' to Sign in memory
    B       DONE

Negative
    MOV     R0, #'N'                ;   [R0] <-- 'N'
    STRB    R0, [R5]                ;   Stores 'N' to Sign in memory

DONE
    MOV     R0, #0x18               ;   angel_SWIreason_ReportException
    LDR     R1, =0x20026            ;   ADP_Stopped_ApplicationExit
    SVC     #0x11                   ;   previously SWI


    AREA    Data, DATA

    EXPORT ADDR_Counter
    EXPORT ADDR_Sum

ADDR_Counter
    DCD     Counter

ADDR_Sum
    DCD     Sum


intArray                            ;   array of 10 signed 32-bit integers
    DCD 50, -125, 465, 232, 101, 145, 54, 25, -20

Counter                             ;   number of values in summation
    DCD 0

Sum                                 ;   accumulator for matching values
    DCD 0

Sign                                ;   memory location of either 'P' or 'N'
    DCB 0, 0


    END
