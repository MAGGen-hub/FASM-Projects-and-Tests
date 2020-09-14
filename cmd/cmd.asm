; GetMainArgs v1.01
; Copyright © 2003 Theodor-Iulian Ciobanu

format PE console 4.0
entry start

include 'win32a.inc'
include 'cmd.inc'

  start:
  cinvoke printf, _msgcap, 0
  invoke _getch
	invoke	GetProcessHeap
	mov	[_hheap],eax
	invoke	HeapAlloc,[_hheap],HEAP_ZERO_MEMORY,1000h
	mov	[_strbuf],eax

	call	GetMainArgs
	mov	esi,[_argv]
       ; cinvoke printf,[_strbuf],_fmt1,[_argc]

       ; push [_strbuf]
       ; push _fmt1
       ; push [_argc]
       ; call [printf]

	cinvoke wsprintf,[_strbuf],_fmt1,[_argc]
	mov	ebx,[_argc]
    @@:
	cinvoke printf,[_strbuf],_fmt2,[_strbuf],[esi]

	cinvoke wsprintf,[_strbuf],_fmt2,[_strbuf],[esi]
	add	esi,4
	dec	ebx
	cmp	ebx,0
	jnz	@b
	invoke	MessageBox,0,[_strbuf],_msgcap,MB_ICONINFORMATION+MB_OK

	invoke	HeapFree,[_hheap],0,[_argv]
	invoke	HeapFree,[_hheap],0,[_strbuf]
	invoke	ExitProcess,0

_strbuf  dd ?
_fmt1	 db '%u',0
_fmt2	 db '%s, "%s"',0
_msgcap  db 'Command line parameters',0
_hheap	 dd ?

data import
 library kernel,'KERNEL32.DLL',\
	 user,'USER32.DLL',\
	 msvcrt, 'msvcrt.dll'


 import kernel,\
	 GetCommandLine,'GetCommandLineA',\
	 GetProcessHeap,'GetProcessHeap',\
	 HeapAlloc,'HeapAlloc',\
	 HeapFree,'HeapFree',\
	 ExitProcess,'ExitProcess'

 import user,\
	MessageBox,'MessageBoxA',\
	wsprintf,'wsprintfA'
 import msvcrt,\
	printf, 'printf',\
	_getch, '_getch'
end data
