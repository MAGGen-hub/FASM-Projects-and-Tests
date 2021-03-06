; �ਬ�� Win32 ���᮫쭮� �ணࠬ�� ��� FASM, ����� ����砥� � ��ப� �맮��
; ��� ⥪�⮢��� 䠩�� � �뢮��� ��� ᮤ�ন��� � ࠧ��� �� ���᮫�.
; ������� IQFun.ru, �. www.iqfun.ru/articles/fasm-primer-console-output.shtml
; ��������� ��� 䠩� � ����஢�� DOS (OEM, code page 866).

format PE CONSOLE
include 'win32ax.inc'

SEEK_SET equ 0	; �⭮�⥫쭮 ��砫� 䠩��, ��砫� 䠩�� - ������ 0
SEEK_CUR equ 1	; �⭮�⥫쭮 ⥪�饩 ����樨, > 0 - ���।, < 0 - �����
SEEK_END equ 2	; �⭮�⥫쭮 ���� 䠩�� (���祭�� pos - ����⥫쭮�)
NULL	 equ 0
EOF	 equ -1

section '.data' data readable writeable

argc	dd ?
argv	dd ?
env	dd ?
fp	dd ?
flength dd ?
fbuf	dd ?
msg	db  '%s %s%s',0
errmsg	db "�訡��! �㦭� ������ ��� ⥪�⮢��� 䠩�� ��� �뢮��.",0

section '.code' code readable executable

entry start

start:
; invoke  FreeConsole
; invoke  AllocConsole
; cinvoke printf,'%s%s',,<13,10,0>
; invoke SetConsoleOutputCP,1251
; invoke SetConsoleCP,1251

 cinvoke printf,'%s',<'�ਢ��',13,10,0>

 ; ����砥� ����� ���� � �ணࠬ�� � ������� �� ��ࠬ��� �������筮 �ணࠬ�� �� C
 cinvoke __getmainargs,argc,argv,env,0
 cmp [argc],2
 jne .err
 mov esi,[argv]

; invoke CharToOemA,dword [esi],dword [esi]
; invoke CharToOemA,dword [esi+4],dword [esi+4]

 ; �뢮��� ��� �ணࠬ�� � ���� � ��ࠬ���
 cinvoke printf,msg,dword [esi],dword [esi+4],<13,10,0>

 ; ���뢠�� ������� ⥪�⮢� 䠩� � ०��� "⮫쪮 �⥭��" � "������"
 cinvoke fopen,dword [esi+4],'rb'
 test eax,eax
 jz .err
 mov [fp],eax

 ; ��⠭�������� 㪠��⥫� �⥭��-����� � ����� 䠩��
 cinvoke fseek,[fp],0,SEEK_END
 .if eax <> 0
  jmp .err
 .endif

 ; ����� ���祭�� �⮣� 㪠��⥫�, ����� ࠢ�� ࠧ���� 䠩��
 cinvoke ftell,[fp]
 test eax,eax
 jz .err
 mov [flength],eax

 ; ����訢��� ���������� ������ ࠧ��஬ ����� 䠩�� + 1 ����
 inc eax
 cinvoke malloc,eax
 test eax,eax
 jz .err
 mov [fbuf],eax

 ; �����頥� 㪠��⥫� �⥭��-����� � ��砫� 䠩��
 cinvoke fseek,[fp],0,SEEK_SET
 test eax,eax
 jnz .err

 ; ��⠥� ���� 䠩� � ���������� ������
 cinvoke fread,[fbuf],1,[flength],[fp]
 cmp eax,[flength]
 jne .err

 ; �����뢠�� 0 �� ���殬 ������ ��� ������祭�� ���� ��ப�
 mov eax,[fbuf]
 add eax,[flength]
 mov byte [eax],0

 ; �뢮��� 䠩� �� ���᮫�
 cinvoke puts,[fbuf]
 cinvoke printf,'����� 䠩�� = %u%s',[flength],<13,10,0>

 ; ����뢠�� 䠩�
 cinvoke fclose,[fp]
 test eax,eax
 jnz .err

 ; �᢮������� ���������� ������
 cinvoke free,[fbuf]

.finish:
 cinvoke puts,'Press any key...'
 cinvoke _getch
 invoke ExitProcess,0

.err:
 cinvoke puts,errmsg
 jmp .finish

section '.idata' import data readable writeable

library kernel,'kernel32.dll',\
msvcrt,'msvcrt.dll',\
user32,'user32.dll'

import kernel,\
ExitProcess,'ExitProcess',\
GetCommandLineA,'GetCommandLineA',\
AllocConsole,'AllocConsole',\
FreeConsole,'FreeConsole',\
SetConsoleOutputCP,'SetConsoleOutputCP',\
SetConsoleCP,'SetConsoleCP'

import msvcrt,\
__getmainargs,'__getmainargs',\
fopen,'fopen',\
fseek,'fseek',\
ftell,'ftell',\
malloc,'malloc',\
free,'free',\
fread,'fread',\
fclose,'fclose',\
printf,'printf',\
_getch,'_getch',\
puts,'puts'

import user32,\
CharToOemA,'CharToOemA'