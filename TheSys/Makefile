# Use TABS, not spaces!
# auto. generate list of sources using wildcards
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# sources dep. on all header files, za jednostavnost

# list of obj. files TO build
OBJ = ${C_SOURCES:.c=.o}

# default make target
all: os-image

# ili bochs
# qemu-system-x86_64 os-image
# qemu-system-i386 -fda(floppy) ili -hda(harddisk)
run: all
	qemu-system-i386 -drive format=raw,file=os-image,index=0,if=floppy

# disk image that the computer loads
os-image: boot/boot_sect.bin kernel.bin
	cat $^ > $@

# $^ - all target's dependency files
# entry - skace na main() jezgre
# kernel - kompajlirana C-jezgra
kernel.bin: kernel/kernel_entry.o ${OBJ}
	i686-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

# $< - 1st dependency,   $@ - target file
# generic rule for compiling C code to an object file
# for simplicity, C files depend on all header files
# -Wall - all Warnings
%.o: %.c ${HEADERS}
	i686-elf-gcc -Wall -ffreestanding -c $< -o $@

# assemble the kernel entry
%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

# obrise sve izgenerirane datoteke
clean:
	rm -fr *.bin *.dis *.o os-image *.map
	rm -fr kernel/*.o boot/*.bin drivers/*.o

# disasemblanje jezgre; moze biti korisno za debug
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@
