TITLE Problem 1  {Problem 1.asm}
;Jorge Torres Reyes
;Assignment 3
;Problem A
;This program takes a number from the user into a source and then prints it as a Hex and Binary number.

INCLUDE Irvine32.inc

.data

source DWORD 0;
target DWORD 0;
userIn BYTE "Enter a number: ",0
out1   BYTE "The value in source is (Binary,Hex,SignedInt): ",0
out2   BYTE "The value in target is (Binary,Hex,SignedInt): ",0

.code
main PROC

	mov edx,OFFSET userIn					;Prompt the user to write a signed int
	call WriteString
	call ReadInt
	mov source,eax
	call CrLf

	mov ecx,4						
	mov esi,OFFSET source
	mov edi,OFFSET target

l1:											;This loop goes for 4 times which is the size of a DWORD and moves each byte
	mov al,[esi]							;from the offet of both variables source and target
	mov [edi],al
	add esi,TYPE BYTE
	add edi,TYPE BYTE

	loop l1
	

	mov edx,OFFSET out1						;Write the source in Binary,Hex and Signed Int.
	call WriteString
	
	mov eax,source							;Binary source
	call WriteBin
	mov al,'b'
	call WriteChar
	call CrLf

	mov eax,source							;Hex Source
	call WriteHex
	mov al,'h'
	call WriteChar
	call CrLf

	mov eax,source							;Signed Int Source
	call WriteInt
	call CrLf

	mov edx,OFFSET out2						;Write the target in Binary,Hex and Signed Int.
	call WriteString

	mov eax,target							;Binary target
	call WriteBin
	mov al,'b'
	call WriteChar
	call CrLf

	mov eax,target							;Hex target
	call WriteHex
	mov al,'h'
	call WriteChar
	call CrLf

	mov eax,target							;Signed Int target
	call WriteInt

	exit
main ENDP
END main