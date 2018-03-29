;   Hamming Code Decryption and Error Correction

;   Assignment 06
;   Computer Organization II - CS 2400
;   Spring 2015

;   This program takes a string containing hamming code and attempts to produce
;       the source word, correcting any errors it finds and storing the result
;       in memory

    AREA    Hamming, CODE, READONLY
    EXPORT  main                    ;   required by the startup code
    ENTRY

main
    LDR     R0, =Source             ;   [R0] <-- address of Source - 1
    SUB     R0, R0, #1

    LDR     R1, =Code               ;   [R1] <-- address of Code - 1
    SUB     R1, R1, #1

    MOV     R2, #1                  ;   [R2] <-- 1
    MOV     R3, #1                  ;   [R3] <-- 1
    MOV     R4, #1                  ;   [R4] <-- 1
    MOV     R11, #0                 ;   [R11] <-- 0

LOOP_Detect
    LDRB    R5, [R1, R3]            ;   load the next bit in the string

    CMP     R5, #0x0                ;   is the next character null?
    BEQ     DoneDetect              ;   character is null - end of string

    CMP     R5, #'0'                ;   is the bit 0, as opposed to 1?
    BEQ     END_LOOP_Detect         ;   if 0, do nothing

    EOR     R11, R11, R3            ;   if bit is 1, XOR with current state of R11

END_LOOP_Detect
    ADD     R3, R3, #1              ;   increment loop counter
    B       LOOP_Detect             ;   continue looping indefinitely

DoneDetect
    CMP     R11, #0x0               ;   is R11 0? check for even parity
    BEQ     DoneCorrect             ;   if R11 = 0, no parity error

    LDRB    R5, [R1, R11]           ;   get the wrong bit in the string

    CMP     R5, #'0'                ;   is the bit 0?
    BEQ     FlipOne                 ;   if 0, flip to 1

FlipZero
    MOV     R5, #'0'                ;   bit is 1, flip to zero
    B       DoneFlip

FlipOne
    MOV     R5, #'1'                ;   bit is 0, flip to 1

DoneFlip
    STRB    R5, [R1, R11]           ;   store corrected, flipped bit

DoneCorrect
    MOV     R2, #1                  ;   [R2] <-- 1
    MOV     R3, #1                  ;   [R3] <-- 1
    MOV     R4, #1                  ;   [R4] <-- 1

LOOP_Trans
    LDRB    R5, [R1, R3]            ;   get next character in the string

    CMP     R5, #0                  ;   is the character null?
    BEQ     DONE                    ;   character is null - end of string

    CMP     R3, R4                  ;   is R3 = R4?
    BEQ     CheckBit                ;   if R3 = R4, check bit rather than data

DataBit
    STRB    R5, [R0, R2]            ;   store the source word data bit
    ADD     R2, R2, #1              ;   [R2]++
    ADD     R3, R3, #1              ;   [R3]++

    B       LOOP_Trans

CheckBit
    ADD     R3, R3, #1              ;   [R3]++
    MOV     R4, R4, LSL #1          ;   [R4] = [R4] * 2

    B       LOOP_Trans

DONE
    MOV     R0, #0x18               ;   angel_SWIreason_ReportException
    LDR     R1, =0x20026            ;   ADP_Stopped_ApplicationExit
    SVC     #0x11                   ;   previously SWI


    AREA    Data, DATA

    EXPORT  ADDR_Source

ADDR_Source
    DCD     Source

Code
    DCB     "111111000001101", 0    ;    Hamming code string to process

Source
    %       100                     ;    Storage space for source word string


    END
