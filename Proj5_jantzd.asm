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

; (insert constant definitions here)
DAYS_MEASURED = 14
TEMPS_PER_DAY = 11
MIN_TEMP = 20
MAX_TEMP = 80

.data

; tempArray -- DAYS_MEASURED X TEMPS_PER_DAY
; high temps array -- size is days measured
; low temps array -- size is days measured
; high temp average
; low temp average

.code
main PROC

; introduce program and programmer, describe functionality
; figure out array size needed to hold all daily temps... or do this on paper?
; loop for as many days as there are:
;		generate random array of temps
;		find highest temp of the day, add to high temps array
;		find lowest temp of the day, add to low temps array
; find high temps average, store in a variable
; find low temps average, store in a variable
; display list of temperature values for each day
; display list of daily high temp values
; display list of daily low temp values
; display average high temp
; display average low temp

	Invoke ExitProcess,0	; exit to operating system
main ENDP

printGreeting PROC
	RET
printGreeting ENDP

generateTemperatures PROC
	RET
generateTemperatures ENDP

findDailyHighs PROC
	RET
findDailyHighs ENDP

findDailyLows PROC
	RET
findDailyLows ENDP

calcAverageLowHighTemps PROC
	RET
calcAverageLowHighTemps ENDP

displayTempArray PROC
	RET
displayTempArray ENDP

displayTempwithString PROC
	RET
displayTempwithString ENDP

END main
