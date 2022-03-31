TITLE Problem 4 {Problem 4.asm}
;Jorge Torres
;Assignment 3
;Problem D
;This program creates an array of 10 user inputed values then shifts them by one position by direct addressing.

INCLUDE Irvine32.inc

.data

array1 DWORD 10 DUP(?)
prompt BYTE "Enter a number: ",0
counter DWORD 0;

.code
main PROC
	
	 mov ecx,LENGTHOF array1
	 mov esi,OFFSET array1

l1:										;Populate the array
	mov edx,OFFSET prompt
	call WriteString
	call ReadInt

	mov [esi], eax
	add esi, TYPE array1

	loop l1

	mov ecx,array1 + 36					;mov each value by the using the size of a DWORD and replace it by the value previous to it,
										;The last value is the first to be stored and last to be put into the first index of the array
	mov eax,array1 + 32
	mov array1 + 36,eax
	mov ebx,array1 + 28
	mov array1 + 32,ebx
	mov eax,array1 + 24
	mov array1 + 28,eax
	mov ebx,array1 + 20
	mov array1 + 24,ebx
	mov eax,array1 + 16
	mov array1 + 20,eax
	mov ebx,array1 + 12
	mov array1 + 16,ebx
	mov eax,array1 + 8
	mov array1 + 12,eax
	mov ebx,array1 + 4
	mov array1 + 8,ebx
	mov eax,array1
	mov array1 + 4,eax

	mov array1,ecx
	


	call CrLf
	mov ecx,LENGTHOF array1				;Reset the values of the counter and the index
	mov esi,OFFSET array1

l3:										;Print the array
	
	movsx eax, WORD PTR [esi]
	add esi,TYPE array1
	call WriteInt

	mov al, " "
	call WriteChar

	loop l3

	exit
main ENDP
END main