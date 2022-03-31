TITLE Problem 3 {Problem3.asm}
;Jorge Torres
;Assignment 3
;Problem C
;This program takes signed and unsigned integers from the user then solves a formula using various registers

INCLUDE Irvine32.inc

.data

P DWORD 0
Q SDWORD 0
R DWORD 0
S SDWORD 0
T DWORD 0
prompt1 BYTE "Enter an unsigned value for P: ",0
prompt2 BYTE "Enter a signed value for Q: ",0
prompt3 BYTE "Enter an unisgned value for R: ",0
prompt4 BYTE "Enter a signed value for S: ",0
prompt5 BYTE "Enter an unsigned value for T: ",0
answer BYTE "4T + (P-3Q) - (S + 2R) = ",0

.code
main PROC

	mov edx,OFFSET prompt1					;All the print prompts for each letter
	call WriteString
	call ReadInt
	mov P,eax

	mov edx,OFFSET prompt2
	call WriteString
	call ReadInt
	mov Q,eax
	
	mov edx,OFFSET prompt3
	call WriteString
	call ReadInt
	mov R,eax

	mov edx,OFFSET prompt4
	call WriteString
	call ReadInt
	mov S,eax

	mov edx, OFFSET prompt5
	call WriteString
	call ReadInt
	mov T,eax

	mov ebx,T								;Add 4 times T , ebx in use
	add ebx,T
	add ebx,T
	add ebx,T
	
	mov ecx,Q								;Add 3 times Q, ecx in use
	add ecx,Q
	add ecx,Q
	
	mov edx,P								;Subtract P from 3Q, edx in use, ecx can be used
	sub edx,ecx

	add ebx,edx								;Add 4T to (P-3Q) , ebx in use, edx and ecx can be used

	mov ecx,R								;Add 2 times R, ecx in use
	add ecx,R

	mov edx,S								;Add S to 2R, edx is in use, ecx can be used
	add edx,ecx

	sub ebx,edx								;Subtract first half of equation from second half and send to eax to print
	mov eax,ebx

	mov edx, OFFSET answer					;Print the result
	call WriteString
	call WriteInt



	exit
main ENDP
END main