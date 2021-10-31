// pocetak video memorije, VGA text mode
#define VIDEO_ADDRESS 0xb8000

#define MAX_ROWS 25
#define MAX_COLS 80

//atrubutni bajt za zadanu colour scheme
#define WHITE_ON_BLACK 0x0f

//screen device I/O ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

int get_screen_offset(int row, int col);
int get_cursor();
void set_cursor(int offset);
int handle_scrolling(int cursor_offset);
void print_char(char character, int row, int col, char attribute_byte);
void print_at(char* message, int row, int col);
void print(char* message);
void clear_screen();
