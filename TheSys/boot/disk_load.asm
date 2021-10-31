disk_load: ; s diska DL ucitaj DH sektora na adresu ES:BX
  push ax
  push cx
  push dx ; broj sektora koji ce se pokusati ucitati
  mov ah, 0x02 ; BIOS read-sector funkcija
  mov al, dh   ; ucitavanje DH sektora
  mov ch, 0x00 ; odabir cilindra 0
  mov dh, 0x00 ; odabir glave 0
  mov cl, 0x02 ; odabir DRUGOG sektora, sektora 2

  int 0x13 ; BIOS prekid za ucitavanje

  jc disk_error ; ako je CF=1 dogodila se greska

  ; ako zatrazeni i stvarni broj ucitanih sektora nisu isti dogodila se greska
  pop dx        
  cmp dh, al
  jne disk_error

  pop cx
  pop ax
  ret

; u 'ah' je error kod, a u 'dl' disk na kojem se ona dogodila
disk_error:
  mov bx, DISK_ERROR_MSG
  call print_string
  jmp $

DISK_ERROR_MSG db "Disk read error!", 0xD, 0xA, 0
