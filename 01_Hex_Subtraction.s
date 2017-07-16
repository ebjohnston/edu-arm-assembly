; 	CS 2400 Assignment 04 - Part A
;	Ethan Johnston
;	Spring 2015

;	This program converts two hexadecimal numbers into their appropriate
;   	two's complement and then adds them together with the first operand
;		being negative and the second operand being positive, storing the
;		contents of the difference of "b - a" into RESULT
;	Inputs: A negative integer "a" and a positive integer "b"
;		The hexadecimal digits of a are contained within A_MSD and A_LSD
;		The hexadecimal digits of b are contained within B_MSD and B_LSD

	AREA	Assignment_4A, CODE, READONLY
	ENTRY

Main
	LDR R0, =A_MSD			;	[R0] <-- the address A_MSD
	LDR R1, =A_LSD			;	[R1] <-- the address A_LSD
	BL Hex2Bin
	TST R2, #2, 2			;	is [R2]'s MSB 0?
	BNE DONE				;	[R2]'s MSB is 1!
	MVN R4, R2				;	[R4] <-- a's one's complement
	ADD R4, R4, #1			;	[R4] <-- a's two's complement

	LDR R0, =B_MSD			;	[R0] <-- the address B_MSD
	LDR R1, =B_LSD			;	[R1] <-- the address B_LSD
	BL Hex2Bin
	TST R2, #2, 2			;	is [R2]'s MSB 0?
	BNE DONE				;	[R2]'s MSB is 1!
	MOV R5, R2				;	[R5] <-- b's two's complement

	ADD R6, R4, R5			;	[R6] <-- (b - a)'s two's complement
	LDR R7, =RESULT
	STR R6, [R7]			;	store resultant two's complement

DONE	SWI 0x11			;	terminate program


;	Hexadecimal to Binary Subroutine

;	Converts a positive hex value to two's complement
;		Range of the hex must be between 0 and 0x7FFFFFFF
;	Inputs: R0 is the address of the MSD and R1 is the address of the LSD
;	Outputs: R2 will store the binary two's complement value of the hex
;		R2 is assigned the value "0xFFFFFFFF" if the hex is invalid

Hex2Bin
	MOV R2, #0				;	clear result register

LOOP_Hex2Bin
	MOV R3, #0				;	clear register taking a digit
	LDRB R3, [R0], #1		;	get MSD of Hex
	CMP R3, #0x0			;	is it lower than 0?
	BLO InvalidHex			;	not a valid digit
	CMP R3, #0xF			;	is it higher than F (15)?
	BHI InvalidHex			;	not a valid digit

		;	Next, [R2] <-- [R2] * 16 + [R3]

	MOV R2, R2, LSL #1 		;	[R2] <-- original [R2] * 2
	TST R2, #2, 2			;	is [R2]'s MSB zero?
	BNE InvalidHex			;	[R4]'s MSB is 1

	MOV R2, R2, LSL #1 		;	[R2] <-- original [R2] * 4
	TST R2, #2, 2			;	is [R2]'s MSB zero?
	BNE InvalidHex			;	[R4]'s MSB is 1

	MOV R2, R2, LSL #1 		;	[R2] <-- original [R2] * 8
	TST R2, #2, 2			;	is [R2]'s MSB zero?
	BNE InvalidHex			;	[R4]'s MSB is 1

	MOV R2, R2, LSL #1 		;	[R2] <-- original [R2] * 16
	TST R2, #2, 2			;	is [R2]'s MSB zero?
	BNE InvalidHex			;	[R4]'s MSB is 1

	ADD R2, R2, R3			;	[R2] <-- original [R2] * 16 + [R3]
	TST R2, #2, 2			;	is [R2]'s MSB zero?
	BNE InvalidHex			;	[R2]'s MSB is 1

	CMP R0, R1
	BHI DONE_Hex2Bin 		;	LSD has been added
	B LOOP_Hex2Bin

InvalidHex					;	a digit beyond 0-F or out-of-range
	LDR R2, =0xFFFFFFFF

DONE_Hex2Bin
	MOV PC, LR				;	return of Hex2Bin


	AREA	Data, DATA

A_MSD	DCB	0xA				;	a's Most Significant Digit
	DCB	0x0
	DCB	0x5
	DCB	0xE
	DCB	0x6
A_LSD	DCB	0x5				;	a's Least Significant Digit
	ALIGN

B_MSD	DCB	0xF				;	b's Most Significant Digit
	DCB	0xA
	DCB	0x2
	DCB	0x4
	DCB	0x8
	DCB	0xB
	DCB	0x6
B_LSD	DCB	0xE				;	b's Least Significant Digit
	ALIGN

RESULT
	DCD	0x0					;	ASCII code of '-' if negative


	END
