nasm
section .data
    file_err db "Error opening file", 10
    file_err_len equ $ - file_err
    read_err db "Error reading file", 10
    read_err_len equ $ - read_err

section .bss
    file_name resb 255
    buffer resb 1

section .text
    global _start

_start:
    ; Get the file name from command line argument
    pop eax                 ; Pop the number of arguments
    cmp eax, 2              ; Check if there is one argument
    jne exit                ; Exit if not

    pop ebx                 ; Pop the program name
    pop ebx                 ; Pop the file name
    mov [file_name], ebx    ; Store the file name

    ; Open the file
    mov eax, 5              ; System call number for open
    mov ebx, [file_name]    ; File name
    mov ecx, 0              ; Open for reading
    int 0x80                ; Call the kernel

    ; Check if open was successful
    cmp eax, 0              ; Check if eax is 0 (success)
    jl open_error           ; Jump to error if open failed

    mov ebx, eax            ; Store the file descriptor

read_loop:
    ; Read one byte from the file
    mov eax, 3              ; System call number for read
    mov ecx, buffer         ; Buffer to read into
    mov edx, 1              ; Read one byte
    int 0x80                ; Call the kernel

    ; Check if read was successful
    cmp eax, 0              ; Check if eax is 0 (end of file)
    jle exit                ; Exit if end of file

    ; Check if read was successful
    cmp eax, 1              ; Check if one byte was read
    jne read_error          ; Jump to error if read failed

    ; Write the byte to stdout
    mov eax, 4              ; System call number for write
    mov ebx, 1              ; File descriptor for stdout
    mov ecx, buffer         ; Buffer to write
    mov edx, 1              ; Write one byte
    int 0x80                ; Call the kernel

    jmp read_loop           ; Read the next byte

open_error:
    mov eax, 4              ; System call number for write
    mov ebx, 1              ; File descriptor for stdout
    mov ecx, file_err       ; Error message
    mov edx, file_err_len   ; Length of error message
    int 0x80                ; Call the kernel
    jmp exit                ; Exit

read_error:
    mov eax, 4              ; System call number for write
    mov ebx, 1              ; File descriptor for stdout
    mov ecx, read_err       ; Error message
    mov edx, read_err_len   ; Length of error message
    int 0x80                ; Call the kernel

exit:
    mov eax, 1              ; System call number for exit
    xor ebx, ebx            ; Exit status 0
    int 0x80                ; Call the kernel
