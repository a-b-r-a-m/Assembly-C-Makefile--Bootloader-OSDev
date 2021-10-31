#include "../drivers/screen.h"

void main() {
  // pokazivac na adresu prve tekstovne celije video-memorije
  //volatile char* video_memory = (volatile char*) 0xb8000;

  // 'X' se ispise u gornjem lijevom kutu ekrana
  // *video_memory = 'X';
  
  //*video_memory = 'A';        // ispise se
  //*(video_memory + 1) = 'B';  // mijenja boju prethodnom
  //*(video_memory + 2) = '3';  // ispise se
  //*(video_memory + 3) = '4';  // mijenja boju prethodnom
  
  //print_char('5', 5, 2, 0xf0);
  //print_char('\n', 5, 50, 0xf0);
  //print_char('F', -1, -1, 0xf0);
  //print_char('H', 24, 79, 0xf0);
  //print_char('L', -1, -1, 0xf0);  
  //print_char('\n', -1, -1, 0xf0);

  char* m = "Welcome to TheSys OS!\n";
  //print(m);
  print_at(m, 15, 0);

  m = "\nFeel free to build upon it . .. ... .... .....\n\n";
  print(m);
  //clear_screen();

  // test, ok
  //*((int*)0xb8000)=0x07690748;
}
