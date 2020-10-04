format PE console

entry Start

include 'win32a.inc'
include 'output.inc'

section '.data' data readable writable

	strN db 'Enter number of cells in array: ', 0
	strIa db 'Enter the  number in [',0
	strIb db '] array cell: ',0
	spaceStr db ', ', 0

	AStr db 'A',0
	BStr db 'B',0
	arrayStr db ' array:', 0
	enterStr db 10,13,0
	emptyStr db '%d',0

	counter dd ?
	i dd ? ;array size
	a dd ?
	A dd 100 dup(?) ;при попытке ввести массив > 100 программа вылетит
	B dd 100 dup(?)


section '.code' code readable executable

	Start:	; вступление
		invoke printf, strN

		push i
		push emptyStr
		call [scanf]

		mov ebx,A    ;ebx - adress to A
		mov [counter],0 ;eax - counter

	ArrEnter: ;ввод массива
		push strIa
		call [printf]

		push [counter]
		push emptyStr
		call [printf]

		push strIb
		call [printf]

		push a
		push emptyStr
		call [scanf]

		mov edx, [a]
		mov [ebx], edx
		add ebx,4  ;next element (следующие 4 байта)
		add [counter],1  ;next conut position

		mov ecx,[counter]
		cmp ecx,[i]
		jl ArrEnter

		mov ebx,A
		invoke printf, AStr
		invoke printf, arrayStr
		output

		mov ebx,A
		mov eax,B
		mov ecx,0 ;смена [counter] на ecx так, как он быстрее и в ArrReformer нет printf которая бы его использовала

	ArrReformer:  ; реформатор массива
		mov edx,[ebx]

		cmp edx,5
		jg bigger

		cmp edx,-5
		jl smaller

		mov edx, 0

		mov [eax], edx
		jmp EndReformer

		bigger:
		add edx, 5
		mov [eax], edx
		jmp EndReformer

		smaller:
		sub edx, 5
		mov [eax], edx
		jmp EndReformer

		EndReformer:
		add eax,4
		add ebx,4
		inc ecx

		cmp ecx,[i]
		jl ArrReformer

		mov ebx,B
		invoke printf, BStr
		invoke printf, arrayStr
		output

	exit:

		call [getch]

		push 0
		call [ExitProcess]

section '.idata' import data readable

	library kernel, 'kernel32.dll',\
		msvcrt, 'msvcrt.dll'

	import kernel,\
	       ExitProcess, 'ExitProcess'

	import msvcrt,\
	       printf, 'printf',\
	       scanf, 'scanf',\
	       getch, '_getch'











