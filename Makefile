all: modify
modify: modify.o
	ld read-record.o write-record.o modify.o -m elf_i386 -o modify
modify.o: modify.s
	as modify.s -o modify.o --32
