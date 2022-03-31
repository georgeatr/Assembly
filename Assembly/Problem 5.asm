TITLE Problem 5 [Problem 5.asm]
;Jorge Torres
;Assignment 3
;Problem E
;This program creates an array of 30 values with the first 4 known while the other 26 are unknown then uses the formula f(n-1) + 2 * (n-4)
;to populate the sequence of numbers it manipulates the index of the array during the loop to go back and use the known values and puts them
;into registers to be manipulated for the formula.

INCLUDE Irvine32.inc

.data

array1 DWORD 1,3,2,5,26 DUP(?)
num = 4 * SIZEOF DWORD

.code
main PROC

	mov al,'['
	call WriteChar
	
	mov ecx,4										;Loop for the known values
	mov esi,OFFSET array1

l1:
	mov eax,[esi]									;moving each value at the index into eax reg to be printed
	add esi,TYPE array1								;advance index by one
	call WriteDec

	mov al,','
	call WriteChar

	loop l1
	
	mov ecx,LENGTHOF array1							;loop for all the unknown values							
	mov esi,OFFSET array1
	add esi,num
	
	
	l2:

		sub esi, SIZEOF DWORD						;f(n-1)
		mov edx, DWORD PTR [esi]					;move f(n-1) to reg edx
		sub esi, SIZEOF DWORD * 3					;f(n-4)
		mov ebx, DWORD PTR [esi]					;move f(n-4) to reg ebx
		add esi, SIZEOF DWORD * 4					;reset the index to the first unknown value

		add ebx, ebx								;2 * f(n-4)
		add edx, ebx								;f(n-1) + 2 * f(n-4)
		mov DWORD PTR[esi], edx						;move the value of the answer into the index
		mov eax, edx								;move the value to the eax reg to be printed
		add esi, SIZEOF DWORD						;advance the index by one

		call WriteDec
		mov al,','
		call WriteChar

		loop l2

		mov al,']'
		call WriteChar

	exit
main ENDP
END main