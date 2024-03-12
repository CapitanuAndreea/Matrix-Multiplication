.data 
	cerinta: .space 4
	n: .space 4
	v: .space 400
	elem: .space 4
	index: .space 4
	index2: .space 4
	lungime: .space 4
	nod1: .space 4
	nod2: .space 4
	cnt: .space 4
	mres: .space 4
	m1: .space 40000
	m2: .space 40000
	formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld "
	formatPrintf1: .asciz "%ld"
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
	je task3
	
	movl (%edi, %ecx, 4), %eax
	movl $0, %ebx
	cmp %eax, %ebx
	je incrementare_ecx
	
	pushl $elem
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	movl index, %eax
	movl $0, %edx
	mull n
	addl elem, %eax
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
	
task3:
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

//copiem in m2 elementele din m1, pentru a realiza inmultirea
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
	
apel_mmap2:
	//Punem in registrul %ecx dimensiunea matricei, adica n x n x tipul de data (aici 4 bytes - tipul long)	
	movl n, %eax
	movl n, %ebx
	xorl %edx, %edx
	mull %ebx
	movl $4, %ebx
	xorl %edx, %edx
	mull %ebx
	movl %eax, %ecx
	
	//192 este codul syscall-ului mmap2, gasit in documentatie si este pus in registrul %eax
	movl $192, %eax
	
	//In registrul %ebx am adaugat valoarea 0 pentru a lasa kernel-ul sa aleaga adresa la care mapeaza
	//In caz contrar, orice alta valoare am fi pus in %ebx, ar fi insemnat ca dorim sa alocam memorie la acea adresa
	movl $0, %ebx
	
	//In registrul %edx retinem tipurile de protectie pe care vrem sa le aiba memoria mapata
	//In acest caz, ne dorim PROT_READ si PROT_WRITE, pentru a putea realiza citirea si afisarea
	//Astfel, pentru a afla valorile celor doua constante, ne folosim de un proiect C in care adaugam header-ul <sys/mman.h> si afisam cele doua tipuri de protectie alese
	//Aflam ca PROT_READ este 1, iar PROD_WRITE 2 si pentru a le folosi pe amandoua, setam in %edx suma lor, 1 + 2 = 3
	movl $3, %edx
	
	//Registrul %esi retine flagurile, proprietatile pe care vrem sa le aiba memoria
	//Alegem MAP_PRIVATE, ce inseamna ca alte procese ce ruleaza nu pot accesa zona noastra de memorie 
	//si MAP_ANONYMOUS, adica nu depinde alte fisiere
	//la fel, aflam unde se afla flagurile
	//Pentru MAP_PRIVATE s-a afisat 2, in timp ce pentru MAP_ANONYMOUS 32, in total 34, valoare pusa in %esi
	movl $34, %esi
	
	//%edi este registru pentru fd (file descriptor) handler catre un fisier
	//Intrucat nu mapam virtual address to file, punem valoarea -1
	movl $-1, %edi
	
	//%ebp retine parametrul offset
	//Acesta indica byte-ul de la care se citeste din fisier
	//Din acelasi motiv ca la fd (ca nu folosim fisiere), punem 0 si in acest registru
	movl $0, %ebp
	
	int $0x80
	
movl %eax, mres
	
loop:
	movl cnt, %eax
	movl lungime, %ebx
	cmp %eax, %ebx
	je afisare
	
	pushl n
	pushl mres
	pushl $m2
	pushl $m1
	call matrix_mult

	addl $16, %esp
	addl $1, cnt
	jmp copiere


copiere:   //elementele lui m2 in mres
	movl $0, index
	xorl %ecx, %ecx
	
for_linii1:
	movl index, %ecx
	cmp %ecx, n
	je loop
		
	movl $0, index2
	for_coloane1:
		movl index2, %ecx
		cmp %ecx, n
		je reinit1
		movl index, %eax
		movl $0, %edx
		mull n
		addl index2, %eax
			
		movl mres, %ebx
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
	movl cnt, %eax
	movl $1, %ebx
	cmp %eax, %ebx
	je afisare1

	movl nod1, %eax
	movl n, %ebx
	xorl %edx, %edx
	mull %ebx
	movl nod2, %ebx
	addl %ebx, %eax
	movl mres, %edi
	movl (%edi, %eax, 4), %ebx
	
	pushl %ebx
	pushl $formatPrintf1
	call printf
	popl %ebx
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx
	
	jmp apel_munmap	
	
//daca se cer drumurile de lungime 1	
afisare1:
	movl nod1, %eax
	movl n, %ebx
	xorl %edx, %edx
	mull %ebx
	movl nod2, %ebx
	addl %ebx, %eax
	movl $m1, %edi
	movl (%edi, %eax, 4), %ebx
	
	pushl %ebx
	pushl $formatPrintf1
	call printf
	popl %ebx
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx
	
	jmp apel_munmap
		
apel_munmap:
	//pune dimensiunea matricii in ecx	
	movl n, %eax
	movl n, %ebx
	xorl %edx, %edx
	mull %ebx
	movl $4, %ebx
	xorl %edx, %edx
	mull %ebx
	movl %eax, %ecx
	
	movl $91, %eax
	movl mres, %ebx
	
	int $0x80
	
	jmp et_exit
		
et_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80