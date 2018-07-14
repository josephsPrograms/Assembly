//.global main
.global crcInit
.global crcFast
.global crcTable

.text
	crcInit:	
		movq $0xD5,%rcx /* POLYNOMIAL */
		movq $0,%r8
		movq $0,%rbx /* remainder */
		movq $0,%r12 /* dividend */
		movq $0,%r14
		movq $0,%r15

		loop1:
			movq $8,%r13 /* bit */
			movq %r12, %rbx
		loop2:
			movq %rbx,%r14		
			andq $0x80,%r14
			cmp $0,%r14
			jz else	
			if:
				movq %rbx,%r8
				salq $1,%r8
				xorq %rcx,%r8
				movq %r8,%rbx
				jmp move
			else:
				movq %rbx,%r8
				salq $1,%r8
				movq %r8,%rbx
		move:
			decq %r13
			cmp $0,%r13
			jg loop2		
		movq %rbx,crcTable(%r12)
		inc %r12
		cmp $256, %r12
		jl loop1
		movq $0,%rax
		ret
		
	crcFast:		
		movq $0,%rbx /* unsigned char data */
		movq $0,%r12 /* remainder */
		movq $0,%r13 /* byte */
		movq $0,%r14
		movq $0,%r15
		//%rdi = char * message
		//%rsi = long nBytes
		loop3:
			movb (%rdi, %r13, 1),%r14b
			xorq %r12,%r14
			movq %r14,%rbx
			movb crcTable(%rbx),%r12b
		inc %r13
		cmp %rsi,%r13
		jl loop3
		movq %r12,%rax	
		ret
		
.data	
	crcTable:
		.rept 256
		.byte 0
		.endr	
