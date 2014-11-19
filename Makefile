NASM=nasm
QEMU=qemu-system-i386 -boot a -curses


all: run

clean:
	rm -f *.bin *.img

floppy.img:
	nasm -g -f bin -o fiboot.bin fiboot.asm
	dd if=/dev/zero of=floppy.img bs=512 count=1 &> /dev/null
	dd if=fiboot.bin of=floppy.img conv=notrunc

run: floppy.img
	$(QEMU) -fda floppy.img

debug: floppy.img
	$(QEMU) -s -S -fda floppy.img
