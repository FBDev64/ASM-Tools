nasm
; Extract utility in Assembly

section .data
    input_file_name db 'archive.zip', 0
    output_dir db 'extracted/', 0

section .bss
    input_file_handle resd 1
    output_file_handle resd 1
    buffer resb 4096

section .text
    global _start

_start:
    ; Open the input file
    mov eax, 5          ; sys_open
    mov ebx, input_file_name
    mov ecx, 0          ; read-only
    int 0x80

    mov [input_file_handle], eax

    ; Create the output directory
    mov eax, 39         ; sys_mkdir
    mov ebx, output_dir
    mov ecx, 0755o      ; permissions
    int 0x80

    ; Loop to extract files
extract_loop:
    ; Read from the input file
    mov eax, 3          ; sys_read
    mov ebx, [input_file_handle]
    mov ecx, buffer
    mov edx, 4096
    int 0x80

    ; Check if we reached the end of the file
    cmp eax, 0
    je end_extract

    ; Create an output file
    mov eax, 8          ; sys_creat
    mov ebx, output_dir
    mov ecx, 0644o      ; permissions
    int 0x80

    mov [output_file_handle], eax

    ; Write to the output file
    mov eax, 4          ; sys_write
    mov ebx, [output_file_handle]
    mov ecx, buffer
    mov edx, eax        ; bytes read
    int 0x80

    ; Close the output file
    mov eax, 6          ; sys_close
    mov ebx, [output_file_handle]
    int 0x80

    jmp extract_loop

end_extract:
    ; Close the input file
    mov eax, 6          ; sys_close
    mov ebx, [input_file_handle]
    int 0x80

    ; Exit
    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80
