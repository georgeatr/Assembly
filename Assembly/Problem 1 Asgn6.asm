TITLE Problem 1 Asgn6 (Problem 1 Asgn6.asm)
;Jorge Torres Reyes
;Assignment 6
;Problem 1
;

INCLUDE Irvine32.inc

.data

array1		 SWORD 10 DUP(-100)
menu BYTE	"Select one: ", 0Dh,0Ah,
			"1 - Populate the array with random numbers ", 0Dh,0Ah,
			"2 - Multiply the array with a user provided multiplayer, ", 0Dh,0Ah,
			"3 - Divide the array with a user provided divisor ", 0Dh,0Ah,
			"4 - Print the array", 0Dh,0Ah,
			"0 - Exit " , 0
optionPrompt BYTE "Enter your option: ", 0
multiPrompt	 BYTE "Enter the multiplier: ",0
divPrompt	 BYTE "Enter the divisor: ",0
prompt1		 BYTE "Array populated", 0
prompt2		 BYTE "Array multiplied", 0
prompt3		 BYTE "Array Divided", 0
prompt4		 BYTE "Array Printed", 0
prompt0		 BYTE "Terminating program",0
divisor		 SWORD ?

.code

printArray PROTO,								;Procedure Prototype
		arrayStart : PTR SWORD,
		arrayLength : DWORD

main PROC
	
	call Randomize								;Set the seed every time program runs

top:
	mov edx, OFFSET menu						;Menu of the program which compares to each of the options and jumps
	call WriteString							;depending on the option chosen
	call CrLf		
	call ReadInt
	cmp eax,0
	je done
	cmp eax,1
	je opt1
	cmp eax,2
	je opt2
	cmp eax,3
	je opt3
	cmp eax,4
	je opt4
	jmp done

opt1:

	PUSH OFFSET array1								;Populate the array option
	PUSH LENGTHOF array1
	call populateRandomNum

	mov edx,OFFSET prompt1							;Prompt of done
	call WriteString
	call CrLf
	jmp top

opt2:												;Multiplication option

	mov edx,OFFSET multiPrompt
	call WriteString
	call ReadInt
	mov ebx,eax										;Store the multiplier on ebx to be pushed
	call CrLf
	
	PUSH ebx										;Send all the parameters into the stack
	PUSH LENGTHOF array1
	PUSH OFFSET array1
	call multiplyArray								;Call the multiply function
	call CrLf
	
	mov edx,OFFSET prompt2							;Prompt of done
	call WriteString
	call CrLf
	jmp top

opt3:												;Division option
	
	
	mov edx,OFFSET divPrompt						;Write the prompt
	call WriteString
	call ReadInt
	
	mov ecx,LENGTHOF array1							;Size of array
	mov esi,OFFSET  array1							;Start of array
divEach:

	movsx ebx,WORD PTR[esi]
	PUSH eax										;Push both parameters
	PUSH ebx
	call divideArray								
	mov [esi],ax									;Move divided value into array
	add esi,TYPE array1								;Advance the index by WORD

	loop divEach

	mov edx, OFFSET prompt3							;Prompt of done
	call WriteString
	call CrLf
	jmp top

opt4:												;Print option
	INVOKE printArray, OFFSET array1,LENGTHOF array1
	call CrLf
	
	mov edx, OFFSET prompt4							;Prompt of done
	call WriteString
	call CrLf
	jmp top

done:

	mov edx, OFFSET prompt0							;Prompt of done
	call WriteString
	call CrLf

	exit
main ENDP


;*********************************
;REQUIRES:Two unamed parameters with the offset of the array and the length of the array
;RETURNS:A populated array with random numbers that range from -1500 to 2500
;
populateRandomNum PROC
;*********************************

	ENTER 4,0										;Make space for a local variable
	mov ecx, [EBP +8]								;Move the length of the array to ecx
	mov esi,[EBP +12]								;Move the offset taken from stack into esi
	mov DWORD PTR [EBP-4], TYPE WORD				;Local variable for the type fo the array

l1:
	mov eax, 2500									;Numbers for the range min and max
	mov ebx, -1500
	call BetterRandomRange
	
	mov [esi],ax									;Move each number created into the array
	add esi,[EBP -4]								;Increment the index by the type of the array

	loop l1

	LEAVE
	ret 8
populateRandomNum ENDP

;******************************************
;REQUIRES: A high value on eax, and a low value on ebx
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

;******************************************
;REQUIRES: The offset of the array and the multiplier given by the user, and the length of the array
;RETURNS: The array multiplied by the number given
;
multiplyArray PROC,
	startArray : PTR SWORD,
	count : DWORD,
	multi : WORD

;******************************************
	
	mov ecx,count
	mov esi,startArray

mult1:
	mov ax,[esi]
	imul multi
	
	mov [esi],ax
	add esi, TYPE WORD
	
	loop mult1
	
	ret
multiplyArray ENDP

;******************************************
;REQUIRES: A divisor (BX) and a number (AX)
;RETURNS: a divided number on eax
;
divideArray PROC
;******************************************
	
	mov ax,[EBP +8]
	CWD
	mov bx,[EBP +12]
	idiv bx

	ret 8
divideArray ENDP

;******************************************
;REQUIRES: The offset of the array and the length of the array
;RETURNS: A formated and printed array
;
printArray PROC,
		arrayStart : PTR SWORD,						;One parameter takes the offset of the array the other the length
		arrayLength : DWORD
;******************************************
	pushad
	pushfd

	mov ecx,arrayLength								;Move length parameter into the counters
	dec ecx											;The loop will run 9 times
	mov esi,arrayStart								;Move the offset of the array into the index register

	mov al,'['
	call WriteChar

printl:												;Loop to print
	
	movsx eax,WORD PTR [esi]						;Pass every number into the array by sign extending
	call WriteInt
	mov al,','
	call WriteChar
	mov al,' '
	call WriteChar
	add esi, TYPE WORD								;Advance the index by type word
	
	loop printl

	movsx eax,WORD PTR [esi]						;Print the last value without the comma.	
	call WriteInt

	mov al,']'
	call WriteChar

	popfd
	popad
	ret
printArray ENDP

END main