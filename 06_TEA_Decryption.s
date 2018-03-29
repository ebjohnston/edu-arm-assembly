;   TEA Algorithm - Decryption
;   Ethan Johnston

;   Assignment 01
;   Network Security - CS 3750
;   Fall 2016

;   This program decrypts a single pair of rounds of some ciphertext encoded
;   with a Tiny Encryption Algorithm (TEA), yielding a plaintext output

    AREA    TEA_Decryption, CODE, READONLY
    EXPORT  main                    ;   required by the startup code
    ENTRY

main
    LDR     R12, =LTwo              ;   [R12] <-- address of LTwo
    LDR     R0, [R12]               ;   [R0]  <-- value of LTwo

    LDR     R12, =KTwo              ;   [R12] <-- address of KTwo
    LDR     R1, [R12]               ;   [R1]  <-- value of KTwo

    ADD     R2, R1, R0, LSL #4      ;   [R2]  <-- (L2 << 4) + K2

    LDR     R12, =KThree            ;   [R12] <-- address of KThree
    LDR     R1, [R12]               ;   [R1]  <-- value of KThree

    ADD     R3, R1, R0, LSR #5      ;   [R3]  <-- (L2 >> 5) + K3

    LDR     R12, =DeltaTwo          ;   [R12] <-- address of DeltaTwo
    LDR     R1, [R12]               ;   [R1]  <-- value of DeltaTwo

    ADD     R4, R1, R0              ;   [R4]  <-- L2 + d2

    EOR     R2, R2, R3              ;   [R2]  <-- ((L2 << 4) + K2) XOR ((L2 >> 5) + K3)
    EOR     R2, R2, R4              ;   [R2]  <-- ((L2 << 4) + K2) XOR ((L2 >> 5) + K3) XOR (L2 + d2)

    LDR     R12, =RTwo              ;   [R12] <-- address of RTwo
    LDR     R1, [R12]               ;   [R1]  <-- value of RTwo

    SUB     R1, R1, R2              ;   [R1]  <-- R2 - [((L2 << 4) + K2) XOR ((L2 >> 5) + K3) XOR (L2 + d2)]

    ; Register R0 stores 'ROne'
    ; Register R1 stores 'LOne'

    LDR     R12, =KZero             ;   [R12] <-- address of KZero
    LDR     R2, [R12]               ;   [R2]  <-- value of KZero

    ADD     R3, R2, R1, LSL #4      ;   [R3]  <-- (R0 << 4) + K0

    LDR     R12, =KOne              ;   [R12] <-- address of KOne
    LDR     R2, [R12]               ;   [R2]  <-- value of KOne

    ADD     R4, R2, R1, LSR #5      ;   [R4]  <-- (R0 >> 5) + K1

    LDR     R12, =DeltaOne          ;   [R12] <-- address of DeltaOne
    LDR     R2, [R12]               ;   [R2]  <-- value of DeltaOne

    ADD     R5, R2, R1              ;   [R5]  <-- R1 + d1

    EOR     R3, R3, R4              ;   [R3]  <-- ((R0 << 4) + K0) XOR ((R0 >> 5) + K1)
    EOR     R3, R3, R5              ;   [R3]  <-- ((R0 << 4) + K0) XOR ((R0 >> 5) + K1) XOR (R1 + d1)

    SUB     R0, R0, R3              ;   [R0]  <-- L2 - ((R0 << 4) + K0) XOR ((R0 >> 5) + K1) XOR (R1 + d1)

    ; Register R0 stores 'LZero'
    ; Register R1 stores 'RZero'

    LDR     R2, =LZero              ;   [R2]  <-- address of LZero
    STR     R0, [R2]                ;   stores L0 in memory at LZero

    LDR     R2, =RZero              ;   [R2]  <-- address of RZero
    STR     R1, [R2]                ;   stores R0 in memory at RZero

DONE
    MOV     R0, #0x18               ;   angel_SWIreason_ReportException
    LDR     R1, =0x20026            ;   ADP_Stopped_ApplicationExit
    SVC     #0x11                   ;   previously SWI


    AREA    Data, DATA, READWRITE

    EXPORT ADDR_LZero
    EXPORT ADDR_RZero

ADDR_LZero
    DCD     LZero
ADDR_RZero
    DCD     RZero

DeltaOne                            ;   the first delta offset used in the decryption
    DCD     0x11111111
DeltaTwo                            ;   the second delta offset used in the decryption
    DCD     0x22222222

KZero                               ;   the first key used in the decryption
    DCD     0x90001C55
KOne                                ;   the second key used in the decryption
    DCD     0x1234ABCD
KTwo                                ;   the third key used in the decryption
    DCD     0xFEDCBA98
KThree                              ;   the first key used in the decryption
    DCD     0xE2468AC0

LTwo                                ;   original input - ciphertext to be decrypted
    DCD     0xB72599B2
RTwo                                ;   original input - ciphertext to be decrypted
    DCD     0xCF8E5A4C

LZero                               ;   reserved space for plaintext output
    DCD     0x00000000
RZero                               ;   reserved space for plaintext output
    DCD     0x00000000


    END
