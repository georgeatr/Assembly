TITLE Problem 2  {Problem.asm}
;Jorge Torres
;Assignment 3
;Problem B
;This program creates 2 Arrays with size based on a number constant and then uses loops to populate and print them.

INCLUDE Irvine32.inc

.data

NUM = 10
array1 WORD NUM DUP(?)
array2 DWORD NUM DUP(?)
input BYTE "Enter an Integer: ",0

.code
main PROC

	mov ecx,NUM										; Set the loop counter to the constant Num = 10
	mov edx,OFFSET input							; Move the beggining of the string to the edx reg
	mov esi, OFFSET array1							; Move the beggining of the first array to the index reg esi
	mov edi, OFFSET array2							; Move the beggining of the second array into the index reg edi

l1:													;Start of first loop, it populates both arrays
	call WriteString								
	call ReadInt
	mov [esi],eax								    ;Put each number that was writen into the index of the array
	add esi,TYPE array1								;Advance the index by the type (2) of array1

	loop l1

	mov ecx,NUM
	mov esi,OFFSET array1

l2:													;Copy each value from one array to the second
	mov ax,(TYPE array1) PTR [esi]					;Move the values from the first index of array 1 into a temp reg
	mov [edi],ax									;Copy the values from the temp reg into the first index of the second array
	add esi, TYPE array1
	add edi, TYPE array2

	loop l2


	mov ecx,NUM										;Reset loop counter to 10
	mov esi, OFFSET array1							;Reset index to the beggining of the array
	
l3:													;Start to print the array with the second loop

	movsx eax, (TYPE array1) PTR [esi]				;Move the first value in the array into the ax register to be printed
	add esi,TYPE array1								;Advance the index of the array to the next based on the size.

	call WriteInt

	mov al, " "
	call WriteChar

	loop l3
	
	call CrLf

	mov ecx,NUM										;Reset loop counter to 10
	mov edi, OFFSET array2							;Reset index to the beggining of the second array

l4:													;Start to print the second array with the third loop

	movsx eax,WORD PTR [edi]						;Move the first value in the array into the ax register to be printed
	add edi,TYPE array2								;Advance the index of the array to the next based on the size.

	call WriteInt

	mov al, " "
	call WriteChar

	loop l4

	exit
main ENDP
END main