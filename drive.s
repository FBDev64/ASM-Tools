nasm
section .data
    usb_path db "/sys/bus/usb/devices", 0
    usb_dir dd 0
    buffer times 1024 db 0

section .text
    global _start

_start:
    ; Open the USB directory
    mov eax, 5          ; sys_open
    mov ebx, usb_path
    mov ecx, 0          ; O_RDONLY
    int 0x80
    mov [usb_dir], eax

    ; Read directory entries
    mov eax, 19         ; sys_readdir
    mov ebx, [usb_dir]
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    ; Print directory entries
    mov esi, buffer
print_loop:
    lodsb               ; Load next byte into al
    or al, al           ; Check if end of string
    jz exit             ; Exit if end of string
    mov [ebx], al       ; Print the character
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, ebx        ; Address of character
    mov edx, 1          ; Length
    int 0x80
    jmp print_loop

exit:
    ; Close the directory
    mov eax, 6          ; sys_close
    mov ebx, [usb_dir]
    int 0x80

    ; Exit program
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; Exit status 0
    int 0x80
