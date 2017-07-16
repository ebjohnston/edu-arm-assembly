; 	CS 2400 Assignment 04 - Part B
;	Ethan Johnston
;	Spring 2015

;	This program takes two separate strings as input and combines them character-by-
;		character to form a new string. The input strings are located at StrOne and
;		StrTwo and the combined string is stored in MixStr.
;	Registers Used:
;		R0 - buffer used to store each character as it is processed
;		R1 - memory address of the next character to be processed in StrOne
;		R2 - memory address of the next character to be processed in StrTwo
;		R3 - memory address of the next character to be added to MixStr


	AREA	Assignment_4B, CODE, READONLY
	ENTRY

Main
	LDR R1, =StrOne			;	[R1] <-- the address StrOne
	LDR R2, =StrTwo			;	[R2] <-- the address StrTwo
	LDR R3, =MixStr			;	[R2] <-- the address MixStr

LOOP_Main
	LDRB R0, [R1], #1		;	load a StrOne character into the R0 buffer
	CMP R0, #0x0			;	is the next character null?
	BEQ	DONE_StrOne			;	next character is null - process StrTwo
	STRB R0, [R3], #1		;	transfer the character from the buffer to MixStr

	LDRB R0, [R2], #1		;	load a StrTwo character into the R0 buffer
	CMP R0, #0x0			;	is the next character null?
	BEQ	DONE_StrTwo			;	next character is null - process StrOne
	STRB R0, [R3], #1		;	transfer the character from the buffer to MixStr

	B LOOP_Main				;	return to LOOP_Main


;	String One Finished Loop
;		Continues to concatenate the second string onto the combined
;       string until a null value is reached

DONE_StrOne
	LDRB R0, [R2], #1		;	load a StrTwo character into the R0 buffer
	CMP R0, #0x0			;	is the next character null?
	BEQ	DONE_Both			; 	next character is null - finish MixStr
	STRB R0, [R3], #1		;	transfer the character from the buffer to MixStr

	B DONE_StrOne			;	return to DONE_StrOne


;	String Two Finished Loop
;		Continues to concatenate the first string onto the combined
;       string until a null value is reached

DONE_StrTwo
	LDRB R0, [R1], #1		;	load a StrOne character into the R0 buffer
	CMP R0, #0x0			;	is the next character null?
	BEQ	DONE_Both			;	next character is null - finish MixStr
	STRB R0, [R3], #1		;	transfer the character from the buffer to MixStr

	B DONE_StrTwo			;	return to DONE_StrTwo


;	Both Strings Finished
;		Adds a null value to the end of the string and exits

DONE_Both
	STRB R0, [R3]			;	ensures the combined string ends in null
	SWI 0x11				;	terminate program


	AREA	Data, DATA

MAX_LEN	EQU 250				;	maximum character length of combined string


StrOne						;	first string to be combined
	DCB "Hello World", 0

StrTwo						;	second string to be combined
	DCB "To be or not to be", 0

MixStr 						;	reserved memory for the combined string
	% 251


	END
