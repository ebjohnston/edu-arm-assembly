; 	CS 2400 Exam One - Part Two
;	Ethan Johnston
;	Spring 2015

;	This program takes an array of 10 integers and counts the number
;		of integers within a valid range, then calculating the sum
;		of the valid integers. The number of valid integers processed
;		as well as the sum and an ASCII character representing the
;		sign of the sum are all stored to memory.
;	Registers Used:
;		R0 - buffer used to process integers in the array
;		R1 - integer array pointer
;		R2 - counter for number of integers added
;		R3 - sum of integers within valid range
;		R4 - while-loop counter
;		R5 - temporary memory address buffer


	AREA	ExamOne, CODE, READONLY
	ENTRY

Main
	LDR R1, =intArray		;	[R1] <-- the address intArray
	LDR R2, 0				;	[R2] <-- 0
	LDR R3, 0				;	[R3] <-- 0
	LDR R4, 0				;	[R4] <-- 0

LOOP_Main
	CMP R4, 10				;	is [R4] < 10?
	BGE DONE_Loop			;	[R4] >= 10, end while loop

	LDR R0, [R1], #4		;	load an array integer into the R0 buffer
	CMP R0, #0x9C			;	is [R0] >= -100?
	BLT	OutOfRange			; 	[R0] < -100, skip summation
	CMP R0, #0x64			;	is [R0] <= 100?
	BGT	OutOfRange			;	[R0] > 100, skip summation

	ADD R2, R2, #1			; 	[R2]++
	ADD R3, R3, R0			;	[R3] <-- [R3] + [R0]

OutOfRange
	ADD R4, R4, #1			;	[R4]++
	B LOOP_Main				;	return to LOOP_Main

DONE_Loop
	LDR R5, =counter		;	[R5] <-- the address counter
	STR R2, [R5]			;	stores R2 to counter in memory

	LDR R5, =sum			;	[R5] <-- the address sum
	STR R3, [R5]			;	stores R3 to sum in memory

	LDR R5, =sign			;	[R5] <-- the address sign
	TST R3, #2, 2			;	is [R3]'s MSB one?
	BNE	NEGATIVE			;	[R3]'s MSB is one - store 'N'

POSITIVE
	MOV R0, 0x50			;	[R0] <-- 'P'
	STRB R0, [R5]			;	Stores 'P' to sign in memory
	B DONE

NEGATIVE
	MOV R0, 0x4E			;	[R0] <-- 'N'
	STRB R0, [R5]			;	Stores 'N' to sign in memory

DONE
	SWI 0x11				;	terminate program


	AREA	Data, DATA

intArray					;	array of 10 signed 32-bit integers
	DCD 50, -125, 465, 232, 101, 145, 54, 25, -20

counter						;	number of values in summation
	DCD 0

sum							;	final value of the summation
	DCD 0

sign 						;	memory location of either 'P' or 'N'
	DCB 0, 0


	END
