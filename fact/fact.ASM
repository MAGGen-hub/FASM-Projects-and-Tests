; factorial test

format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

	strN db 'Enter N: ', 0
	strE db "N can't be > 12 or <= 0",0

	resStr db 10,13, 'Result: %d', 0
	modStr db ': %d', 0

	spaceStr db ' %d', 0
	emptyStr db '%d',0

	strRepeat db 10,13, 'Repeat? [y/n]:', 0
	enterStr db 10,13, 0  ;Just an Enter key

	N dd ?
	F dd ?

	NULL = 0

section '.code' code readable executable

       Start:
		push strN
		call [printf]

		push N
		push spaceStr
		call [scanf]

		cmp [N],0
		jle error

		cmp [N],12
		jle prelp
		jmp error

		prelp:
		      mov ecx,1
		      xor ebx,ebx
		      add ebx,1
		      mov [F],1
		      add [N],1

		jmp lp
		lp:
		   mov ecx,ebx
		   imul ecx,[F]
		   mov [F],ecx

		   cinvoke printf,emptyStr ,ebx

		   cinvoke printf, modStr, [F]

		   cinvoke printf, enterStr

		   add ebx,1

		   cmp ebx, [N]
		   jne lp
		   jmp finish

		error:

		      push strE
		      call [printf]
		      call [getch]

		finish:

		     push strRepeat
		     call [printf]

		     call [getch]

		     cmp eax, 121  ;121 <=> y
			 jne exit

			 push enterStr
			 call [printf]
			 jmp Start

		exit:

		push NULL
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