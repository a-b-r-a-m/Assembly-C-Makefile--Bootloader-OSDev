; Boot sektor koji CPU stavlja u 32-bitni Protected Mode i prepusta kontrolu jezgri

[org 0x7c00] ; BIOS boot sektor ucitava na ovo mjesto u memoriji

KERNEL_OFFSET equ 0x1000 ; mjesto gdje ce se kasnije ucitati jezgra; konstanta

  mov [BOOT_DRIVE], dl ; BIOS pohranjuje boot drive u dl, dobro ga je zapamtiti

  mov bp, 0x9000 ; postavljanje stacka, 0x7c00 + 10*512
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string

  call load_kernel ; ucitava jezgru s diska

  call switch_to_pm  ; onemogucava prekida, ucitava GDT, .. , skace na BEGIN_PM labelu
                     ; nema povratka
  jmp $


%include "boot/print_string.asm"
%include "boot/disk_load.asm"
%include "boot/gdt.asm"
%include "boot/switch_to_pm.asm"
%include "boot/print_string_pm.asm"

[bits 16] ; 16-bitne instrukcije

load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string

; ucitaj prvih dh(15) sektora(osim Boot Sectora)
; na es:bx(0x0000:0x1000) sa dl-a(0)(boot disk, kernel kod)
  mov bx, KERNEL_OFFSET
  mov dh, 15
  mov dl, [BOOT_DRIVE]
  call disk_load

  ret


[bits 32] ; 32-bitne instrukcije
; nakon inicijalizacije PM-a, i promjene na njega, kod se nastavlja ovdje
BEGIN_PM:
  mov ebx, MSG_PROT_MODE ; 32-bitni reg.
  call print_string_pm   ;        a print funkcija

  call KERNEL_OFFSET ; nakon svega, skok na mjesto gdje je ucitana jezgra
  jmp $ ; beskon. petlja, da CPU ne nastavi sve na sto naide izvrsavati kao kod


; globalne varijable
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode...", 0xD, 0xA, 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode...", 0
MSG_LOAD_KERNEL db "Loading kernel into memory...", 0xD, 0xA, 0

times 510-($-$$) db 0 ; ubacuju se nule kako bi carobni broj bio na pravom mjestu
dw 0xaa55 ; magicni broj
