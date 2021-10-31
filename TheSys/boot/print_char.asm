print_char: ; arg=al

  push ax
  mov ah, 0x0e ; BIOS t-t-r
  cmp al, 0
  jne char
    mov al, '0'
  char:
  int 0x10

  pop ax
  ret
