TITLE subStrings {subStrings.asm}
;Jorge Torres Reyes
;Assignment #8
;COSC2406
;This program

INCLUDE Irvine32.inc

.data

count = 100
myString BYTE count+1 DUP(?)
target BYTE count+1 DUP(?)
prompt   BYTE "Enter the string: ",0
prompt2  BYTE "Start index: ",0
prompt3  BYTE "End index: ",0
startI DWORD ?
endI   DWORD ?

.code
main PROC

	mov edx,OFFSET prompt									; Prompt
	call WriteString
	
	mov ecx,count											; Buffer for string
	mov edx,OFFSET myString
	call ReadString

	mov edx,OFFSET prompt2									; Input for start index
	call WriteString
	call ReadInt
	mov startI,eax

	mov edx, Offset prompt3									; Input for end index
	call WriteString
	call ReadInt
	mov endI, eax

	mov eax,startI											; Move everything into registers to call proc
	mov ebx,endI
	call Str_substring
	mov edx,OFFSET target
	call WriteString


	exit
main ENDP

;*******************************
;REQUIRES: Offset of the source, index of first character wanted, index of last character not wanted.
;RETURNS: The substring chosen.
;
Str_substring PROC
;*******************************
	
	cmp eax,0												;Compare if its less than zero to set to zero
	jb set
	jmp cont

set:
	mov eax,0												;Set to zero if below zero

cont:

	cmp eax,LENGTHOF myString								;Compare if the start index is greater than the length pf the string
	jg done

	cmp ebx,LENGTHOF myString								;Compare the end index with the length of the string and if is greater set to length
	jg	set2
	jmp cont2

set2:
	mov ebx,LENGTHOF myString								;Set to length if bigger

cont2:

	mov esi,OFFSET myString									;Set both indexes
	mov edi,OFFSET target

	add esi,eax												;Add the start index to eax
	mov ecx,ebx												;add the last index to the counter
	sub ecx,eax												;Subtract start index minus counter to see how much you are copying

	cld

	rep MOVSB												;Copy to target
	mov al,0
	STOSB													;Store the null terminated

done:


	ret	
Str_substring ENDP

END main