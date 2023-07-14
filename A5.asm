.model small
.stack 64

;Macrodefinitii
;Get XOR Bit 1
getXORbit1 MACRO
	PUSH AX
	PUSH CX
	XOR AX, AX

	;Bit 18
	MOV AL, lfsr1[2]
	AND AL, lfsr1Mask18
	MOV CL, 5
	SHR AL, CL
	MOV bit18_lfsr1, AL
	
	;Bit 17
	MOV AL, lfsr1[2]
	AND AL, lfsr1Mask17
	MOV CL, 6
	SHR AL, CL
	MOV bit17_lfsr1, AL
	
	;Bit 16
	MOV AL, lfsr1[2]
	AND AL, lfsr1Mask16
	MOV CL, 7
	SHR AL, CL
	MOV bit16_lfsr1, AL
	
	;Bit 13
	MOV AL, lfsr1[1]
	AND AL, lfsr1Mask13
	MOV CL, 2
	SHR AL, CL
	MOV bit13_lfsr1, AL
	
	;Next bit
	MOV AL, bit18_lfsr1
	XOR AL, bit17_lfsr1
	XOR AL, bit16_lfsr1
	XOR AL, bit13_lfsr1
	MOV nextBit1, AL
	
	POP CX
	POP AX
ENDM

; Shift register 1
shiftRegister1 MACRO bitToAdd
	PUSH AX
	PUSH CX
	
	XOR AX, AX
	
	;Saving the random bit
	MOV AL, lfsr1[2]
	AND AL, lfsr1Mask18
	MOV CL, 5
	SHR AL, CL
	MOV randomBit1, AL
	
	
	;Saving the last bit from each byte
	MOV AL, lfsr1[0]
	AND AL, 1
	MOV CL, 7
	SHL AL, CL
	MOV lastBit0_lfsr1, AL
	
	MOV AL, lfsr1[1]
	AND AL, 1
	MOV CL, 7
	SHL AL, CL
	MOV lastBit1_lfsr1, AL
	
	;Shifting 0
	SHR lfsr1[0], 1

	;Adding the next bit
	MOV AL, bitToAdd
	MOV CL, 7
	SHL AL, CL
	OR lfsr1[0], AL
	MOV AL, 0
	
	
	;Shifting 1
	SHR lfsr1[1], 1
	;Adding the new bit
	MOV AL, lastBit0_lfsr1
	OR lfsr1[1], AL
	
	;Shifting 2
	SHR lfsr1[2], 1
	;Adding the new bit
	MOV AL, lastBit1_lfsr1
	OR lfsr1[2], AL
	
	
	;Canceling the other bits
	;MOV AL, lfsr1[2]
	AND lfsr1[2], 0E0h
	;MOV lfsr1[2], AL
	
	
	POP CX
	POP AX
ENDM


;Get XOR Bit 2
getXORbit2 MACRO
	PUSH AX
	PUSH CX
	XOR AX, AX

	;Bit 21
	MOV AL, lfsr2[2]
	AND AL, lfsr2Mask21
	MOV CL, 2
	SHR AL, CL
	MOV bit21_lfsr2, AL
	
	;Bit 20
	MOV AL, lfsr2[2]
	AND AL, lfsr2Mask20
	MOV CL, 3
	SHR AL, CL
	MOV bit20_lfsr2, AL
	
	;Next bit
	MOV AL, bit21_lfsr2
	XOR AL, bit20_lfsr2
	MOV nextBit2, AL
	
	POP CX
	POP AX
ENDM


; Shift register 2
shiftRegister2 MACRO bitToAdd
	PUSH AX
	PUSH CX
	
	XOR AX, AX
	
	;Saving the random bit
	MOV AL, lfsr2[2]
	AND AL, lfsr2Mask21
	MOV CL, 2
	SHR AL, CL
	MOV randomBit2, AL
	
	
	;Saving the last bit from each byte
	MOV AL, lfsr2[0]
	AND AL, 1
	MOV CL, 7
	SHL AL, CL
	MOV lastBit0_lfsr2, AL
	
	MOV AL, lfsr2[1]
	AND AL, 1
	MOV CL, 7
	SHL AL, CL
	MOV lastBit1_lfsr2, AL
	
	;Shifting 0
	SHR lfsr2[0], 1

	;Adding the next bit
	MOV AL, bitToAdd
	MOV CL, 7
	SHL AL, CL
	OR lfsr2[0], AL
	MOV AL, 0
	
	
	;Shifting 1
	SHR lfsr2[1], 1
	;Adding the new bit
	MOV AL, lastBit0_lfsr2
	OR lfsr2[1], AL
	
	;Shifting 2
	SHR lfsr2[2], 1
	;Adding the new bit
	MOV AL, lastBit1_lfsr2
	OR lfsr2[2], AL
	
	
	;Canceling the other bits
	AND lfsr2[2], 0FCh
	
	
	POP CX
	POP AX
ENDM


;Get XOR Bit 3
getXORbit3 MACRO
	PUSH AX
	PUSH CX
	XOR AX, AX

	;Bit 22
	MOV AL, lfsr3[2]
	AND AL, lfsr3Mask22
	MOV CL, 1
	SHR AL, CL
	MOV bit22_lfsr3, AL
	
	;Bit 21
	MOV AL, lfsr3[2]
	AND AL, lfsr3Mask21
	MOV CL, 2
	SHR AL, CL
	MOV bit21_lfsr3, AL
	
	;Bit 20
	MOV AL, lfsr3[2]
	AND AL, lfsr3Mask20
	MOV CL, 3
	SHR AL, CL
	MOV bit20_lfsr3, AL
	
	;Bit 7
	MOV AL, lfsr3[0]
	AND AL, lfsr3Mask7
	MOV bit7_lfsr3, AL
	
	;Next bit
	MOV AL, bit22_lfsr3
	XOR AL, bit21_lfsr3
	XOR AL, bit20_lfsr3
	XOR AL, bit7_lfsr3
	MOV nextBit3, AL
	
	POP CX
	POP AX
ENDM


; Shift register 3
shiftRegister3 MACRO bitToAdd
	PUSH AX
	PUSH CX
	
	XOR AX, AX
	
	;Saving the random bit
	MOV AL, lfsr3[2]
	AND AL, lfsr3Mask22
	MOV CL, 1
	SHR AL, CL
	MOV randomBit3, AL
	
	
	;Saving the last bit from each byte
	MOV AL, lfsr3[0]
	AND AL, 1
	MOV CL, 7
	SHL AL, CL
	MOV lastBit0_lfsr3, AL
	
	MOV AL, lfsr3[1]
	AND AL, 1
	MOV CL, 7
	SHL AL, CL
	MOV lastBit1_lfsr3, AL
	
	;Shifting 0
	SHR lfsr3[0], 1

	;Adding the next bit
	MOV AL, bitToAdd
	MOV CL, 7
	SHL AL, CL
	OR lfsr3[0], AL
	MOV AL, 0
	
	
	;Shifting 1
	SHR lfsr3[1], 1
	;Adding the new bit
	MOV AL, lastBit0_lfsr3
	OR lfsr3[1], AL
	
	;Shifting 2
	SHR lfsr3[2], 1
	;Adding the new bit
	MOV AL, lastBit1_lfsr3
	OR lfsr3[2], AL
	
	
	;Canceling the other bits
	AND lfsr3[2], 0FEh
	
	
	POP CX
	POP AX
ENDM


;Registries initialization
registriesInitWithSeed MACRO
	LOCAL lCounter, lByte, label1, label2, labelEnd
	
	PUSH AX
	PUSH CX
	PUSH SI
	
	XOR AX, AX
	XOR CX, CX
	XOR SI, SI
	
	MOV CL, seedLength
	
	lSeed:
		PUSH CX
		
		MOV CX, 8
		lByte:
			PUSH CX

			MOV AL, seedMask
			MOV CL, seedMaskCounter
			SHL AL, CL
			MOV seedMask, AL
			
			MOV AL, initialSeed[SI]
			AND AL, seedMask
			MOV CL, seedMaskCounter
			SHR AL, CL
			MOV bitValueOfSeed, AL
			
			; Jump to the macro
			JMP label1
			label2:
			
			MOV seedMask, 1
			SUB seedMaskCounter, 1
			
			POP CX
		loop lByte
		
		; Refacere seedMask si seedMaskCounter
		MOV seedMaskCounter, 7
		ADD SI, 1
		
		POP CX 
	loop lSeed
	JMP labelEnd
	
label1:
	getNewBitAndShiftAll bitValueOfSeed
	JMP label2
	
labelEnd:
	POP SI
	POP CX
	POP AX
ENDM


; Getting the new bit and shifting
getNewBitAndShiftAll MACRO valueToXOR
	PUSH AX
	
	; lfsr1
	getXORbit1
	MOV AL, nextBit1
	XOR AL, valueToXOR
	MOV nextBit1, AL
	shiftRegister1 nextBit1
	
	; lfsr2
	getXORbit2
	MOV AL, nextBit2
	XOR AL, valueToXOR
	MOV nextBit2, AL
	shiftRegister2 nextBit2
	
	; lfsr3
	getXORbit3
	MOV AL, nextBit3
	XOR AL, valueToXOR
	MOV nextBit3, AL
	shiftRegister3 nextBit3


	POP AX
ENDM

; Getting the new bit and shifting one
getNewBitAndShiftLfsr1 MACRO valueToXOR
	PUSH AX
	
	; lfsr2
	getXORbit2
	MOV AL, nextBit2
	XOR AL, valueToXOR
	MOV nextBit2, AL
	shiftRegister2 nextBit2
	
	POP AX
ENDM


; Getting the new bit and shifting one
getNewBitAndShiftLfsr2 MACRO valueToXOR
	PUSH AX
	
	; lfsr1
	getXORbit1
	MOV AL, nextBit1
	XOR AL, valueToXOR
	MOV nextBit1, AL
	shiftRegister1 nextBit1
	
	POP AX
ENDM


; Getting the new bit and shifting one
getNewBitAndShiftLfsr3 MACRO valueToXOR
	PUSH AX
	
	; lfsr3
	getXORbit3
	MOV AL, nextBit3
	XOR AL, valueToXOR
	MOV nextBit3, AL
	shiftRegister3 nextBit3
	
	POP AX
ENDM



;Frame Counter
registriesInitWithFrameCounter MACRO
	LOCAL lCounter, lByte, label1, label2, labelEnd
	
	PUSH AX
	PUSH CX
	PUSH SI
	
	XOR AX, AX
	XOR CX, CX
	XOR SI, SI
	
	MOV CL, frameLength
	
	lCounter:
		PUSH CX
		
		MOV CX, 8
		lByte:
			PUSH CX

			MOV AL, frameMask
			MOV CL, frameMaskCounter
			SHL AL, CL
			MOV frameMask, AL
			
			MOV AL, frameCounter[SI]
			AND AL, frameMask
			MOV CL, frameMaskCounter
			SHR AL, CL
			MOV bitValueOfFrame, AL
			
			; Jump to the macro
			JMP label1
			label2:
			
			MOV frameMask, 1
			SUB frameMaskCounter, 1
			
			POP CX
		loop lByte
		
		; Refacere frameMask si frameMaskCounter
		MOV frameMaskCounter, 7
		ADD SI, 1
		
		POP CX 
	loop lCounter
	JMP labelEnd
	
label1:
	getNewBitAndShiftAll bitValueOfFrame
	JMP label2
	
labelEnd:
	POP SI
	POP CX
	POP AX
ENDM



; Get clocking bits
getClockingBits MACRO
	PUSH AX
	PUSH CX
	XOR AX, AX
	XOR CX, CX
	
	;Clock bit 1
	MOV AL, lfsr1[1]
	AND AL, 80h
	MOV CL, 7
	SHR AL, CL
	MOV clockBit1, AL
	
	;Clock bit 2
	MOV AL, lfsr2[1]
	AND AL, 20h
	MOV CL, 5
	SHR AL, CL
	MOV clockBit2, AL
	
	;Clock bit 3
	MOV AL, lfsr3[1]
	AND AL, 20h
	MOV CL, 5
	SHR AL, CL
	MOV clockBit3, AL
	
	POP CX
	POP AX
ENDM



; Get majority bit
getMajorityBit MACRO
	PUSH AX
	XOR AX, AX
	
	MOV AL, clockBit1
	ADD AL, clockBit2
	ADD AL, clockBit3
	
	SHR AL, 1
	MOV majorityBit, AL
	
	POP AX
ENDM



; Cycle 100 times with clocks
cycle100Times MACRO
	LOCAL l100times, label1, label2, label3, labelCode, labelBack, labelEnd,
	LOCAL labelInt1, labelInt2, labelInt3, labelCode1, labelCode2, labelCode3

	PUSH AX
	PUSH CX
	XOR AX, AX
	XOR CX, CX
	
	MOV CL, 100
	l100times:
		
		getClockingBits
		getMajorityBit
		
		JMP labelCode
		labelBack:
		
	loop l100times
	JMP labelEnd
	
	; Code label
	labelCode:
	; Checking and shifting LFSR 1
	MOV AL, clockBit1
	CMP AL, majorityBit
	
	JNE labelInt1
	JMP labelCode1
	labelInt1:
	JMP label1
	
	labelCode1:
	getXORbit1
	shiftRegister1 nextBit1
	
	label1:
	; Checking and shifting LFSR 2
	MOV AL, clockBit2
	CMP AL, majorityBit
	
	JNE labelInt2
	JMP labelCode2
	labelInt2:
	JMP label2
	
	labelCode2:
	getXORbit2
	shiftRegister2 nextBit2
		
	label2:
	; Checking and shifting LFSR 3
	MOV AL, clockBit3
	CMP AL, majorityBit
	
	JNE labelInt3
	JMP labelCode3
	labelInt3:
	JMP label3
	
	labelCode3:
	getXORbit3
	shiftRegister3 nextBit3
		
	label3:
	JMP labelBack
	
	
	labelEnd:
	POP CX
	POP AX
ENDM



; Generating N random bytes
generatingNrandomBytes MACRO noBytes
	LOCAL lNtimes, label1, label2, label3, labelCode, labelBack, labelEnd, lByte,
	LOCAL labelInt1, labelInt2, labelInt3, labelCode1, labelCode2, labelCode3

	PUSH AX
	PUSH CX
	PUSH SI
	XOR AX, AX
	XOR CX, CX
	XOR SI, SI
	
	MOV CL, noBytes
	lNtimes:
		
		PUSH CX
		MOV CX, 8
		lByte:
			getClockingBits
			getMajorityBit
		
			JMP labelCode
			labelBack:
			
		loop lByte
		
		PUSH AX
		MOV AL, resultByte
		MOV randomBytes[SI], AL
		
		MOV resultByte, 0
		MOV resultByteCounter, 7
		ADD SI, 1
		
		POP AX
		POP CX
		
	loop lNtimes
	JMP labelEnd
	
	; Code label
	labelCode:
	; Generating random bit
	randomBitGeneration
	
	; Checking and shifting LFSR 1
	MOV AL, clockBit1
	CMP AL, majorityBit
	
	JNE labelInt1
	JMP labelCode1
	labelInt1:
	JMP label1
	
	labelCode1:
	getXORbit1
	shiftRegister1 nextBit1
	
	label1:
	; Checking and shifting LFSR 2
	MOV AL, clockBit2
	CMP AL, majorityBit
	
	JNE labelInt2
	JMP labelCode2
	labelInt2:
	JMP label2
	
	labelCode2:
	getXORbit2
	shiftRegister2 nextBit2
		
	label2:
	; Checking and shifting LFSR 3
	MOV AL, clockBit3
	CMP AL, majorityBit
	
	JNE labelInt3
	JMP labelCode3
	labelInt3:
	JMP label3
	
	labelCode3:
	getXORbit3
	shiftRegister3 nextBit3
		
	label3:
	JMP labelBack
	
	
	labelEnd:
	POP SI
	POP CX
	POP AX
ENDM


; Saving the random bits from each lfsr
savingAllRandomBits MACRO
	PUSH AX
	PUSH CX
	XOR AX, AX
	XOR CX, CX
	
	;Saving the random bit
	MOV AL, lfsr1[2]
	AND AL, lfsr1Mask18
	MOV CL, 5
	SHR AL, CL
	MOV randomBit1, AL
	
	;Saving the random bit
	MOV AL, lfsr2[2]
	AND AL, lfsr2Mask21
	MOV CL, 2
	SHR AL, CL
	MOV randomBit2, AL
	
	;Saving the random bit
	MOV AL, lfsr3[2]
	AND AL, lfsr3Mask22
	MOV CL, 1
	SHR AL, CL
	MOV randomBit3, AL

	POP CX
	POP AX
ENDM 


; Generation of a random bit
randomBitGeneration MACRO
	PUSH AX
	PUSH CX
	XOR AX, AX
	XOR CX, CX
	
	savingAllRandomBits
	
	; Getting the new bit for the random number
	MOV AL, randomBit1
	XOR AL, randomBit2
	XOR AL, randomBit3
	MOV resultBit, AL

	; Shifting the bit 
	MOV AL, resultBit
	MOV CL, resultByteCounter
	SHL AL, CL
	MOV resultBit, AL
	
	; Adding the new bit to the new byte
	MOV AL, resultByte
	OR AL, resultBit
	MOV resultByte, AL
	
	SUB resultByteCounter, 1

	POP CX
	POP AX
ENDM


; Generating random seed with data from RAM
generatingRandomSeed MACRO ramDataAdress
	LOCAL seedLenghtLoop
	
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH SI
	
	MOV CL, seedLength
	MOV SI, 0
	seedLenghtLoop:
	
		MOV BX, ramDataAdress
		ADD BX, SI
		MOV AX, [BX]
		XOR AL, AH
		
		MOV initialSeed[SI], AL
		ADD SI, 1
		
	loop seedLenghtLoop

	POP SI
	POP CX
	POP BX
	POP AX
ENDM



.data
	; Result
	randomBytes DB 8 DUP (?)
	noRandomBytes DB 8
	
	; Registries
	lfsr1 DB 00h, 00h, 00h
	lfsr2 DB 00h, 00h, 00h
	lfsr3 DB 00h, 00h, 00h
	majorityBit DB ?
	
	; For printing
	outString DB 'a', '$'
	
	; Intermediar result
	resultBit DB ?
	resultByte DB 0
	resultByteCounter DB 7


	; Initial seed
	initialSeed DB 70h, 61h, 73h, 73h, 77h, 6fh, 72h, 64h
	seedLength DB $ - initialSeed
	bitValueOfSeed DB ?
	seedMask DB 1
	seedMaskCounter DB 7
	
	; Frame counter
	frameCounter DB 0F0h, 32h, 11h, 0Fh
	frameLength DB $ - frameCounter
	bitValueOfFrame DB ?
	frameMask DB 1
	frameMaskCounter DB 7
	
	
	; LFSR 1
	randomBit1 DB ?
	nextBit1 DB ?
	clockBit1 DB ?

	lfsr1Mask18 DB 20h
	lfsr1Mask17 DB 40h
	lfsr1Mask16 DB 80h
	lfsr1Mask13 DB 04h
	
	bit18_lfsr1 DB ?
	bit17_lfsr1 DB ?
	bit16_lfsr1 DB ?
	bit13_lfsr1 DB ?

	lastBit0_lfsr1 DB ?
	lastBit1_lfsr1 DB ?
	
	
	; LFSR 2
	randomBit2 DB ?
	nextBit2 DB ?
	clockBit2 DB ?

	lfsr2Mask21 DB 04h
	lfsr2Mask20 DB 08h
	
	bit21_lfsr2 DB ?
	bit20_lfsr2 DB ?

	lastBit0_lfsr2 DB ?
	lastBit1_lfsr2 DB ?


	; LFSR 3
	randomBit3 DB ?
	nextBit3 DB ?
	clockBit3 DB ?

	lfsr3Mask22 DB 02h
	lfsr3Mask21 DB 04h
	lfsr3Mask20 DB 08h
	lfsr3Mask7 DB 01h
	
	bit22_lfsr3 DB ?
	bit21_lfsr3 DB ?
	bit20_lfsr3 DB ?
	bit7_lfsr3 DB ?

	lastBit0_lfsr3 DB ?
	lastBit1_lfsr3 DB ?
	

.code
	MOV AX, @data
	MOV DS, AX

	; Getting the random seed from RAM
	generatingRandomSeed 0011h
	
	; Registries init with seed
	registriesInitWithSeed
	
	; Using a frame counter to lose the seed
	registriesInitWithFrameCounter
	
	; Cycle 100 time with clocks
	cycle100Times
	
	; Generating pseudo random number
	generatingNrandomBytes noRandomBytes
	
	
	; Adding the parameters to the stack
	XOR AX, AX
	MOV AL, noRandomBytes
	PUSH AX
	MOV AX, offset randomBytes
	PUSH AX
	MOV AX, offset outString
	PUSH AX
	
	; Calling print procedure
	CALL NEAR PTR printRandomBytes
	
	MOV AX, 4c00h
	INT 21h
	
	
;void print(char* str, byte* randomBytes, int size)
printRandomBytes PROC NEAR
	PUSH BP
	MOV BP, SP
  
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH SI
	XOR SI, SI
	MOV SI, 0
	
	NOP
	NOP
	NOP
	NOP
	
	MOV CX, [BP + 8]
	loopSize:
		PUSH CX
			
		; First nibble
		MOV BX, [BP + 6]
		MOV AL, [BX][SI]
		MOV CL, 4
		SHR AL, CL
		
		CMP AL, 10
		JL label1_firstNibble
		
		; Case its a character
		ADD AL, 37h
		MOV BX, [BP + 4]
		MOV [BX], AL
		JMP labelPrint_firstNibble
		
		label1_firstNibble:
		; Case its a number
		ADD AL, 30h
		MOV BX, [BP + 4]
		MOV [BX], AL
		
		labelPrint_firstNibble:
		; Print byte
		MOV AH, 09h
		MOV DX, [BP + 4]
		INT 21h
		
		
		; Second nibble
		MOV BX, [BP + 6]
		MOV AL, [BX][SI]
		AND AL, 0Fh 
		
		CMP AL, 10
		JL label1_secondNibble
		
		; Case its a character
		ADD AL, 37h
		MOV BX, [BP + 4]
		MOV [BX], AL
		JMP labelPrint_secondNibble
		
		label1_secondNibble:
		; Case its a number
		ADD AL, 30h
		MOV BX, [BP + 4]
		MOV [BX], AL
		
		labelPrint_secondNibble:
		; Print byte
		MOV AH, 09h
		MOV DX, [BP + 4]
		INT 21h
		
		
		; Adding space after a nibble
		MOV AL, 20h
		MOV BX, [BP + 4]
		MOV [BX], AL
		
		MOV AH, 09h
		MOV DX, [BP + 4]
		INT 21h
		
		ADD SI, 1
		POP CX
	loop loopSize
	

	POP SI
	POP CX
	POP BX
	POP AX
	POP BP
	RET 8
ENDP

end