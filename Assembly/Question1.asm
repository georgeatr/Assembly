TITLE Question1 {Question1.asm}
;Jorge Torres Reyes
;Assignment 7
;COSC2406
;Question 1
;This program gives the properties of a regular rhombicosidodecahedron with the input of the length of an edge from the user.

INCLUDE Irvine32.inc

.data

prompt  BYTE "Enter the length of the edge for a rhombicosidodecahedron (0 to end): ",0
SAmsg   BYTE "The surface area for the rhombicosidodecahedron is:               ",0
volmsg  BYTE "The volume for the rhombicosidodecahedron is:                     ",0
circmsg BYTE "The cirumsphere radius for the rhombicosidodecahedron is:         ",0
midmsg  BYTE "The midsphere radius for the rhombicosidodecahedron is:           ",0
volmid	BYTE "The volume of the midsphere for the rhombicosidodecahedron is:    ",0
volcirc	BYTE "The volume of the circumsphere for the rhombicosidedecaherdon is: ",0
invalidNum BYTE  "Invalid number! ",0
byePrompt BYTE "Goodbye!",0

E			REAL8 ?
temp		DWORD ?
midradius	REAL8 ?
circradius	REAL8 ?

.code
main PROC
FINIT

top:
	mov edx,OFFSET prompt						;Prompt for the number
	call WriteString
	call ReadFloat
	call CrLf

	FLDZ										;Load a zero
	FCOMP										;Compare both numbers at ST(0) and ST(1)
	FNSTSW AX									;Get the flags
	SAHF										;Put flag on AX into EFLAGS
	je done
	jb continue									;Jump if its okay
	
	mov edx,OFFSET invalidNum					;Invalid number prompt
	call WriteString
	call CrLf
	call CrLf

	jmp top

continue:
	FSTP E										;Store the length on a variable

	call surfaceArea							;Result for surface area
	mov edx,OFFSET SAmsg
	call WriteString
	call WriteFloat
	FSTP ST(0)
	call CrLf

	call Volume									;Result for volume
	mov edx,OFFSET volmsg
	call WriteString
	call WriteFloat
	FSTP ST(0)
	call CrLf

	call cirumsphere							;Result for circumsphere radius
	mov edx,OFFSET circmsg
	call WriteString
	call WriteFloat
	FSTP circradius
	call CrLf
	
	call midsphere								;Result for midsphere radius
	mov edx,OFFSET midmsg
	call WriteString
	call WriteFloat
	FSTP midradius
	call CrLf

	call volumeCircum							;Result for the volume of the circumsphere
	mov edx,OFFSET volcirc
	call WriteString
	call WriteFloat
	FSTP ST(0)
	call CrLf
	
	call volumeMidsphere						;Result for the volume of the midsphere
	mov edx,OFFSET volmid
	call WriteString
	call WriteFloat
	FSTP ST(0)
	call CrLf
	call CrLf

	jmp top
done:	
	FSTP ST(0)
	call showFPUstack

	exit
main ENDP

;*********************************
;RECIVES: The length of the edge for the shape
;Returns: The surface area at ST(0) on the stack
;
surfaceArea PROC
;*********************************
	pushad
												;Main formula: (30 + 5sqrt3 + 3sqrt(25+10sqrt5)) * e^2
	FLD E										;Load the length given into the 
	FLD E										;Load the length again
	FMULP										;e^2

	mov temp,5									;Start with 5
	FILD temp									;Load temp(5) into ST(0)
	FSQRT										;Square root the item at the top of the stack and store it bacK (sqrt5)

	mov temp,10									;Use 10 
	FILD temp									;Load it onto stack
	FMULP										;Multiply by 10 and keep the answer on ST(0)
												;By now e^2 is at ST(1),and at ST(0) we have (10sqrt5)
	
	mov temp,25									;Use 25
	FIADD temp									;Add number at ST(0) plus 25
	FSQRT										;sqrt(25+10sqrt5) = Square root the item at ST(0)

	mov temp,3									;Use 3
	FILD temp									;Load into stack
	FMULP										;ST(1) * ST(0) = 3 * sqrt(25+10sqrt5)

	FILD temp									;Load 3 which is already in temp
	FSQRT										;sqrt3
	mov temp,5									;Use 5
	FILD temp
	FMULP										;Multiply 5 * sqrt3
	FADDP										;Add ST(0) with ST(1)

	mov temp,30									;Use 30
	FILD temp									;Load 30 in stack
	FADDP										;Add 30 to the equation
												;By now e^2 is at ST(1) and at ST(0) we have (30 + 5sqrt3 + 3sqrt(25+10sqrt5))

	FMULP										;Multiply (30 + 5sqrt3 + 3sqrt(25+10sqrt5)) * e^2
												;Answer is on ST(0)

	popad
	ret
surfaceArea ENDP

;*********************************
;RECIVES: The length of the edge for the shape
;RETURNS: The volume at ST(0) on the stack
;
volume PROC
;*********************************
	pushad
												;Formula 1/3 (60 + 29sqrt5) * e^3

	FLD E										;Load the length 2 times and multiply
	FLD E
	FMULP
	FLD E										;Load once more and multiply and you get e^3
	FMULP

	mov temp,5									;Use 5
	FILD temp									;Load into stack
	FSQRT										;sqrt5

	mov temp,29									;Use 29
	FILD temp									;Load into stack
	FMULP										;Multiply 29 * sqrt5

	mov temp,60									;Use 60
	FILD temp									;Load into stack
	FADDP										;Add 60 to 29sqrt5

	mov temp,1									;1 over 3
	FILD temp
	mov temp,3
	FILD temp
	FDIVP

	FMULP										;1/3 * (60 + 29sqrt5)
	FMULP										;1/3 (60 + 29sqrt5) * e^3

	popad
	ret
volume ENDP

;*********************************
;RECIVES: The length of the edge for the shape
;RETURNS: The circumsphere at ST(0) on the stack
;
cirumsphere PROC
;*********************************
	pushad
												;Formula 1/2 * e * sqrt(11 + 4sqrt5)

	FLD E										;Load length into stack
	
	mov temp,1									;1/2
	FILD temp
	mov temp,2
	FILD temp
	FDIVP

	mov temp,5									;sqrt5
	FILD temp
	FSQRT

	mov temp,4									;4 * sqrt5
	FILD temp
	FMULP

	mov temp,11									;11 + 4sqrt5
	FILD temp
	FADDP

	FSQRT										;sqrt(11+ 4sqrt5)
	FMULP										;1/2 * sqrt(11+ 4sqrt5)
	FMULP										; e * 1/2 * sqrt(11+ 4sqrt5)

	popad
	ret	
cirumsphere ENDP

;*********************************
;RECIVES: The length of the edge for the shape
;RETURNS: The midsphere at ST(0) on the stack
;
midsphere PROC
;*********************************
	pushad
												;Formula 1/2 * e * sqrt(10 + 4sqrt5)

	FLD E										;Load length into stack
	
	mov temp,1									;1/2
	FILD temp
	mov temp,2
	FILD temp
	FDIVP

	mov temp,5									;sqrt5
	FILD temp
	FSQRT

	mov temp,4									;4 * sqrt5
	FILD temp
	FMULP

	mov temp,10									;11 + 4sqrt5
	FILD temp
	FADDP

	FSQRT										;sqrt(11+ 4sqrt5)
	FMULP										;1/2 * sqrt(11+ 4sqrt5)
	FMULP										; e * 1/2 * sqrt(11+ 4sqrt5)

	popad
	ret
midsphere ENDP

;*********************************
;RECIVES: The radius for the circumsphere
;RETURNS: The volume of the circumsphere at ST(0) on the stack
;
volumeCircum PROC
;*********************************
	pushad
												;Formula 4/3 * PI * r^3
	FLD circradius								;r^3
	FLD circradius
	FMULP
	FLD circradius
	FMULP

	mov temp,4									;4/3
	FILD temp
	mov temp,3
	FILD temp
	FDIVP

	FLDPI										;Load PI
	
	FMULP										;r^3 * 4/3
	FMULP										;r^3 * 4/3 * PI

	popad
	ret
volumeCircum ENDP

;*********************************
;RECIVES: The radius for the midsphere
;RETURNS: The volume of the midsphere at ST(0) on the stack
;
volumeMidsphere PROC
;*********************************
	pushad
												;Formula 4/3 * PI * r^3
	FLD midradius								;r^3
	FLD midradius
	FMULP
	FLD midradius
	FMULP

	mov temp,4									;4/3
	FILD temp
	mov temp,3
	FILD temp
	FDIVP

	FLDPI										;Load PI
	
	FMULP										;r^3 * 4/3
	FMULP										;r^3 * 4/3 * PI

	popad
	ret
volumeMidsphere ENDP

END main
