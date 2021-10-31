; da sigurno zapocnemo izvrsavati kod jezgre od njene pocetne f-je
[bits 32] ; dosad je CPU u u PM-u
[extern main] ; da linker zna da se odnosi na vanjsku oznaku i zamijeni adresom
call main ; poziva main() iz C-jezgre
jmp $ ; po povratku jmp 4ever
