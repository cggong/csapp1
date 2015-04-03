	.include "linux.s"
	.include "record-def.s"
	.section .data
	#COMPILE: ld write-record.o write-records.o -o write-records -m elf_i386
	#ld read-record.o write-record.o modify.o -m elf_i386 -o modify
file_in:
	.ascii "mod_in\0"
	.equ STFD_IN, -4
file_out:
	.ascii "mod_out\0"
	.equ STFD_OUT, -8
	.section .bss
	.lcomm record_buffer, RECORD_SIZE

	.section .text
	.globl _start
_start:
	#Copy stack ptr and make room for local vars
	movl %esp, %ebp
	subl $8, %esp
	#Open file for reading
	movl $SYS_OPEN, %eax
	movl $file_in, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, STFD_IN(%ebp)
	#Open file for writing
	movl $SYS_OPEN, %eax
	movl $file_out, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, STFD_OUT(%ebp)
loop_begin:
	pushl STFD_IN(%ebp)
	pushl $record_buffer
	 #DAMN GOT THESE POSITION SWITCHED!
	call read_record
	addl $8, %esp
	cmpl $RECORD_SIZE, %eax
	jne loop_end

	#increment the age
	movl $record_buffer, %eax
	addl $RECORD_AGE, %eax
	movl (%eax), %ebx
	incl %ebx
	movl %ebx, (%eax)

	#Write the record out
	pushl STFD_OUT(%ebp)
	pushl $record_buffer
	call write_record
	addl $8, %esp
loop_end:
	movl $SYS_CLOSE, %eax
	movl STFD_IN(%ebp), %ebx #NO DOLLAR SIGN FOR DISP!
	int $LINUX_SYSCALL
	movl $SYS_CLOSE, %eax
	movl STFD_OUT(%ebp), %ebx
	int $LINUX_SYSCALL
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
	
