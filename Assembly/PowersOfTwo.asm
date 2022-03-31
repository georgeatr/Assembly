TITLE PowersOfTwo (PowersOfTwo.asm)
;Jorge Torres Reyes
;Assignment 5
;Problem B
;This program takes a number from the user then uses a procedure to check if the number is a power of two by returning the zero flag set or not.

INCLUDE Irvine32.inc

.data

prompt BYTE "Enter a number: ",0
itIsP  BYTE "Is a power of two!",0
itsNotP BYTE "It is not a power of two :(",0
val1 DWORD ?

.code
main PROC

l1:
	mov edx,OFFSET prompt							;This is the printing of the numbers
	call WriteString								;It repeats if it is not equals to -1
	call ReadInt									;Then it calls the procedure to check if it is a power of two
	cmp eax,-1										;It also writes the binary number after the procedure
	je done											;It is based on the zero flag returned by the procedure
	call powerOfTwo
	jnz option2
	mov edx,OFFSET itIsP
	call WriteString
	jmp next
option2:
	mov edx,OFFSET itsNotP
	call WriteString
next:
	call CrLf
	call WriteBin
	call CrLf
	loop l1
done:



	exit
main ENDP

;***************************************
;REQUIRES: A value suplied by the user on EAX
;RETURNS: Zero Flag set to 1 if its a power of 2, Zero Flag set to 0 if not a power of two
;
powerOfTwo PROC uses eax
;***************************************
	
	mov ebx,1
	mov ecx,32							;Loop the size of a dword to check 
l1:
	cmp ebx,eax							;Compare if it is equal to 1
	je itIs								;If it is then set the flag to 1
	rol ebx,1							;IF not rotate 1 and check if its equal again
	loop l1
	jmp notPower						;If the loop finishes then its not a power of two
itIs:
	and ebx,0							;Set the flag to 1
notPower:

	ret
powerOfTwo ENDP

END main
