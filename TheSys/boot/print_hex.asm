print_hex: ; arg.=dx npr. dx=0x1234
  ; calle-save sve
  push bx
  push cx
  push dx
  push di

  mov cx, 5
  mov di, HEX_OUT ; HEX_OUT jednom definiran nepromjenjiv
  add di, 5

  loop:
    mov bx, dx ; u dx-u se nalazi broj
    and bx, 0x000F

    ; provjeri je li 0-9 ili A-E
    cmp bl, 9
    jg hex_dig  
  
    add bl, 48
    jmp dec_dig
  
    hex_dig:
      add bl, 87
    dec_dig:

    mov [di], bl
    sub di, 1
    shr dx, 4
    sub cx, 1
    cmp cx, 1
    jne loop

  mov bx, HEX_OUT ; ,di
  call print_string

  mov bx, CRLF
  call print_string

  ; restore stack
  pop di
  pop dx
  pop cx
  pop bx

  ret

HEX_OUT: db '0x0000', 0
CRLF: db 0xD, 0xA, 0
