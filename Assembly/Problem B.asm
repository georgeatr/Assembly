TITLE Problem B {Problem B.asm}
;Jorge Torres Reyes
;Assignment #4
;This program uses random range and a user made procedure to make a better random range that takes a high and a low number.

INCLUDE Irvine32.inc

.data

low1 DWORD 0
high1 DWORD 0
msg1 BYTE "Enter the low number: ",0
msg2 BYTE "Enter the high number: ",0

.code
main PROC

	call Randomize
	mov ecx,5

l1:

	mov edx,OFFSET msg1								;Write First Prompt
	call WriteString
	call ReadInt
	mov low1,eax

	mov edx, OFFSET msg2							;Write Second Prompt
	call WriteString
	call ReadInt
	mov high1,eax

	mov ebx,low1									;Pass the low and high valuse to the procedure
	mov eax,high1
	call BetterRandomRange
	call WriteInt

	call CrLf

	loop l1

	exit
main ENDP

;******************************************
;REQUIRES: eax,ebx
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

END main