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
	j dd ? ;��� 2-��� �������
	i dd ? ;array size
	a dd ?
	A dd 100 dup(?) ;��� ������� ������ ������ > 100 ��������� �������
	B dd 100 dup(0)


section '.code' code readable executable

	Start:	; ����������
		invoke printf, strN

		push i
		push emptyStr
		call [scanf]

		mov ebx,A    ;ebx - adress to A
		mov [counter],0 ;eax - counter

	ArrEnter: ;���� �������
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
		add ebx,4  ;next element (��������� 4 �����)
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
		mov ecx,0 ;����� [counter] �� ecx ���, ��� �� ������� � � ArrReformer ��� printf ������� �� ��� ������������

	ArrReformer:  ; ���������� �������
		mov edx,[ebx]

		cmp edx,0
		jg addnewindex
		jmp EndReformer

		addnewindex:
		mov [eax], ecx
		add [j],1
		add eax,4

		EndReformer:

		add ebx,4
		inc ecx

		cmp ecx,[i]
		jl ArrReformer

		mov ebx,B
		invoke printf, BStr
		invoke printf, arrayStr

		mov edx,[j]
		mov [i],edx

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











