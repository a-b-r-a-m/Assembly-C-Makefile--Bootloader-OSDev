[bits 32]
; konstante
VIDEO_MEMORY equ 0xb8000 ; pocetak tekstualne video-memorije
WHITE_ON_BLACK equ 0x0f ; atributi za ispis

print_string_pm: ; null-terminated, na adresi EBX
  push eax;
  push ebx;
  push edx;
  mov edx, VIDEO_MEMORY ; EDX se postavlja na pocetak video-memorije
  mov ah, WHITE_ON_BLACK ; atributi u AH

print_string_pm_loop:
  mov al, [ebx] ; ASCII znak za ispis, na adresi EBX

  cmp al, 0 ; ako se doslo do kraja stringa izlazi se iz funkcije
  je print_string_pm_done

  mov [edx], ax ; u video-memoriju se zapisuje ASCII vrijednost znaka uz pripadajuce vizualne atribute

  add ebx, 1 ; ide se na iduci znak stringa
  add edx, 2 ; ide se na iduci znak-atribut par video-memorije

 jmp print_string_pm_loop

print_string_pm_done:
  pop edx;
  pop ebx;
  pop eax;
  ret
