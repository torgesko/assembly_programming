format PE64 NX GUI 6.0
entry start

use64
macro zer0 target {
      xor target, target
}

macro add4 target {
      add target, 4
}

macro add4rax {
      add rax, 4
}

macro add4all target*{ ; Marks it as required
      add target, 4
}

macro foo a, [b, c] {
        common ; we'll explain what "common" means later
                db a, b
                db a, c
        }

section '.text' code readable executable
start:
        add4all eax
        int3
        sub rsp, 32
        zer0 rcx
        int3
        call [ExitProcess]

section '.idata' import readable writeable
idt: ; import directory table starts here
     ; entry for KERNEL32.DLL
     dd rva kernel32_iat
     dd 0
     dd 0
     dd rva kernel32_name
     dd rva kernel32_iat
     ; NULL entry - end of IDT
     dd 5 dup(0)
name_table: ; hint/name table
        _ExitProcess_Name dw 0
                          db "ExitProcess", 0, 0

kernel32_name: db "KERNEL32.DLL", 0
kernel32_iat: ; import address table for KERNEL32.DLL
        ExitProcess dq rva _ExitProcess_Name
        dq 0 ; end of KERNEL32's IAT