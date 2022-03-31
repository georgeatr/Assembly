TITLE Question2 {Question2.asm}
;Jorge Torres Reyes
;COSC2406
;Assignment 7
;Question 2
;This program takes a float number from the user and uses a procedure to shift right and left to change the number into binary.

INCLUDE Irvine32.inc

.data

prompt BYTE "Enter a float value: ",0
power BYTE " x 2^",0
result BYTE "Float in Binary: ",0
number DWORD ?
exp DWORD ?

.code
main PROC

	mov edx,OFFSET prompt
	call WriteString
	call ReadFloat									;Read a float

	FSTP number										;Store it into a dword
	mov eax,number

	mov edx,OFFSET result							
	call WriteString

	PUSH number										;Push the parameter into the stack
	call FloatingPointDisplay						;Call the procedure
	

	exit
main ENDP

;*******************************
;REQUIRES: A number in a variable as a parameter to be changed into binary
;RETURNS: A binary representation for the floating point number.
;
FloatingPointDisplay PROC
;
;*******************************
	
	ENTER 4,0

	mov eax,[EBP + 8]

	SHL eax,1										;Shift left the number to check the sign value
	JC negative										;If theres a carry place a negative sign
	JNC positive									;If no carry place a possitive sign					

positive:											;Print if positive
	
	mov al,'+'
	call WriteChar
	mov al,'1'
	call WriteChar
	mov al,'.'
	call WriteChar
	jmp next

negative:											;Print if negative

	mov al,'-'
	call WriteChar
	mov al,'1'
	call WriteChar
	mov al,'.'
	call WriteChar

next:

	mov ebx,eax										;Shift 24 times to isolate exponent on a variable
	SHR ebx,24
	sub ebx,127										;Subtract 127 to get the number
	mov exp,ebx

	SHL eax,8										;Get rid of the exponent
	
	mov ecx,18										;Printing
	mov ebx,eax
l1:
	SHL ebx,1
	JNC zero
one:
	mov al, '1'
	call WriteChar
	jmp cont
zero:
	mov al, '0'
	call WriteChar
cont:

	loop l1

	mov edx,OFFSET power
	call WriteString
	mov eax,exp
	call WriteInt
	
	LEAVE

	ret 4
FloatingPointDisplay ENDP

END main