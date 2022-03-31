TITLE Problem C {Problem C.asm}
;Jorge Torres Reyes
;Assignment #4
;This program takes a character to print,a color number for background and foreground then prints it 500 times accross the screen.

INCLUDE Irvine32.inc

.data

msg1 BYTE "Enter the character to print: ",0
msg2 BYTE "Enter the color of the foreground: ",0
msg3 BYTE "Enter the color of the background: ",0
charPrnt BYTE ?

.code
main PROC

	call Randomize

	 mov edx, OFFSET msg1							;Read char, it is not shown on the cmd screen
	 call WriteString
	 call ReadChar
	 mov charPrnt,al
	 call CrLf

	 mov edx, OFFSET msg2							;Read color for foreground.
	 call WriteString
	 call ReadHex
	 mov ebx,eax

	 mov edx, OFFSET msg3							;Read color for background.
	 call WriteString
	 call ReadHex
	 mov edx,eax

	 mov ecx,500
l1:													;Loop for the 500 random numbers 

	push ecx										;Push ecx to stack to keep main loop counter
	push ebx										;Push ebx to stack to keep the value from background color
	mov ecx,15
l2:													;Loop for background color (* 16)
	add ebx,ebx
	
	loop l2
	pop ecx											;Pop everything back
	pop ebx

	add ebx,edx										;Add foreground color to eax
	mov eax,ebx										;Move everything to eax for procedure call
	call SetTextColor

	push ebx										;push ebx so it doesnt reset to 0 after getting random range
	mov ebx,0
	
	mov eax,120
	call BetterRandomRange							;Random number for columns
	
	mov dl,al										;Set the random num for a column

	mov eax,30
	call BetterRandomRange							;Random number for rows
	
	mov dh,al										;Set the random num for a row

	call Gotoxy										;Move the cursor to the x and y locations

	mov al,charPrnt									;Write Character
	call WriteChar

	pop ebx

	mov eax,200										;Set the delay for each action of the loop
	call Delay

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