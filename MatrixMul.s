.data 
	cerinta: .space 4
	n: .space 4
	v: .space 400
	elem: .space 4
	index: .space 4
	index2: .space 4
	x: .space 4
	lungime: .space 4
	nod1: .space 4
	nod2: .space 4
	cnt: .space 4
	m1: .space 40000
	m2: .space 40000
	mres: .space 40000
	formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld "
	formatP2: .asciz "\n"
.text

.global main

main:

citire_cerinta:
	pushl $cerinta
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

citire_n:	
	pushl $n
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

//initializare:	
	movl $v, %edi
	movl $0, index
	xorl %ecx, %ecx
	
citire_legaturi:
	movl index, %ecx
	cmp %ecx, n
	je citire_noduri
	pushl $elem
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	movl elem, %eax
	movl index, %ecx
	movl %eax, (%edi, %ecx, 4)
	addl $1, index
	jmp citire_legaturi
	
citire_noduri:
	movl $0, index
	xorl %ecx, %ecx
	
citire_loop:
	cmp %ecx, n
	je alege
	
	movl (%edi, %ecx, 4), %eax
	movl $0, %ebx
	cmp %eax, %ebx
	je incrementare_ecx
	
	pushl $x
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	movl index, %eax
	movl $0, %edx
	mull n
	addl x, %eax
	movl $m1, %ebx
	movl $1, (%ebx, %eax, 4)
	
	movl index, %ecx
	movl (%edi, %ecx, 4), %eax
	subl $1, %eax
	movl %eax, (%edi, %ecx, 4)
	
	jmp citire_loop
	
incrementare_ecx:
	addl $1, index
	movl index, %ecx
	jmp citire_loop

alege:
	movl cerinta, %eax
	movl $1, %ebx
	cmp %eax, %ebx
	je afisare_matrice
	movl $2, %ebx
	je task2
	
task2:
	pushl $lungime
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	pushl $nod1
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	pushl $nod2
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

constr_matrice:
	movl $0, index
	xorl %ecx, %ecx
	
for_linii:
	movl index, %ecx
	cmp %ecx, n
	je cont
		
	movl $0, index2
	for_coloane:
		movl index2, %ecx
		cmp %ecx, n
		je reinit
		movl index, %eax
		movl $0, %edx
		mull n
		addl index2, %eax
			
		movl $m1, %ebx
		movl (%ebx, %eax, 4), %edx
		
		movl $m2, %ebx
		movl %edx, (%ebx, %eax, 4)

		addl $1, index2
		jmp for_coloane
		
reinit:
	
	addl $1, index
	jmp for_linii

cont:
	movl $1, cnt
looop:
	movl cnt, %eax
	movl lungime, %ebx
	cmp %eax, %ebx
	je afisare
	
	pushl n
	pushl $mres
	pushl $m2
	pushl $m1
	call matrix_mult

	addl $16, %esp
	addl $1, cnt
	jmp copiere

copiere:
	movl $0, index
	xorl %ecx, %ecx
	
for_linii1:
	movl index, %ecx
	cmp %ecx, n
	je looop
		
	movl $0, index2
	for_coloane1:
		movl index2, %ecx
		cmp %ecx, n
		je reinit1
		movl index, %eax
		movl $0, %edx
		mull n
		addl index2, %eax
			
		movl $mres, %ebx
		movl (%ebx, %eax, 4), %edx
		
		movl $m2, %ebx
		movl %edx, (%ebx, %eax, 4)

		addl $1, index2
		jmp for_coloane1
		
reinit1:
	
	addl $1, index
	jmp for_linii1

matrix_mult:	
	push %ebp
	mov %esp, %ebp
	push %ebx
	push %esi
	push %edi
	
	subl $12, %esp
	
	movl $0, -16(%ebp)
	for_i:
		movl -16(%ebp), %eax
		cmp %eax, n
		je actual1
		movl $0, -20(%ebp)
		for_j:
			movl -20(%ebp), %ebx
			cmp %ebx, n
			je actual2
			movl $0, -24(%ebp)
			for_k:
				movl -16(%ebp), %eax
				movl -20(%ebp), %ebx
				movl -24(%ebp), %ecx
				cmp %ecx, n
				je actual3
				
				movl n, %ebx
				xorl %edx, %edx
				mull %ebx
				addl %ecx, %eax
				
				movl 8(%ebp), %ecx
				movl (%ecx, %eax, 4), %edi
				
				movl -24(%ebp), %eax
				movl n, %ebx
				xorl %edx, %edx
				mull %ebx
				movl -20(%ebp), %ecx
				addl %ecx, %eax
				
				movl 12(%ebp), %ecx
				movl (%ecx, %eax, 4), %ebx
				movl %ebx, %eax
				xorl %edx, %edx
				mull %edi
				movl %eax, %ebx
				movl -16(%ebp), %eax
				movl n, %ecx
				xorl %edx, %edx
				mull %ecx
				movl -20(%ebp), %ecx
				addl %ecx, %eax
				movl 16(%ebp), %edi
				addl %ebx, (%edi, %eax, 4)
				addl $1, -24(%ebp)
				
				jmp for_k
		
	actual3:
		addl $1, -20(%ebp)
		jmp for_j
		
	actual2:
		addl $1, -16(%ebp)
		jmp for_i
	
	actual1:
		add $12, %esp
		pop %edi
		pop %esi
		pop %ebx
		pop %ebp
		ret

afisare:
	movl nod1, %eax
	movl n, %ebx
	xorl %edx, %edx
	mull %ebx
	movl nod2, %ebx
	addl %ebx, %eax
	movl $mres, %edi
	movl (%edi, %eax, 4), %ebx
	
	pushl %ebx
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx
	
	jmp et_exit
	
afisare_matrice:
	movl $0, index
	xorl %ecx, %ecx
	
for_linii2:
	movl index, %ecx
	cmp %ecx, n
	je et_exit
		
	movl $0, index2
	for_coloane2:
		movl index2, %ecx
		cmp %ecx, n
		je reinit2
		movl index, %eax
		movl $0, %edx
		mull n
		addl index2, %eax
			
		movl $m1, %ebx
		movl (%ebx, %eax, 4), %edx
			
		pushl %edx
		pushl $formatPrintf
		call printf
		popl %ebx
		popl %ebx
		
		pushl $0
		call fflush
		popl %ebx
			
		addl $1, index2
		jmp for_coloane2
		
reinit2:
	movl $4, %eax
	movl $1, %ebx
	movl $formatP2, %ecx
	movl $2, %edx
	int $0x80
	
	addl $1, index
	jmp for_linii2	

et_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80