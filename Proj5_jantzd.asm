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
	dailyHighs			DWORD	DAYS_MEASURED DUP(?)
	dailyHighsTitle		BYTE	"High temperature reading for each day:",13,10,0
	dailyLows			DWORD	DAYS_MEASURED DUP(?)
	dailyLowsTitle		BYTE	"Low temperature reading for each day:",13,10,0
	highTempAverage		DWORD	?
	lowTempAverage		DWORD	?

.code
main PROC

	CALL Randomize ; initialize the random seed for random number generation

	PUSH	OFFSET intro1
	PUSH	OFFSET intro2
	CALL	printGreeting

	; Generate a giant array of temperatures for all the days
	MOV		ECX, DAYS_MEASURED
	PUSH	OFFSET tempArray
	CALL	generateTemperatures

	; find highest temp of the day, add to high temps array
	PUSH	OFFSET tempArray
	PUSH	OFFSET dailyHighs
	CALL	findDailyHighs

	; find lowest temp of the day, add to low temps array
	PUSH	OFFSET tempArray
	PUSH	OFFSET dailyLows
	CALL	findDailyLows

	; find high temps average, store in a variable
	; find low temps average, store in a variable

	; Display the generated temperatures to the console window
	PUSH	OFFSET tempArray
	PUSH	OFFSET tempArrayTitle
	PUSH	DAYS_MEASURED
	PUSH	TEMPS_PER_DAY
	CALL	displayTempArray

	; display list of daily high temp values
	PUSH	OFFSET dailyHighs
	PUSH	OFFSET dailyHighsTitle
	PUSH	1
	PUSH	DAYS_MEASURED
	CALL	displayTempArray

	; display list of daily low temp values
	PUSH	OFFSET dailyLows
	PUSH	OFFSET dailyLowsTitle
	PUSH	1
	PUSH	DAYS_MEASURED
	CALL	displayTempArray

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
	CALL	CrLf
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
; Name: findDailyHighs
; Description: Finds the high for each day across the entire range of days, adds
;				each one to an array of daily highs.
; Preconditions: Temperature data needs to be fully generated and stored.
;					Memory should be allocated to store daily highs.
; Postconditions: None
; Receives:  
;	[EBP + 12] = OFFSET tempArray (input)
;	[EBP + 8] = OFFSET dailyHighs (output)
; Returns: dailyHighs array of daily high temperatures
; ---------------------------------------------------------------------------------
findDailyHighs PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	PUSH	ESI
	; ---------------------------------------------------------------------------------
	; Nested for loop. The outer for loop traverses across all the days, while the inner
	; for loop traverses across temperatures within a single day. ESI holds the current
	; max for each day of temperature readings and can be replaced by the conditional
	; structure inside the inner for loop. After traversing the entire day of temperatures,
	; we can be sure that ESI now holds the max temp for the day and we can add it to
	; the dailyHighs array.
	; ---------------------------------------------------------------------------------
	MOV		EBX, [EBP + 12]					; load start of tempArray for register indirect access
	MOV		EDX, [EBP + 8]					; load start of dailyHighs for register indirect access
	MOV		ECX, DAYS_MEASURED
	_FindAllHighs:
		PUSH	ECX
		MOV		ECX, TEMPS_PER_DAY
		MOV		ESI, [EBX]					; Set ESI to be the first temp of the day as current max until it gets beat
		_FindDailyHigh:
			CMP		[EBX], ESI				; compare current temp value to current max to see if it should be replaced
			JLE		_Continue
			_ReplaceCurrentMax:
				MOV		ESI, [EBX]
			_Continue:
				ADD		EBX, 4				; increment EBX to access next tempArray element
				LOOP	_FindDailyHigh
		MOV		[EDX], ESI					; daily high is found! store it in dailyHighs
		ADD		EDX, 4						; move forward so we can modify next value in dailyHighs
		POP		ECX
		LOOP	_FindAllHighs
	POP		ESI
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		8							; dereference both parameters
findDailyHighs ENDP

; ---------------------------------------------------------------------------------
; Name: findDailyLows
; Description: Finds the low for each day across the entire range of days, adds
;				each one to an array of daily lows.
; Preconditions: Temperature data needs to be fully generated and stored.
;					Memory should be allocated to store daily lows.
; Postconditions: None
; Receives:  
;	[EBP + 12] = OFFSET tempArray (input)
;	[EBP + 8] = OFFSET lowsHighs (output)
; Returns: lowsHighs array of daily low temperatures
; ---------------------------------------------------------------------------------
findDailyLows PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	PUSH	ESI
	; ---------------------------------------------------------------------------------
	; Nested for loop. The outer for loop traverses across all the days, while the inner
	; for loop traverses across temperatures within a single day. ESI holds the current
	; min for each day of temperature readings and can be replaced by the conditional
	; structure inside the inner for loop. After traversing the entire day of temperatures,
	; we can be sure that ESI now holds the min temp for the day and we can add it to
	; the dailyLows array.
	; ---------------------------------------------------------------------------------
	MOV		EBX, [EBP + 12]					; load start of tempArray for register indirect access
	MOV		EDX, [EBP + 8]					; load start of dailyLows for register indirect access
	MOV		ECX, DAYS_MEASURED
	_FindAllLows:
		PUSH	ECX
		MOV		ECX, TEMPS_PER_DAY
		MOV		ESI, [EBX]					; Set ESI to be the first temp of the day as current min until it gets beat
		_FindDailyLow:
			CMP		[EBX], ESI				; compare current temp value to current min to see if it should be replaced
			JGE		_Continue
			_ReplaceCurrentMin:
				MOV		ESI, [EBX]
			_Continue:
				ADD		EBX, 4				; increment EBX to access next tempArray element
				LOOP	_FindDailyLow
		MOV		[EDX], ESI					; daily low is found! store it in dailyLows
		ADD		EDX, 4						; move forward so we can modify next value in dailyLows
		POP		ECX
		LOOP	_FindAllLows
	POP		ESI
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		8							; dereference both parameters
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
; Returns: None
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
	MOV		ECX, [EBP + 12]				; Repeat someRows times
	_PrintAll:
		PUSH	ECX
		MOV		ECX, [EBP + 8]			; Repeat someColumns times
		_PrintRow:
			MOV		EAX, [EBX]
			CALL	WriteDec
			MOV		AL, 20h				; move in the hex value for a space into AL
			CALL	WriteChar
			CALL	WriteChar
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

