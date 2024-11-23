TITLE Temperature Stats Shenanigans     (Proj5_jantzd.asm)

; Author: David Jantz
; Last Modified: 11/22/204
; OSU email address: jantzd@oregonstate.edu
; Course number/section:   CS271
; Project Number: 5                Due Date: 11/24
; Description: This program produces sets of random daily temperature statistics,
;				then summarizes them by displaying a list of daily highs and lows
;				as well as the averages of those highs and lows

INCLUDE Irvine32.inc

DAYS_MEASURED = 14
TEMPS_PER_DAY = 11
ARRAYSIZE = DAYS_MEASURED * TEMPS_PER_DAY
MIN_TEMP = 20
MAX_TEMP = 80

.data

intro1				BYTE	"Welcome to Temperature Statistics Shenanigans! Created by David Jantz",13,10,0
intro2				BYTE	"This program generates daily temperature readings over a range of days. It finds daily highs and lows, as well as the averages for those highs and lows. Enjoy!",13,10,0
tempArray			DWORD	ARRAYSIZE DUP(?)
tempArrayTitle		BYTE	"Daily temperature readings (one per day):",13,10,0
highTemps			DWORD	DAYS_MEASURED DUP(?)
lowTemps			DWORD	DAYS_MEASURED DUP(?)
highTempAverage		DWORD	?
lowTempAverage		DWORD	?

.code
main PROC

CALL Randomize ; initialize the random seed for random number generation

refer to program requirements section for procedure definitions

PUSH	OFFSET intro1
PUSH	OFFSET intro2
CALL	printGreeting

; Generate a giant array of temperatures for all the days
MOV		ECX, DAYS_MEASURED
PUSH	OFFSET tempArray
CALL	generateTemperatures

; Display the generated temperatures to the console window
PUSH	OFFSET tempArray
PUSH	OFFSET tempArrayTitle
PUSH	DAYS_MEASURED
PUSH	TEMPS_PER_DAY
CALL	displayTempArray

; find highest temp of the day, add to high temps array
; find lowest temp of the day, add to low temps array

; find high temps average, store in a variable
; find low temps average, store in a variable

; display list of temperature values for each day
; display list of daily high temp values
; display list of daily low temp values
; display average high temp
; display average low temp

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; --------------------------------------------------------------------------------- 
; Name: printGreeting
; Description: Introduces the program and the programmer.
; Preconditions: None
; Postconditions: None
; Receives:  
;	[EBP + 12] = OFFSET intro1
;	[EBP + 8] = OFFSET intro2
; Returns: None
; --------------------------------------------------------------------------------- 
printGreeting PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
	MOV		EDX, [EBP + 12]
	CALL	WriteString
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	POP		EDX
	POP		EBP
	RET		8					; dereference two parameters
printGreeting ENDP

; ---------------------------------------------------------------------------------
; Name: generateTemperatures
; Description: Fills out tempArray with random temperatures for the day.
; Preconditions: tempArray created, random seed initiated in main
; Postconditions: tempArray is now filled 
; Receives:  
;	[EBP + 8] = OFFSET tempArray
; Returns: filled tempArray with TEMPS_PER_DAY temperatures
; ---------------------------------------------------------------------------------
generateTemperatures PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	MOV		ECX, ARRAYSIZE
	MOV		EBX, [EBP + 8]		; load OFFSET tempArray into EBX
	_GenerateOneTemp:
		MOV		EAX, MAX_TEMP	
		SUB		EAX, MIN_TEMP	; subtract min from max
		CALL	RandomRange		; random int now in EAX
		ADD		EAX, MIN_TEMP	; add mintemp to that to move it to the proper range
		MOV		[EBX], EAX		; add value to the array
		ADD		EBX, 4			; increment up register indirect addressing by one DWORD
		LOOP	_GenerateOneTemp
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		4					; dereference tempArray
generateTemperatures ENDP

; ---------------------------------------------------------------------------------
; Name: 
; Description: 
; Preconditions: 
; Postconditions: 
; Receives:  
;	[EBP + ] = 
;	[EBP + ] = 
; Returns: 
; ---------------------------------------------------------------------------------
findDailyHighs PROC
	RET
findDailyHighs ENDP

; ---------------------------------------------------------------------------------
; Name: 
; Description: 
; Preconditions: 
; Postconditions: 
; Receives:  
;	[EBP + ] = 
;	[EBP + ] = 
; Returns: 
; ---------------------------------------------------------------------------------
findDailyLows PROC
	RET
findDailyLows ENDP

; ---------------------------------------------------------------------------------
; Name: 
; Description: 
; Preconditions: 
; Postconditions: 
; Receives:  
;	[EBP + ] = 
;	[EBP + ] = 
; Returns: 
; ---------------------------------------------------------------------------------
calcAverageLowHighTemps PROC
	RET
calcAverageLowHighTemps ENDP

; ---------------------------------------------------------------------------------
; Name: displayTempArray
; Description: Displays any temperature array to the console.
; Preconditions: An array filled with values.
; Postconditions: None
; Receives:
;	[EBP + 20] = OFFSET someArray
;	[EBP + 16] = OFFSET someTitle
;	[EBP + 12] = someRows
;	[EBP + 8] = someColumns
; Returns: 
; ---------------------------------------------------------------------------------
displayTempArray PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	CALL	CrLf
	MOV		EDX, [EBP + 16]
	CALL	WriteString					; display someTitle
	MOV		EBX, [EBP + 20]				; Put the start of the array in EBX for register indirect access
	MOV		ECX, [EBP + 8]				; Repeat someColumns times
	_PrintAll:
		PUSH	ECX
		MOV		ECX, [EBP + 12]			; Repeat someRows times
		_PrintRow:
			MOV		EAX, [EBX]
			CALL	WriteDec
			MOV		AL, 20h				; move in the hex value for a space into AL
			CALL	WriteChar
			ADD		EBX, 4
			LOOP	_PrintRow
		CALL	CrLf
		POP ECX
		LOOP _PrintAll
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		16							; dereference tempArray
displayTempArray ENDP

; ---------------------------------------------------------------------------------
; Name: 
; Description: 
; Preconditions: 
; Postconditions: 
; Receives:  
;	[EBP + ] = 
;	[EBP + ] = 
; Returns: 
; ---------------------------------------------------------------------------------
displayTempwithString PROC
	RET
displayTempwithString ENDP

END main


;	[EBP + 12] = OFFSET greeting
;	[EBP + 8] = OFFSET description
;	[EBP + 4] = return address
;	[EBP] = old EBP

