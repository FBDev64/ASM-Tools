nasm
section .data
    msg db 'Hello, World!', 0x0a

section .text
    global _start

_start:
    mov eax, 4          ; sys_write system call
    mov ebx, 1          ; stdout file descriptor
    mov ecx, msg        ; pointer to message
    mov edx, 14         ; length of message
    int 0x80            ; make system call

    mov eax, 1          ; sys_exit system call
    xor ebx, ebx        ; exit status 0
    int 0x80            ; make system call
