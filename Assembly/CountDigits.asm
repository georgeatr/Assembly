TITLE Count Digits and Letters in a text file (CountDigits.asm)
;Jorge Torres
;Assignment 5
;Problem A
;This program reads a file 100 characters at a time then it stores it into two different arrays then counts how many digits and letters
;there are

INCLUDE Irvine32.inc

.data

fileHandle HANDLE ?
fileName BYTE 20 dup(?)
fileBuffer BYTE 100 dup(?)
countDigit WORD 10 dup(?)
countLetters WORD 26 dup(?)
prompt BYTE "Enter the file name: ",0
result BYTE "Count of '",0
equalsq BYTE "'= ",0

nums BYTE 0
letters BYTE 'A'

.code
main PROC
	
TOP:
	mov edx,OFFSET prompt					;Loop while file handle is not valid
	call WriteString

	mov edx,OFFSET fileName					;Saving the file name
	mov ecx,LENGTHOF fileName
	call ReadString

	call OpenInputFile
	cmp eax, INVALID_HANDLE_VALUE			;Check if the file exist if not loop again
	je TOP
	mov filehandle,eax						;Storing the filehandle

reRead:
	mov eax,filehandle						;Read the file into a 100 buffer
	mov edx,OFFSET fileBuffer
	mov ecx,LENGTHOF fileBuffer
	call ReadFromFile
	cmp eax,0								;If no values read then finish the reading
	je done

	push eax
	mov ecx,eax								;Requirements for count digits procedure
	mov esi,OFFSET fileBuffer
	mov edi,OFFSET countDigit
	call CountDigits
	pop eax

	push eax
	mov ecx,eax								;Requirements for count letters procedure
	mov esi,OFFSET fileBuffer
	mov edi,OFFSET countLetters
	call lettersCount
	pop eax

	cmp eax,0								;If the ammount read is not zero read again
	jg reRead
done:
	call CrLf

	mov ecx,LENGTHOF countDigit
	mov esi,OFFSET countDigit
	mov edx,OFFSET fileName
	call WriteString
	call CrLf
l4:											;Print my counts for digits
	mov edx,OFFSET result
	call WriteString
	mov al,nums
	call WriteDec
	mov edx,OFFSET equalsq
	call WriteString
	mov al,[esi]
	call WriteDec
	add esi, TYPE BYTE
	inc nums
	call CrLf
	loop l4

	mov ecx,LENGTHOF countLetters			;Print my counts for letters
	mov esi,OFFSET countLetters
l5:
	mov edx,OFFSET result
	call WriteString
	mov al,letters
	call WriteChar
	mov edx,OFFSET equalsq
	call WriteString
	mov al,[esi]
	call WriteDec
	add esi,TYPE BYTE
	inc letters
	call CrLf
	loop l5

	exit
main ENDP

;***********************************
;REQUIRES: A value on the AL register
;RETURNS: The ZF if 0 = not a letter, if ZF = 1 its a letter.
;
isLetter PROC uses eax
;***********************************

	cmp al,97								;Compare between 97 - 122 for lowercase
	jnge else1
	cmp al,122
	jnle done
	test al,0								;Set flag to 1 if its between those two numbers
	jmp done
else1:
	cmp al,65								;Compare between 65 - 90 for Uppercase
	jnge done
	cmp al,90
	jnle done
	test al,0
done:

	ret
isLetter ENDP

;***********************************
;REQUIRES: ESI as offset of the buffer, EDI as the offset of the count,ECX for the size of the buffer. (The count array has to be size 10).
;RETURNS: A populated count array with the ammount of each number
;
countDigits PROC uses eax
;***********************************

	l2:												;Loop to count the ammount of digits.
	mov ax,[esi]
	call isDigit									;Checks if its a digit
	jnz next										;if its not a number go to next value	
	sub al,48										;Gets index value
	movzx edi,al									;Move the index to the index value
	inc countDigit[edi * TYPE countDigit]								;increase the count for each of the ocurrent digits on the count digit array
next:
	add esi,TYPE BYTE								;If its not a number then keep going on the array
	loop l2

	ret
countDigits ENDP

;***********************************
;REQUIRES: ESI as offset of the buffer, EDI as the offset of the count,ECX for the size of the buffer. (The count array has to be size 26).
;RETURNS: A populated count array with the ammount of each letter
;
lettersCount PROC
;***********************************
	push eax
	
	l3:	
	mov ax,[esi]									;Exact same as count digits but changes to isLetter changes them to upper case
	call isLetter									;then substract the value from the lowest letter to find the index on an array of 26
	jnz next
	and al,223
	sub al,65
	movzx edi,al
	inc countLetters[edi * TYPE countLetters]
next:
	add esi,TYPE BYTE
	loop l3

	pop eax
	ret
lettersCount ENDP

END main