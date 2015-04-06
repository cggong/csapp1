	.include "linux.s"
	.include "record-def.s"
	.section .data
record1:
	.ascii "Achilleus\0"
	.rept 30
	.byte 0
	.endr
	.ascii "Peleus\0"
	.rept 33
	.byte 0
	.endr
	.ascii "Ithaca, Ancient Greece\0"
	.rept 217
	.byte 0
	.endr
	.long 45
record2:
	.ascii "Odysseus\0"
	.rept 31
	.byte 0
	.endr
	.ascii "Laertes\0"
	.rept 32
	.byte 0
	.endr
	.ascii "Royal Palace, Ithaca, Ancient Greece\0"
	.rept 203
	.byte 0
	.endr
	.long 45
	.text
file_name:
	.ascii "writetest\0"
	.equ ST_FILE_DESCRIPTOR, -4
	.globl _start
_start:
	movl %esp, %ebp
	subl $4, %esp
	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_FILE_DESCRIPTOR(%ebp)
	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record1
	call write_record
	addl $4, %esp
	pushl $record2
	call write_record
	addl $8, %esp
close_the_file:
	movl $SYS_CLOSE, %eax
	movl ST_FILE_DESCRIPTOR(%ebp), %ebx
	int $LINUX_SYSCALL
exit_program:
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

	
