;   TEA Algorithm - Encryption
;   Ethan Johnston

;   Assignment 01
;   Network Security - CS 3750
;   Fall 2016

;   This program encrypts some plaintext input using a single pair of rounds of
;   a Tiny Encryption Algorithm (TEA), yielding a ciphertext output

	AREA	TEA_Encryption, CODE, READONLY
	EXPORT	main                    ;   required by the startup code
	ENTRY

main
    LDR R12, =RZero                 ;   [R12] <-- address of RZero
    LDR R0, [R12]                   ;   [R0]  <-- value of RZero

    LDR R12, =KZero                 ;   [R12] <-- address of KZero
    LDR R1, [R12]                   ;   [R1]  <-- value of KZero

    ADD R2, R1, R0, LSL #4          ;   [R2]  <-- (R0 << 4) + K0

    LDR R12, =KOne                  ;   [R12] <-- address of KOne
    LDR R1, [R12]                   ;   [R1]  <-- value of KOne

    ADD R3, R1, R0, LSR #5          ;   [R3]  <-- (R0 >> 5) + K1

    LDR R12, =DeltaOne              ;   [R12] <-- address of DeltaOne
    LDR R1, [R12]                   ;   [R1]  <-- value of DeltaOne

    ADD R4, R1, R0                  ;   [R4]  <-- R0 + d1

    EOR R2, R2, R3                  ;   [R2]  <-- ((R0 << 4) + K0) XOR ((R0 >> 5) + K1)
    EOR R2, R2, R4                  ;   [R2]  <-- ((R0 << 4) + K0) XOR ((R0 >> 5) + K1) XOR (R0 + d1)

    LDR R12, =LZero                 ;   [R12] <-- address of LZero
    LDR R1, [R12]                   ;   [R1]  <-- value of LZero

    ADD R1, R1, R2                  ;   [R1]  <-- L0 + ((R0 << 4) + K0) XOR ((R0 >> 5) + K1) XOR (R0 + d1)

    ; Register R0 stores 'LOne'
    ; Register R1 stores 'ROne'

    LDR R12, =KTwo                  ;   [R12] <-- address of KTwo
    LDR R2, [R12]                   ;   [R2]  <-- value of KTwo

    ADD R3, R2, R1, LSL #4          ;   [R3]  <-- (R1 << 4) + K2

    LDR R12, =KThree                ;   [R12] <-- address of KThree
    LDR R2, [R12]                   ;   [R2]  <-- value of KThree

    ADD R4, R2, R1, LSR #5          ;   [R4]  <-- (R1 >> 5) + K3

    LDR R12, =DeltaTwo              ;   [R12] <-- address of DeltaTwo
    LDR R2, [R12]                   ;   [R2]  <-- value of DeltaTwo

    ADD R5, R2, R1                  ;   [R5]  <-- R1 + d2

    EOR R3, R3, R4                  ;   [R3]  <-- ((R1 << 4) + K2) XOR ((R1 >> 5) + K3)
    EOR R3, R3, R5                  ;   [R3]  <-- ((R1 << 4) + K2) XOR ((R1 >> 5) + K3) XOR (R1 + d2)

    ADD R0, R3, R0                  ;   [R0]  <-- L1 + ((R1 << 4) + K2) XOR ((R1 >> 5) + K3) XOR (R1 + d2)

    ; Register R0 stores 'RTwo'
    ; Register R1 stores 'LTwo'

    LDR R2, =RTwo                   ;   [R2]  <-- address of RTwo
    STR R0, [R2]                    ;   stores R2 in memory at RTwo

    LDR R2, =LTwo                   ;   [L2]  <-- address of LTwo
    STR R1, [R2]                    ;   stores L2 in memory at LTwo

done
	MOV		R0, #0x18               ;   angel_SWIreason_ReportException
	LDR		R1, =0x20026            ;   ADP_Stopped_ApplicationExit
	SVC		#0x11                   ;   previously SWI
;   BKPT    #0xAB                   ;   for semihosting - isn't supported in Keil's uV


    AREA	Data, DATA, READWRITE
    EXPORT adrLTwo
    EXPORT adrRTwo

adrLTwo         DCD LTwo
adrRTwo         DCD RTwo

DeltaOne                            ;   the first delta offset used for encryption
    DCD	0x11111111
DeltaTwo                            ;   the second delta offset used for encryption
    DCD	0x22222222

KZero                               ;   the first key used for encryption
    DCD 0x90001C55
KOne                                ;   the second key used for encryption
    DCD 0x1234ABCD
KTwo                                ;   the third key used for encryption
    DCD 0xFEDCBA98
KThree                              ;   the fourth key used for encryption
    DCD 0xE2468AC0

LZero                               ;   original input - plaintext to be encrypted
    DCD 0xA0000009
RZero                               ;   original input - plaintext to be encrypted
    DCD 0x8000006B

LTwo                                ;   reserved space for ciphertext output
    DCD 0x00000000
RTwo                                ;   reserved space for ciphertext output
    DCD 0x00000000

    END
