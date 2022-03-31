TITLE Problem A {Problem A.asm}
;Jorge Torres Reyes
;Assignment #4
;This program reads a file and creates 2 arrays one for index numbers and the other for letters, then uses the index numbers to select
;a letter and print it and then loops the length of the letter array to print a message

INCLUDE Irvine32.inc

.data

filename BYTE 20 DUP(?)
filehandle HANDLE ?
prompt BYTE "Enter the name of the file: ",0
letters BYTE 26 DUP(?)
index BYTE 27 DUP(?)

.code
main PROC
	
	mov edx,OFFSET prompt						;Enter the name of the file prompt
	call WriteString

	mov edx,OFFSET filename
	mov ecx,LENGTHOF filename					;Buffer for read String
	call ReadString
	
	
	mov edx,OFFSET filename						;Save the filename after reading the string
	call OpenInputFile
	mov filehandle,eax							;Save the handle after opnening the file


	mov eax,filehandle
	mov edx, OFFSET letters
	mov ecx, LENGTHOF letters
	Call ReadFromFile							;Reads all the values from the file into letters


	mov eax,filehandle
	mov edx, OFFSET index
	mov ecx, LENGTHOF index 
	Call ReadFromFile							;Reads all the values from the file into index arrays
	
	mov ecx, LENGTHOF letters
	mov esi, OFFSET letters

l1:												;Print letters for reference
	mov al,[esi]
	call WriteChar
	mov al,' '
	call WriteChar
	add esi,TYPE letters

	loop l1

	call CrLf
	mov ecx,LENGTHOF index
	mov esi, OFFSET index

l2:												;Print index for reference

	mov al, [esi]
	call WriteDec
	mov al, ' '
	call WriteChar
	add esi, TYPE index

	loop l2

	call CrLf

	mov ecx,26
	movzx esi, index[26]
	
l3:													;Formula for decrypting message
	
	mov al, letters[esi]							;Print char
	call WriteChar

	movzx esi, index[esi]							;Select the index number at the letter selected
	
	loop l3
	

	exit
main ENDP
END main