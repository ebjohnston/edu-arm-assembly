; 	CS 2400 Assignment 06
;	Ethan Johnston
;	Spring 2015


	AREA	Assignment_6, CODE, READONLY
	ENTRY

Main
	LDR		R0, =SRC_WORD
	SUB		R0, R0, #1

	LDR		R1, =H_CODE
	SUB		R1, R1, #1

	MOV		R2, #0x1
	MOV		R3,	#0x1
	MOV		R4, #0x1
	MOV		R11, #0x0

LOOP_Detect
	LDRB	R5, [R1, R3]

	CMP		R5, #0x0
	BEQ		DoneDetect

	CMP		R5, #'0'
	BEQ		END_LOOP_Detect

	EOR		R11, R11, R3

END_LOOP_Detect
	ADD		R3, R3, #1
	B		LOOP_Detect

DoneDetect
	CMP		R11, #0x0
	BEQ		DoneCorrect

	LDRB	R5, [R1, R11]

	CMP		R5, #'0'
	BEQ		FlipOne

FlipZero
	MOV		R5, #'0'
	B		DoneFlip

FlipOne
	MOV		R5, #'1'

DoneFlip
	STRB	R5, [R1, R11]

DoneCorrect
	MOV		R2, #0x1
	MOV		R3, #0x1
	MOV		R4, #0x1

LOOP_Trans
	LDRB	R5, [R1, R3]

	CMP		R5, #0x0
	BEQ		DoneTrans

	CMP		R3, R4
	BEQ		CheckBit

DataBit
	STRB	R5, [R0, R2]
	ADD		R2, R2, #1
	ADD		R3, R3, #1

	B		LOOP_Trans

CheckBit
	ADD		R3, R3, #1
	MOV		R4, R4, LSL #1

	B		LOOP_Trans

DoneTrans
	MOV		R11, #0x0

	LDR		R0, =CODE_Str
	SWI		0x2

	LDR		R0, =H_CODE
	SWI		0x2

	MOV		R0, #0xA
	SWI		0x0
	SWI		0x0

	LDR		R0, =WORD_Str
	SWI		0x2

	LDR		R0, =SRC_WORD
	SWI		0x2

	SWI		0x11


	AREA	Data, DATA

MAX_LEN		EQU		100

CODE_Str	DCB		"Hamming Code: ", 0		;	Label for the hamming code

H_CODE		DCB		"111111000001101", 0	;	Hamming code string to process

WORD_Str	DCB		"Source Word:  ", 0		;	Label for the source word

SRC_WORD	%		MAX_LEN					;	Storage space for source word string


	END
