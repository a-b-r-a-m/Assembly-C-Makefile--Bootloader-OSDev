gdt_start:

gdt_null: ; obavezni null-deskriptor
  dd 0x0  ; 2(2*16) = 64 bita[8 bajtova] - duzina svakog GDT deskriptora
  dd 0x0

gdt_code: ; kod-segment deskriptor
  ; baza=0x0, limit=0xfffff
  dw 0xffff ; limit (bitovi 0-15)
  dw 0x0    ; baza (bitovi 0-15)
  db 0x0    ; baza (bitovi 16-23)

  ;prisutan: 1 = prisutan u memoriji, koristi se za virtualnu memoriju
  ;prava: 00 = najveca prava
  ;tip: 1 = kod ili data segment
  ; 1st flags: 1(prisutan) 00(prava) 1(tip deskriptora)
  ;kod: 1 = kod segment
  ;conforming: 0 = zasticen, kod u segmentu s manjim pravima ne moze zvati
  ;                kod u ovom segmentu; zastita memorije
  ;readable: 1 = nije samo izvrsiv, dopusteno citanje konstanti iz koda
  ;accessed: 0 = CPU  ga postavlja kad pristupi segmentu, za debug i sl.
  ; type-flags: 1(kod) 0(conforming) 1(readable) 0(accessed)
  db 0b10011010 ; 1st flags(1001), type-flags(1010)  ; ili db 10011010b

  ;granularnost: 1 = limit se mnozi sa 4096(16*16*16),
  ;              odnosno pomice 3 hex znamenke ulijevo, max limit je 4GB
  ;32-bit zadano: 1 = zadana rijec postavlja se na 32-bit
  ;64-bit seg: 0 = ne koristi se na 32-bitnom procesoru
  ;AVL: 0 = nekoristeno (za osobnu upotrebu)
  ; 2nd flags: 1(granularnost) 1(32-bit zadano) 0(64-bit seg) 0(AVL)
  db 0b11001111 ; 2nd flags(1100), limit(bitovi 16-19)

  db 0x0 ; baza (bitovi 24-31)

gdt_data: ; data-segment deskriptor
  ; sve kao kod kod-segmenta, osim type-flagova
  dw 0xffff
  dw 0x0
  db 0x0
  ;expand down: 0 = seg. se moze prosiriti prema dolje
  ;writable: 1 = uz citanje, dopusteno i pisanje po data segmentu
  ; type-flags: 0(data) 0(expand down) 1(writable) 0(accessed)
  db 0b10010010
  db 0b11001111
  db 0x0

gdt_end: ; da asembler moze izracunati velicinu GDT-a za deskriptor (ispod)

gdt_descriptor:
  dw gdt_end - gdt_start - 1 ; velicina, uvijek 1 manje od prave
  dd gdt_start ; pocetna adresa GDT-a

; konstante za prakticnost, offsets - seg. reg. ih moraju sadrzavati u PM-u
; u ovom slucaju: NULL-0x0, KOD-0x08, DATA-0x10  (po 8 bajtova)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
