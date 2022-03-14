TITLE 2DArrays {2DArrays.asm}
;Jorge Torres Reyes
;COSC2406
;Assignment #8
;Problem 2
;This program

INCLUDE Irvine32.inc

.data

NUM_ROWS = 5
NUM_COLS = 5

myArray SWORD  NUM_ROWS * NUM_COLS DUP(?)
prompt BYTE "Which column to be added? ",0
result BYTE "The sum for the column selected"


.code

sumColumnOfArray PROTO,
numCols : DWORD,
numRows : DWORD,
offArray : DWORD,
colToAdd : DWORD

main PROC

	call Randomize								;Change the seed for randomRange

	call populateArray

	push OFFSET myArray							;Push unnamed parameters
	push NUM_ROWS
	push NUM_COLS
	call PrintArray

	mov edx,OFFSET prompt
	call WriteString
	call ReadInt
	

	INVOKE sumColumnOfArray, NUM_COLS, NUM_ROWS, OFFSET myArray, eax
	call WriteInt


	exit
main ENDP

;********************************
;REQUIRES: Nothing
;RETURNS: Nothing, but populates the array with random numbers from -100 to 100
;
populateArray PROC
;********************************

	mov esi,0									;Rows
	mov ecx,NUM_ROWS							;for(int i = 0; i < myArray.length;i++){
l1:
	push ecx

	mov edi,0									;Columns
	mov ecx, NUM_COLS							;	for(int j = 0; j < myArray[i].length; j++){
L2:

	mov eax, 100								;Random range parameters
	mov ebx, -100
	call BetterRandomRange
	mov WORD PTR myArray[esi],ax							;Put a value on each index
	
	add esi, TYPE WORD							; j++

	loop l2										;	}

	add edi,esi									; i++
	pop ecx
	loop l1										;}



	ret
populateArray ENDP

;******************************************
;REQUIRES: eax (High), ebx {Low}
;RETURNS: A number between two given numbers
;
BetterRandomRange PROC
;******************************************

	sub eax,ebx										;High - low
	add eax,1										;+1
	call RandomRange								
	add eax,ebx										;num + low

	ret
BetterRandomRange ENDP

;********************************
;REQUIRES: OFFSET of array, Number of columns and number of rows
;
;
PrintArray PROC
;********************************
	
	push ebp
	mov ebp,esp
	
	mov esi,[EBP + 16]							;Rows
	mov ecx, [EBP + 12]							;for(int i = 0; i < myArray.length;i++){

l1:
	push ecx
	mov edi,0									;Columns
	mov ecx, [EBP + 8]							;	for(int j = 0; j < myArray[i].length; j++){
	sub ecx,1

	mov al,'|'
	call WriteChar

L2:
	movsx eax, WORD PTR [esi+edi]				;	System.out.print (myArray[i][j] + " ");
	call WriteInt
	mov al,' '
	call WriteChar
	mov al,','
	call WriteChar

	add esi, TYPE WORD							; j++

	loop l2										;	}

	movsx eax,WORD PTR [esi + edi]
	call WriteInt

	mov al, '|'
	call WriteChar
	
	call CrLf

	add edi,esi									; i++
	pop ecx
	loop l1										;}


	mov esp,ebp
	pop ebp

	ret
PrintArray ENDP

;********************************
;REQUIRES: the num of columns the num of rows the offset of the array and the row to be added
;RETURNS: the sum on eax
;
SumColumnOfArray PROC,
numCols : DWORD,
numRows : DWORD,
offArray : DWORD,
colToAdd : DWORD

;********************************

LOCAL lengthRow : DWORD


	mov esi,offArray

	mov eax, colToAdd
	mov ebx, TYPE SWORD
	mul ebx
	mov edi, eax

	mov eax, numCols
	mul ebx
	mov ebx,eax


	mov ecx,numRows								
	mov eax,0
	dec ebx
	dec ebx

l1:

	movsx edx, SWORD PTR [esi + edi]
	add eax,edx
	add esi,ebx

	loop l1									


	ret
SumColumnOfArray ENDP

END main