// C wrapper funkcija za citanje bajta sa odabranog porta
// "d" (port) -> ucitaj PORT u EDX (port mora ici u edx)
// in al, dx -> ucitaj sadrzaj porta DX (1 bajt) u AL
// "=a" (result) -> na kraju stavi vrijednost AL reg.-a u var. RESULT
//                  // short-16bit, char-8bit
unsigned char port_byte_in(unsigned short port) {
  unsigned char result;
  __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));

  return result;
}

// "a" (data) -> ucitaj data-u u EAX
// "d" (port) -> ucitaj port u EDX
// out dx, al -> na port DX postavi vrijednost AL
void port_byte_out(unsigned short port, unsigned char data) {
  __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

// vidi unsigned char port_byte_in(unsigned short port);
unsigned short port_word_in(unsigned short port) {
  unsigned short result;
  __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));

  return result;
}

//vidi void port_byte_out(unsigned short port, unsigned char data);
void port_word_out(unsigned short port, unsigned short data) {
  __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
