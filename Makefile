all: modify write-records
modify: modify.o
	ld read-record.o write-record.o modify.o -m elf_i386 -o modify
modify.o: modify.s
	as modify.s -o modify.o --32
write-records: write-records.o
	ld write-records.o write-record.o -m elf_i386 -o write-records
write-records.o:
	as write-records.s -o write-records.o --32
