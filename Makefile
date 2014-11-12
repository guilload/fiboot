NASM=nasm
QEMU=qemu-system-i386 -curses


all:
	nasm -f bin -o fiboot.bin fiboot.asm
	dd if=/dev/zero of=floppy.img bs=512 count=1 &> /dev/null
	dd if=fiboot.bin of=floppy.img conv=notrunc
	$(QEMU) -fda floppy.img
