[bits 16]

switch_to_pm:

  cli ; clear interrupts; moraju se ugasiti dok se ne podesi IVT za PM

  lgdt [gdt_descriptor] ; ucitava se GDT koja definira PM segmente (kod i data)

  ; prvi bit cr0 kontrolnog registra postavlja se na 1, ne mijenjajuci ostale
  ; ne moze se mijenjati direktno nego se mora koristiti GPR
  mov eax, cr0
  or eax, 0x1
  mov cr0, eax

  ; far jump (na novi segment) na 32-bitni kod
  ; prisiljava CPU da dovrsi instrukcije zapocete u 16-bitnom modu
  jmp CODE_SEG:init_pm


[bits 32]
; inicijalizacija registara i stacka za PM nacin rada
init_pm:
  mov ax, DATA_SEG ; zasto ne eax?, doduse svej.?todo
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax ; fs i gs su extra, idalje si&di tu, ali netriba init?todo
  mov gs, ax

  mov ebp, 0x90000 ; na vrhu slobodnog prostora todo kakojeovovrh? ; (1152*512)
  mov esp, ebp

  call BEGIN_PM
