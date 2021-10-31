#include "screen.h"
#include "../kernel/low_level.h"
#include "../kernel/util.h"

int get_screen_offset(int row, int col) {
  return (2 * (row * MAX_COLS + col));
}



// the device uses its control register as an index to select its internal registers
// neki od njih su:
// reg. 14: high byte cursor offset-a
// reg. 15: low  byte cursor offset-a
// kad je interni reg. odabran  moze se procitati ili zapisati bajt u data reg.
int get_cursor() {
  // na port 0x3D4(u VGA kontrolni reg.) zapise se broj 14 (odabere se interni reg. 14)
  // kad se odabere int.reg. data reg.(port 0x3d5) se auto. updatea na njegovu vrij.
  // data reg. sluzi kao povratna vrijednost, slicno kao eax u asembleru
  port_byte_out(REG_SCREEN_CTRL, 14);

  // sa porta 0x3D5 procitaj bajt, i postavi ga kao visi bajt offseta
  int offset = (port_byte_in(REG_SCREEN_DATA) << 8);
  
  // na port 0x3D4(u kontrolni reg.) zapisi broj 15 (odaberi interni reg. 15)
  port_byte_out(REG_SCREEN_CTRL, 15);
  
  // sa porta 0x3D5 procitaj bajt, i postavi ga kao nizi bajt offseta
  offset += port_byte_in(REG_SCREEN_DATA);

  // offset koji VGA hardware javlja odnosi se na broj znakova
  // *2 zbog atributnog bajta koji ga prati
  return (2 * offset);
}



void set_cursor(int offset) { // [0] ili [par] je ASCII znak, [nepar] je At. za [nepar-1]
  // pretvorba iz offseta za celiju (znak, atribut) u offset za znak (VGA style)
  offset /= 2;

  // preko kontrolnog registra odabere se int. reg. 14
  // u kojem se nalazi visi bajt cursor offseta
  port_byte_out(REG_SCREEN_CTRL, 14);

  // posto je odabran int. reg. 14, mijenjajuci DATA-u mijenja se njegova vrijednost
  // azurira se vrijednost viseg bajta cursor offseta
  // offset je int = 16bit = 2B
  // unsigned char = 1B, kao i REG
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));

  // preko kontrolnog registra odabere se int. reg. 15
  // u kojem se nalazi nizi bajt cursor offseta
  port_byte_out(REG_SCREEN_CTRL, 15);

  // azurira se vrijednost nizeg bajta cursor offseta
  port_byte_out(REG_SCREEN_DATA, (unsigned char) offset);
}



// advance the text cursor, scrolling the video buffer if necessary
// zasad brise najstariju liniju (nultu)
int handle_scrolling(int cursor_offset) {
  
  // ako kursor nije "van ekrana" sve je u redu
  if(cursor_offset < (2 * MAX_COLS * MAX_ROWS))
		  return cursor_offset;

  // svaki red ide za jedan gore (-1)
  int i = 1;
  for(; i < MAX_ROWS; ++i)
	  memory_copy((char*)(VIDEO_ADDRESS + get_screen_offset(i, 0)),
		      (char*)(VIDEO_ADDRESS + get_screen_offset(i - 1, 0)),
		      2 * MAX_COLS);

  // praznjenje zadnje linije
  char* last_line = (char*)(VIDEO_ADDRESS + get_screen_offset(MAX_ROWS - 1, 0));

  for(i = 0; i < 2 * MAX_COLS; ++i) {
	  *(last_line + i++) = ' '; // ASCII znak
	  *(last_line + i) = WHITE_ON_BLACK;     // bijelo na crno, 0x0f, atribut
  }
  // da bude na prvoj celiji zadnjeg vidljivog retka
  cursor_offset -= (2 * MAX_COLS);

  return cursor_offset;
}



// print character on screen at (row,col) or at cursor position
void print_char(char character, int row, int col, char attribute_byte) {

  // byte(char) pokazivac na pocetak video-memorije (0xb8000)
  unsigned char* vidmem = (unsigned char*) VIDEO_ADDRESS;

  // default attribute
  if(!attribute_byte)
	  attribute_byte = WHITE_ON_BLACK;

  int offset;
  if(row >= 0 && col >= 0)
	  offset = get_screen_offset(row, col);
  else
	  offset = get_cursor();

  // u slucaju nove linije, postaviti offset na prvi(nulti) stupac iduceg reda
  if(character == '\n') {
	  // int rows = (offset - 2 * col) / (2 * MAX_COLS);
	  // (-2 * col) u brojniku suvisno, ne mijenja rezultat (2*col < 2*MAX_COLS)
	  
	  int rows = offset / (2 * MAX_COLS);
	  offset = get_screen_offset(++rows, 0);
  }
  else {
	  *(vidmem + offset++) = character;
	  *(vidmem + offset++) = attribute_byte;
	  
	  // offset ide na iduci znak-atribut par
	  // offset += 2;
  }

  // za slucaj da se doslo do dna ekrana
  offset = handle_scrolling(offset);

  set_cursor(offset);
}



// postavljanje kursora i skrolanje obavlja print_char funkcija

void print_at(char* message, int row, int col) {
  
  int i = 0;

  if(row >= 0 && col >= 0) {
	  set_cursor(get_screen_offset(row, col));
	  
	  while(*(message + i) != 0) {
		  print_char(*(message + i++), row, col, WHITE_ON_BLACK);
		  
		  if(++col == 80) {
			  col = 0;
			  ++row;
		  }
	  }
  } // ako se koristi trenutna pozicija kursora nema potrebe za rucnim iteriranjem
  else
	  while(*(message + i) != 0)
		  print_char(*(message + i++), row, col, WHITE_ON_BLACK);
}



// print na trenutnu poziciju kursora
void print(char* message) {
  print_at(message, -1, -1);
}



void clear_screen() {
  int row = 0;
  int col = 0;

  for(row = 0; row < MAX_ROWS; ++row)
          for(col = 0; col < MAX_COLS; ++col)
                  print_char(' ', row, col, WHITE_ON_BLACK);

  set_cursor(0); //nema potrebe zvati get_offset
}
