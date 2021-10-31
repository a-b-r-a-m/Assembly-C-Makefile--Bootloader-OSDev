; funkcija za ispis stringa pomocu BIOS-a u Real Mode-u

print_string:

  push ax ; pohrana stanja registara koje ce funkcija mijenjati na stack
  push bx
  mov ah, 0x0e  ; (int 0x10, ah=0x0e) --> scrolling teletype BIOS routine 

  while_char:
    cmp byte [bx], 0 ; nula oznacava kraj stringa
    je return

    mov al, byte [bx] ; ukoliko znak nije nula, ispisuje se na ekran
    int 0x10
    add bx, 1 ; iteracija na iduci znak
    jmp while_char

  return:
    pop bx ; povratak koristenih registara u prvobitno stanje
    pop ax
    ret ; izlazak iz funkcije
