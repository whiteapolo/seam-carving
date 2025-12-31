	.file	"main.c"
	.text
	.p2align 4
	.globl	memdup
	.type	memdup, @function
memdup:
.LFB5571:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	malloc@PLT
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE5571:
	.size	memdup, .-memdup
	.p2align 4
	.globl	calculate_gradient
	.type	calculate_gradient, @function
calculate_gradient:
.LFB5576:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	100(%rdi), %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	testl	%r12d, %r12d
	jle	.L4
	movl	96(%rdi), %r8d
	movl	$1, %r15d
	xorl	%r10d, %r10d
	movq	$-1, -16(%rsp)
	testl	%r8d, %r8d
	jle	.L4
	.p2align 4,,10
	.p2align 3
.L22:
	movq	-16(%rsp), %rax
	movq	56(%rdi), %rdx
	movl	$1, %esi
	movq	$-1, %rcx
	movl	%eax, %ebx
	imulq	%r10, %rdx
	notl	%eax
	shrl	$31, %eax
	movl	%eax, %r14d
	movq	48(%rdi), %rax
	leaq	(%rax,%rdx,4), %r11
	jmp	.L20
	.p2align 4,,10
	.p2align 3
.L26:
	xorl	%edx, %edx
	xorl	%eax, %eax
.L7:
	cmpl	%r10d, %r12d
	jg	.L36
.L11:
	cmpl	%r15d, %r12d
	jg	.L37
.L15:
	imull	%eax, %eax
	imull	%edx, %edx
	addl	%edx, %eax
	movl	%eax, 4(%r11,%rcx,4)
	movl	96(%rdi), %r8d
	movl	100(%rdi), %r12d
	cmpl	%esi, %r8d
	jle	.L19
	addq	$1, %rsi
	movq	%r9, %rcx
.L20:
	leaq	1(%rcx), %r9
	cmpl	%r12d, %ebx
	jge	.L26
	testb	%r14b, %r14b
	je	.L26
	movq	-16(%rsp), %r13
	movq	(%rdi), %rbp
	imulq	8(%rdi), %r13
	testl	%ecx, %ecx
	js	.L27
	cmpl	%ecx, %r8d
	jle	.L27
	leaq	0(%rbp,%r13), %rdx
	movzbl	(%rdx,%rcx), %eax
	negl	%eax
.L10:
	movzbl	(%rdx,%r9), %edx
	negl	%edx
	leal	(%rax,%rdx,2), %edx
	cmpl	%esi, %r8d
	jle	.L7
	addq	%rsi, %rbp
	movzbl	0(%rbp,%r13), %ebp
	addl	%ebp, %eax
	subl	%ebp, %edx
	cmpl	%r10d, %r12d
	jle	.L11
	.p2align 4,,10
	.p2align 3
.L36:
	testl	%ecx, %ecx
	js	.L14
	cmpl	%ecx, %r8d
	jle	.L14
	movq	8(%rdi), %rbp
	movq	(%rdi), %r13
	imulq	%r10, %rbp
	addq	%rcx, %r13
	movzbl	0(%r13,%rbp), %ebp
	negl	%ebp
	leal	(%rax,%rbp,2), %eax
.L14:
	cmpl	%esi, %r8d
	jle	.L11
	movq	8(%rdi), %rbp
	movq	(%rdi), %r13
	imulq	%r10, %rbp
	addq	%rsi, %r13
	movzbl	0(%r13,%rbp), %ebp
	leal	(%rax,%rbp,2), %eax
	cmpl	%r15d, %r12d
	jle	.L15
	.p2align 4,,10
	.p2align 3
.L37:
	movq	8(%rdi), %r13
	movq	(%rdi), %rbp
	imulq	%r15, %r13
	movq	%rbp, -8(%rsp)
	leaq	0(%rbp,%r13), %r12
	testl	%ecx, %ecx
	js	.L18
	cmpl	%ecx, %r8d
	jle	.L18
	movzbl	(%r12,%rcx), %ebp
	subl	%ebp, %eax
	addl	%ebp, %edx
.L18:
	movzbl	(%r12,%r9), %r12d
	leal	(%rdx,%r12,2), %edx
	cmpl	%esi, %r8d
	jle	.L15
	movq	-8(%rsp), %rbp
	addq	%rsi, %rbp
	movzbl	0(%rbp,%r13), %r8d
	addl	%r8d, %eax
	addl	%r8d, %edx
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L27:
	xorl	%eax, %eax
	leaq	0(%rbp,%r13), %rdx
	jmp	.L10
	.p2align 4,,10
	.p2align 3
.L19:
	cmpl	%r15d, %r12d
	jle	.L4
	addq	$1, -16(%rsp)
	addq	$1, %r10
	addq	$1, %r15
	testl	%r8d, %r8d
	jg	.L22
.L4:
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE5576:
	.size	calculate_gradient, .-calculate_gradient
	.p2align 4
	.globl	calculate_gradient_near_curve
	.type	calculate_gradient_near_curve, @function
calculate_gradient_near_curve:
.LFB5577:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	100(%rdi), %r11d
	movq	48(%rdi), %r15
	movq	56(%rdi), %rcx
	movq	%rsi, -24(%rsp)
	testl	%r11d, %r11d
	jle	.L38
	movslq	(%rsi), %rsi
	movslq	%ecx, %rcx
	movq	%rdi, %rdx
	movb	$0, -25(%rsp)
	leaq	0(,%rcx,4), %rbx
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%edi, %edi
	movq	%rsi, %rax
	movq	%rbx, -16(%rsp)
	leaq	(%r15,%rsi,4), %rbp
	movl	$1, %ecx
	movl	%eax, %r14d
	leal	1(%rax), %r10d
	movl	96(%rdx), %esi
	leal	-1(%rax), %ebx
	movq	$-1, -40(%rsp)
	notl	%r14d
	movl	%r14d, %r13d
	movl	%r10d, %r14d
	jmp	.L84
	.p2align 4,,10
	.p2align 3
.L47:
	imull	%edi, %edi
	imull	%r9d, %r9d
	addl	%r9d, %edi
	movl	%edi, 0(%rbp)
	testl	%eax, %eax
	jle	.L51
	movslq	%eax, %r11
	movl	100(%rdx), %r9d
	leaq	-4(%r15,%r11,4), %rbp
	cmpl	-40(%rsp), %r9d
	jle	.L87
	cmpb	$0, -25(%rsp)
	jne	.L143
.L87:
	xorl	%edi, %edi
	xorl	%esi, %esi
.L52:
	cmpl	%r8d, %r9d
	jg	.L144
.L57:
	cmpl	%r10d, %r9d
	jg	.L145
.L61:
	imull	%esi, %esi
	imull	%edi, %edi
	addl	%edi, %esi
	movl	%esi, 0(%rbp)
.L51:
	movl	96(%rdx), %r9d
	cmpl	%r14d, %r9d
	jle	.L66
	movslq	%eax, %rbx
	movl	100(%rdx), %r11d
	leaq	4(%r15,%rbx,4), %rbp
	cmpl	-40(%rsp), %r11d
	jle	.L89
	cmpb	$0, -25(%rsp)
	jne	.L146
.L89:
	xorl	%edi, %edi
	xorl	%esi, %esi
.L67:
	cmpl	%r8d, %r11d
	jg	.L147
.L72:
	cmpl	%r10d, %r11d
	jg	.L148
.L76:
	imull	%esi, %esi
	imull	%edi, %edi
	addl	%edi, %esi
	movl	%esi, 0(%rbp)
.L66:
	movl	100(%rdx), %r11d
	cmpl	%r10d, %r11d
	jle	.L38
	movq	-24(%rsp), %rax
	movl	-32(%rsp), %esi
	addq	-16(%rsp), %r15
	movl	(%rax,%rcx,8), %eax
	addl	%eax, %esi
	movslq	%esi, %rsi
	leaq	(%r15,%rsi,4), %rbp
	movl	96(%rdx), %esi
	cmpl	%r8d, %r11d
	jg	.L149
	movl	%eax, %r13d
	xorl	%r9d, %r9d
	leal	-1(%rax), %ebx
	xorl	%edi, %edi
	notl	%r13d
	leal	1(%rax), %r14d
.L40:
	addq	$1, -40(%rsp)
	addq	$1, %r8
	addq	$1, %rcx
	movb	$1, -25(%rsp)
.L84:
	movl	%ebx, %r10d
	notl	%r10d
	shrl	$31, %r10d
	cmpl	%ebx, %esi
	setg	%r12b
	andb	%r10b, %r12b
	movb	%r12b, -4(%rsp)
	je	.L46
	movq	8(%rdx), %r12
	movslq	%ebx, %r10
	imulq	%r8, %r12
	addq	(%rdx), %r12
	movzbl	(%r12,%r10), %r10d
	negl	%r10d
	leal	(%rdi,%r10,2), %edi
.L46:
	shrl	$31, %r13d
	cmpl	%esi, %eax
	movl	%r13d, %r10d
	movl	%r13d, -8(%rsp)
	setl	%r13b
	andl	%r10d, %r13d
	movl	%r14d, %r10d
	notl	%r10d
	shrl	$31, %r10d
	cmpl	%r14d, %esi
	setg	%sil
	andb	%r10b, %sil
	je	.L45
	movq	8(%rdx), %r10
	imulq	%r8, %r10
	movq	%r10, %r12
	movslq	%r14d, %r10
	addq	(%rdx), %r12
	movzbl	(%r12,%r10), %r10d
	leal	(%rdi,%r10,2), %edi
.L45:
	movl	%ecx, -32(%rsp)
	movl	%ecx, %r10d
	cmpl	%ecx, %r11d
	jle	.L47
	cmpb	$0, -4(%rsp)
	je	.L50
	movq	8(%rdx), %r12
	movslq	%ebx, %r11
	imulq	%rcx, %r12
	addq	(%rdx), %r12
	movzbl	(%r12,%r11), %r11d
	subl	%r11d, %edi
	addl	%r11d, %r9d
.L50:
	testb	%r13b, %r13b
	je	.L49
	movq	8(%rdx), %r12
	movslq	%eax, %r11
	imulq	%rcx, %r12
	addq	(%rdx), %r12
	movzbl	(%r12,%r11), %r11d
	leal	(%r9,%r11,2), %r9d
.L49:
	testb	%sil, %sil
	je	.L47
	movq	8(%rdx), %r11
	movslq	%r14d, %rsi
	imulq	%rcx, %r11
	addq	(%rdx), %r11
	movzbl	(%r11,%rsi), %esi
	addl	%esi, %edi
	addl	%esi, %r9d
	jmp	.L47
	.p2align 4,,10
	.p2align 3
.L149:
	leal	-1(%rax), %ebx
	cmpl	%ebx, %esi
	jle	.L91
	testl	%ebx, %ebx
	js	.L91
	movq	8(%rdx), %r9
	movslq	%ebx, %rdi
	imulq	%r8, %r9
	addq	(%rdx), %r9
	movzbl	(%r9,%rdi), %edi
	negl	%edi
.L44:
	movl	%eax, %r13d
	xorl	$-1, %r13d
	jns	.L86
	cmpl	%esi, %eax
	jge	.L86
	movq	8(%rdx), %r10
	movslq	%eax, %r9
	imulq	%r8, %r10
	addq	(%rdx), %r10
	movzbl	(%r10,%r9), %r9d
	negl	%r9d
	leal	(%rdi,%r9,2), %r9d
.L43:
	movl	%eax, %r14d
	addl	$1, %r14d
	js	.L40
	cmpl	%esi, %r14d
	jge	.L40
	movq	8(%rdx), %r12
	movslq	%r14d, %r10
	imulq	%r8, %r12
	addq	(%rdx), %r12
	movzbl	(%r12,%r10), %r10d
	addl	%r10d, %edi
	subl	%r10d, %r9d
	jmp	.L40
	.p2align 4,,10
	.p2align 3
.L143:
	movl	%eax, %esi
	movl	96(%rdx), %r12d
	subl	$2, %esi
	js	.L92
	cmpl	%esi, %r12d
	jle	.L92
	movq	-40(%rsp), %rdi
	movslq	%esi, %rsi
	imulq	8(%rdx), %rdi
	addq	(%rdx), %rdi
	movzbl	(%rdi,%rsi), %esi
	negl	%esi
.L56:
	movl	%esi, %edi
	cmpl	%ebx, %r12d
	jle	.L55
	movq	-40(%rsp), %r13
	movslq	%ebx, %rdi
	imulq	8(%rdx), %r13
	addq	(%rdx), %r13
	movzbl	0(%r13,%rdi), %edi
	negl	%edi
	leal	(%rsi,%rdi,2), %edi
.L55:
	cmpl	%eax, %r12d
	jle	.L52
	movq	-40(%rsp), %r12
	movq	(%rdx), %r13
	imulq	8(%rdx), %r12
	addq	%r11, %r13
	movzbl	0(%r13,%r12), %r12d
	addl	%r12d, %esi
	subl	%r12d, %edi
	cmpl	%r8d, %r9d
	jle	.L57
	.p2align 4,,10
	.p2align 3
.L144:
	movl	96(%rdx), %r13d
	movl	%eax, %r12d
	movl	%r13d, -4(%rsp)
	subl	$2, %r12d
	js	.L60
	cmpl	%r12d, %r13d
	jle	.L60
	movq	8(%rdx), %r13
	movslq	%r12d, %r12
	imulq	%r8, %r13
	addq	(%rdx), %r13
	movzbl	0(%r13,%r12), %r12d
	negl	%r12d
	leal	(%rsi,%r12,2), %esi
.L60:
	cmpl	%eax, -4(%rsp)
	jle	.L57
	movq	8(%rdx), %r12
	movq	(%rdx), %r13
	imulq	%r8, %r12
	addq	%r11, %r13
	movzbl	0(%r13,%r12), %r12d
	leal	(%rsi,%r12,2), %esi
	cmpl	%r10d, %r9d
	jle	.L61
	.p2align 4,,10
	.p2align 3
.L145:
	movl	%eax, %r12d
	movl	96(%rdx), %r9d
	subl	$2, %r12d
	js	.L65
	cmpl	%r12d, %r9d
	jle	.L65
	movq	8(%rdx), %r13
	movslq	%r12d, %r12
	imulq	%rcx, %r13
	addq	(%rdx), %r13
	movzbl	0(%r13,%r12), %r12d
	subl	%r12d, %esi
	addl	%r12d, %edi
.L65:
	cmpl	%ebx, %r9d
	jle	.L64
	movq	8(%rdx), %r12
	movslq	%ebx, %rbx
	imulq	%rcx, %r12
	addq	(%rdx), %r12
	movzbl	(%r12,%rbx), %ebx
	leal	(%rdi,%rbx,2), %edi
.L64:
	cmpl	%r9d, %eax
	jge	.L61
	movq	8(%rdx), %r9
	addq	(%rdx), %r11
	imulq	%rcx, %r9
	movzbl	(%r11,%r9), %r9d
	addl	%r9d, %esi
	addl	%r9d, %edi
	jmp	.L61
	.p2align 4,,10
	.p2align 3
.L86:
	movl	%edi, %r9d
	jmp	.L43
	.p2align 4,,10
	.p2align 3
.L91:
	xorl	%edi, %edi
	jmp	.L44
	.p2align 4,,10
	.p2align 3
.L148:
	cmpl	%eax, %r9d
	jle	.L80
	cmpb	$0, -8(%rsp)
	je	.L80
	movq	8(%rdx), %r11
	addq	(%rdx), %rbx
	imulq	%rcx, %r11
	movzbl	(%rbx,%r11), %r11d
	subl	%r11d, %esi
	addl	%r11d, %edi
.L80:
	testl	%r14d, %r14d
	js	.L79
	movq	8(%rdx), %r11
	movslq	%r14d, %rbx
	imulq	%rcx, %r11
	addq	(%rdx), %r11
	movzbl	(%r11,%rbx), %r11d
	leal	(%rdi,%r11,2), %edi
.L79:
	addl	$2, %eax
	js	.L76
	cmpl	%eax, %r9d
	jle	.L76
	movq	8(%rdx), %r9
	cltq
	imulq	%rcx, %r9
	addq	(%rdx), %r9
	movzbl	(%r9,%rax), %eax
	addl	%eax, %esi
	addl	%eax, %edi
	jmp	.L76
	.p2align 4,,10
	.p2align 3
.L147:
	cmpl	%eax, %r9d
	jle	.L75
	cmpb	$0, -8(%rsp)
	je	.L75
	movq	8(%rdx), %r12
	movq	(%rdx), %r13
	imulq	%r8, %r12
	addq	%rbx, %r13
	movzbl	0(%r13,%r12), %r12d
	negl	%r12d
	leal	(%rsi,%r12,2), %esi
.L75:
	movl	%eax, %r12d
	addl	$2, %r12d
	js	.L72
	cmpl	%r12d, %r9d
	jle	.L72
	movq	8(%rdx), %r13
	movslq	%r12d, %r12
	imulq	%r8, %r13
	addq	(%rdx), %r13
	movzbl	0(%r13,%r12), %r12d
	leal	(%rsi,%r12,2), %esi
	jmp	.L72
	.p2align 4,,10
	.p2align 3
.L146:
	cmpl	%eax, %r9d
	jle	.L93
	cmpb	$0, -8(%rsp)
	je	.L93
	movq	-40(%rsp), %rsi
	movq	(%rdx), %rdi
	imulq	8(%rdx), %rsi
	addq	%rbx, %rdi
	movzbl	(%rdi,%rsi), %esi
	negl	%esi
.L71:
	movl	%esi, %edi
	testl	%r14d, %r14d
	js	.L70
	movq	-40(%rsp), %r12
	movslq	%r14d, %rdi
	imulq	8(%rdx), %r12
	addq	(%rdx), %r12
	movzbl	(%r12,%rdi), %edi
	negl	%edi
	leal	(%rsi,%rdi,2), %edi
.L70:
	movl	%eax, %r12d
	addl	$2, %r12d
	js	.L67
	cmpl	%r12d, %r9d
	jle	.L67
	movq	-40(%rsp), %r13
	movslq	%r12d, %r12
	imulq	8(%rdx), %r13
	addq	(%rdx), %r13
	movzbl	0(%r13,%r12), %r12d
	addl	%r12d, %esi
	subl	%r12d, %edi
	jmp	.L67
	.p2align 4,,10
	.p2align 3
.L38:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L92:
	.cfi_restore_state
	xorl	%esi, %esi
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L93:
	xorl	%esi, %esi
	jmp	.L71
	.cfi_endproc
.LFE5577:
	.size	calculate_gradient_near_curve, .-calculate_gradient_near_curve
	.p2align 4
	.globl	calculate_vertical_gradient_sum
	.type	calculate_vertical_gradient_sum, @function
calculate_vertical_gradient_sum:
.LFB5578:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	100(%rdi), %eax
	movq	48(%rdi), %r11
	movq	56(%rdi), %rsi
	movq	80(%rdi), %r8
	movl	%eax, %r12d
	movslq	96(%rdi), %rbx
	movq	%r11, -80(%rsp)
	movq	72(%rdi), %r9
	movq	%rsi, -72(%rsp)
	movq	%r8, -64(%rsp)
	subl	$2, %r12d
	js	.L150
	leal	-1(%rax), %r10d
	leal	-1(%rbx), %edi
	movl	%esi, %ebp
	movl	%r8d, %r13d
	imull	%r8d, %r10d
	movl	%edi, -88(%rsp)
	leal	-2(%rbx), %r14d
	negl	%r13d
	imull	%r12d, %ebp
	movl	%r14d, -36(%rsp)
	movslq	%r13d, %r13
	salq	$2, %r13
	movl	%r10d, %ecx
	movslq	%r10d, %rax
	subl	%r8d, %ecx
	leaq	(%r9,%rax,4), %rdx
	movslq	%ecx, %rcx
	leaq	(%r9,%rcx,4), %rdi
	movl	%esi, %ecx
	negl	%ecx
	movslq	%ecx, %rcx
	leaq	0(,%rcx,4), %rsi
	movslq	%ebp, %rcx
	movq	%rsi, -56(%rsp)
	leaq	4(%r11,%rcx,4), %rsi
	movl	%r14d, %ecx
	andl	$-4, %r14d
	shrl	$2, %ecx
	movl	%r14d, -40(%rsp)
	leal	-1(%rcx), %r11d
	leal	1(%r14), %ecx
	movl	%ecx, -84(%rsp)
	leal	2(%r14), %ecx
	addq	$1, %r11
	movl	%ecx, -48(%rsp)
	leal	3(%r14), %ecx
	salq	$4, %r11
	movl	%ecx, -32(%rsp)
	movl	%r8d, %ecx
	imull	%r12d, %ecx
	movslq	%ecx, %rcx
	subq	%rax, %rcx
	leal	-3(%rbx), %eax
	movl	%eax, -44(%rsp)
	salq	$2, %rax
	movq	%rcx, -24(%rsp)
	movq	%rax, -16(%rsp)
	.p2align 4,,10
	.p2align 3
.L158:
	movl	4(%rdx), %eax
	movl	(%rdx), %r14d
	movl	%r10d, %ecx
	leaq	4(%rdx), %r8
	subl	-64(%rsp), %r10d
	cmpl	%r14d, %eax
	cmovg	%r14d, %eax
	addl	-4(%rsi), %eax
	cmpl	$1, -88(%rsp)
	movl	%eax, (%rdi)
	jle	.L152
	movq	%rdi, %rax
	leaq	4(%rdi), %r14
	subq	%rsi, %rax
	cmpq	$8, %rax
	seta	%r15b
	cmpl	$2, -44(%rsp)
	seta	%al
	testb	%al, %r15b
	je	.L153
	movq	%rdi, %rax
	subq	%rdx, %rax
	cmpq	$16, %rax
	jbe	.L153
	leaq	8(%rdx), %r15
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L154:
	movdqu	(%r15,%rax), %xmm3
	movdqu	(%r8,%rax), %xmm1
	movdqu	(%r8,%rax), %xmm4
	movdqu	(%rdx,%rax), %xmm5
	pcmpgtd	%xmm3, %xmm1
	movdqa	%xmm3, %xmm0
	movdqu	(%rsi,%rax), %xmm6
	movdqa	%xmm5, %xmm2
	pand	%xmm1, %xmm0
	pandn	%xmm4, %xmm1
	por	%xmm0, %xmm1
	movdqa	%xmm1, %xmm0
	pcmpgtd	%xmm5, %xmm0
	pand	%xmm0, %xmm2
	pandn	%xmm1, %xmm0
	por	%xmm2, %xmm0
	paddd	%xmm6, %xmm0
	movups	%xmm0, (%r14,%rax)
	addq	$16, %rax
	cmpq	%r11, %rax
	jne	.L154
	movl	-36(%rsp), %r14d
	cmpl	%r14d, -40(%rsp)
	je	.L152
	movl	-84(%rsp), %r8d
	leal	(%rcx,%r8), %eax
	addl	%r10d, %r8d
	cltq
	movslq	%r8d, %r8
	addq	$1, %rax
	leaq	0(,%rax,4), %r14
	movl	(%r9,%rax,4), %eax
	movl	-8(%r9,%r14), %r15d
	movl	-4(%r9,%r14), %r14d
	cmpl	%eax, %r15d
	cmovle	%r15d, %eax
	movq	-80(%rsp), %r15
	cmpl	%r14d, %eax
	cmovg	%r14d, %eax
	movl	-84(%rsp), %r14d
	addl	%ebp, %r14d
	movslq	%r14d, %r14
	addl	(%r15,%r14,4), %eax
	movl	%eax, (%r9,%r8,4)
	movl	-48(%rsp), %r8d
	cmpl	%r8d, -88(%rsp)
	jle	.L152
	leal	(%rcx,%r8), %eax
	addl	%r10d, %r8d
	cltq
	movslq	%r8d, %r8
	addq	$1, %rax
	leaq	0(,%rax,4), %r14
	movl	(%r9,%rax,4), %eax
	movl	-8(%r9,%r14), %r15d
	movl	-4(%r9,%r14), %r14d
	cmpl	%eax, %r15d
	cmovle	%r15d, %eax
	movq	-80(%rsp), %r15
	cmpl	%r14d, %eax
	cmovg	%r14d, %eax
	movl	-48(%rsp), %r14d
	addl	%ebp, %r14d
	movslq	%r14d, %r14
	addl	(%r15,%r14,4), %eax
	movl	-32(%rsp), %r15d
	movl	%eax, (%r9,%r8,4)
	cmpl	%r15d, -88(%rsp)
	jle	.L152
	leal	(%rcx,%r15), %eax
	leal	(%r15,%r10), %ecx
	cltq
	movslq	%ecx, %rcx
	addq	$1, %rax
	leaq	0(,%rax,4), %r8
	movl	(%r9,%rax,4), %eax
	movl	-8(%r9,%r8), %r14d
	movl	-4(%r9,%r8), %r8d
	cmpl	%eax, %r14d
	cmovle	%r14d, %eax
	cmpl	%r8d, %eax
	cmovg	%r8d, %eax
	leal	0(%rbp,%r15), %r8d
	movq	-80(%rsp), %r15
	movslq	%r8d, %r8
	addl	(%r15,%r8,4), %eax
	movl	%eax, (%r9,%rcx,4)
.L152:
	movl	-8(%rdx,%rbx,4), %eax
	movl	-4(%rdx,%rbx,4), %ecx
	cmpl	%ecx, %eax
	cmovg	%ecx, %eax
	subl	$1, %r12d
	addl	-8(%rsi,%rbx,4), %eax
	addq	%r13, %rdx
	subl	-72(%rsp), %ebp
	addq	-56(%rsp), %rsi
	movl	%eax, -4(%rdi,%rbx,4)
	addq	%r13, %rdi
	cmpl	$-1, %r12d
	jne	.L158
.L150:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L153:
	.cfi_restore_state
	movq	-16(%rsp), %rax
	movl	%r10d, -28(%rsp)
	leaq	-4(%rsi), %r8
	movq	%rdx, %rcx
	movq	-24(%rsp), %r10
	leaq	(%rsi,%rax), %r14
	.p2align 4,,10
	.p2align 3
.L156:
	movl	4(%rcx), %r15d
	movl	8(%rcx), %eax
	cmpl	%eax, %r15d
	cmovle	%r15d, %eax
	movl	(%rcx), %r15d
	cmpl	%r15d, %eax
	cmovg	%r15d, %eax
	addq	$4, %r8
	addl	(%r8), %eax
	movl	%eax, 4(%rcx,%r10,4)
	addq	$4, %rcx
	cmpq	%r14, %r8
	jne	.L156
	movl	-28(%rsp), %r10d
	jmp	.L152
	.cfi_endproc
.LFE5578:
	.size	calculate_vertical_gradient_sum, .-calculate_vertical_gradient_sum
	.p2align 4
	.globl	get_next_x_in_curve
	.type	get_next_x_in_curve, @function
get_next_x_in_curve:
.LFB5579:
	.cfi_startproc
	endbr64
	movslq	%edx, %rdx
	imulq	80(%rdi), %rdx
	movslq	%esi, %rcx
	movq	72(%rdi), %r9
	movq	%rcx, %rax
	xorl	%r8d, %r8d
	movl	96(%rdi), %edi
	addq	%rdx, %rcx
	movl	(%r9,%rcx,4), %esi
	leal	-1(%rax), %ecx
	testl	%ecx, %ecx
	cmovs	%r8d, %ecx
	leal	2(%rax), %r8d
	cmpl	%edi, %r8d
	cmovle	%r8d, %edi
	cmpl	%edi, %ecx
	jge	.L169
	movslq	%ecx, %rcx
	leaq	(%r9,%rdx,4), %r8
	.p2align 4,,10
	.p2align 3
.L172:
	movl	(%r8,%rcx,4), %edx
	cmpl	%edx, %esi
	jle	.L171
	movl	%edx, %esi
	movl	%ecx, %eax
.L171:
	addq	$1, %rcx
	cmpl	%ecx, %edi
	jg	.L172
.L169:
	ret
	.cfi_endproc
.LFE5579:
	.size	get_next_x_in_curve, .-get_next_x_in_curve
	.p2align 4
	.globl	find_min_vertical_curve
	.type	find_min_vertical_curve, @function
find_min_vertical_curve:
.LFB5580:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, 8(%rsp)
	movslq	100(%rdi), %rdi
	movq	%rdi, %rbp
	salq	$3, %rdi
	call	malloc@PLT
	movq	72(%rbx), %r11
	movl	96(%rbx), %ebx
	movq	%rax, %r10
	movl	(%r11), %ecx
	cmpl	$1, %ebx
	jle	.L192
	movslq	%ebx, %rsi
	movl	$1, %eax
	xorl	%r15d, %r15d
	.p2align 4,,10
	.p2align 3
.L179:
	movl	(%r11,%rax,4), %edx
	cmpl	%ecx, %edx
	jge	.L178
	movl	%edx, %ecx
	movl	%eax, %r15d
.L178:
	addq	$1, %rax
	cmpq	%rax, %rsi
	jne	.L179
	movl	%r15d, (%r10)
	cmpl	$1, %ebp
	jle	.L180
.L200:
	movq	8(%rsp), %rax
	leaq	8(%r10), %r8
	movq	%r11, %rsi
	xorl	%r9d, %r9d
	movq	80(%rax), %r12
	leal	-1(%rbp), %eax
	leaq	(%r10,%rax,8), %r13
	leaq	0(,%r12,4), %r14
	.p2align 4,,10
	.p2align 3
.L187:
	movslq	%r15d, %rax
	xorl	%ecx, %ecx
	movq	%rax, %rdi
	addq	%r9, %rax
	movl	(%r11,%rax,4), %edx
	leal	-1(%rdi), %eax
	testl	%eax, %eax
	cmovs	%ecx, %eax
	leal	2(%rdi), %ecx
	cmpl	%ebx, %ecx
	cmovg	%ebx, %ecx
	cmpl	%ecx, %eax
	jge	.L181
	cltq
	.p2align 4,,10
	.p2align 3
.L183:
	movl	(%rsi,%rax,4), %r15d
	cmpl	%edx, %r15d
	jge	.L182
	movl	%r15d, %edx
	movl	%eax, %edi
.L182:
	addq	$1, %rax
	cmpl	%eax, %ecx
	jg	.L183
	movl	%edi, %r15d
.L181:
	movl	%r15d, (%r8)
	addq	%r12, %r9
	addq	%r14, %rsi
	cmpq	%r13, %r8
	je	.L199
	addq	$8, %r8
	jmp	.L187
	.p2align 4,,10
	.p2align 3
.L199:
	movq	8(%rsp), %rax
	movq	32(%rax), %rdi
	movq	24(%rax), %rcx
	cmpq	$1, %rdi
	jne	.L193
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L186:
	movl	(%r10,%rax,8), %edx
	addq	%rax, %rdx
	movl	(%rcx,%rdx,4), %edx
	movl	%edx, 4(%r10,%rax,8)
	addq	$1, %rax
	cmpl	%eax, %ebp
	jg	.L186
.L176:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r10, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L193:
	.cfi_restore_state
	xorl	%esi, %esi
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L185:
	movl	(%r10,%rax,8), %edx
	addq	%rsi, %rdx
	addq	%rdi, %rsi
	movl	(%rcx,%rdx,4), %edx
	movl	%edx, 4(%r10,%rax,8)
	addq	$1, %rax
	cmpl	%eax, %ebp
	jg	.L185
	jmp	.L176
.L192:
	xorl	%r15d, %r15d
	movl	%r15d, (%r10)
	cmpl	$1, %ebp
	jg	.L200
.L180:
	jne	.L176
	movq	8(%rsp), %rbx
	movl	(%r10), %edx
	movq	24(%rbx), %rax
	movl	(%rax,%rdx,4), %eax
	movl	%eax, 4(%r10)
	jmp	.L176
	.cfi_endproc
.LFE5580:
	.size	find_min_vertical_curve, .-find_min_vertical_curve
	.p2align 4
	.globl	remove_vertical_curve_from_image
	.type	remove_vertical_curve_from_image, @function
remove_vertical_curve_from_image:
.LFB5581:
	.cfi_startproc
	endbr64
	movl	100(%rdi), %eax
	testl	%eax, %eax
	jle	.L211
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	xorl	%r12d, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	.p2align 4,,10
	.p2align 3
.L203:
	movq	32(%rbx), %rax
	movslq	0(%rbp,%r12,8), %rcx
	imulq	%r12, %rax
	movq	%rcx, %rdx
	addq	$1, %r12
	notl	%edx
	addl	96(%rbx), %edx
	movslq	%edx, %rdx
	addq	%rcx, %rax
	movq	24(%rbx), %rcx
	salq	$2, %rdx
	leaq	(%rcx,%rax,4), %rdi
	leaq	4(%rdi), %rsi
	call	memmove@PLT
	movl	100(%rbx), %eax
	cmpl	%r12d, %eax
	jg	.L203
	testl	%eax, %eax
	jle	.L201
	xorl	%r12d, %r12d
	.p2align 4,,10
	.p2align 3
.L204:
	movq	8(%rbx), %rdi
	movslq	0(%rbp,%r12,8), %rax
	imulq	%r12, %rdi
	movq	%rax, %rdx
	addq	$1, %r12
	notl	%edx
	addl	96(%rbx), %edx
	movslq	%edx, %rdx
	addq	%rax, %rdi
	addq	(%rbx), %rdi
	leaq	1(%rdi), %rsi
	call	memmove@PLT
	movl	100(%rbx), %eax
	cmpl	%r12d, %eax
	jg	.L204
	testl	%eax, %eax
	jle	.L201
	xorl	%r12d, %r12d
	.p2align 4,,10
	.p2align 3
.L206:
	movq	56(%rbx), %rax
	movslq	0(%rbp,%r12,8), %rcx
	imulq	%r12, %rax
	movq	%rcx, %rdx
	addq	$1, %r12
	notl	%edx
	addl	96(%rbx), %edx
	movslq	%edx, %rdx
	addq	%rcx, %rax
	movq	48(%rbx), %rcx
	salq	$2, %rdx
	leaq	(%rcx,%rax,4), %rdi
	leaq	4(%rdi), %rsi
	call	memmove@PLT
	cmpl	%r12d, 100(%rbx)
	jg	.L206
.L201:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L211:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	ret
	.cfi_endproc
.LFE5581:
	.size	remove_vertical_curve_from_image, .-remove_vertical_curve_from_image
	.p2align 4
	.globl	format_image
	.type	format_image, @function
format_image:
.LFB5582:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movq	16(%rsi), %xmm6
	movslq	16(%rsi), %rbp
	movslq	20(%rsi), %r14
	pshufd	$0xe5, %xmm6, %xmm7
	movd	%xmm7, %r13d
	movq	%rbp, %xmm5
	movq	%xmm6, 48(%rsp)
	movq	%r14, %xmm7
	imulq	%rbp, %r14
	movd	%xmm6, 60(%rsp)
	punpcklqdq	%xmm7, %xmm5
	movaps	%xmm5, 32(%rsp)
	movq	%r14, %rdi
	salq	$2, %r14
	call	malloc@PLT
	movq	%r14, %rdi
	movq	%rax, 8(%rsp)
	movq	%rax, %r15
	call	malloc@PLT
	movq	%r14, %rdi
	movq	%rax, (%rsp)
	call	malloc@PLT
	movq	%r14, %rdi
	movq	%rax, 16(%rsp)
	call	malloc@PLT
	testl	%r13d, %r13d
	movq	32(%rbx), %rcx
	movdqa	32(%rsp), %xmm5
	movq	%rax, 24(%rsp)
	movq	48(%rsp), %xmm6
	jle	.L215
	movslq	60(%rsp), %r10
	testl	%r10d, %r10d
	jle	.L215
	movq	(%rsp), %rdi
	movl	24(%rbx), %r14d
	movq	%r15, %r8
	leaq	0(,%rbp,4), %r15
	movsd	.LC0(%rip), %xmm4
	movsd	.LC1(%rip), %xmm3
	movsd	.LC2(%rip), %xmm2
	movq	8(%rbx), %r11
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L216:
	movl	%r14d, %esi
	xorl	%edx, %edx
	imull	%ebx, %esi
	.p2align 4,,10
	.p2align 3
.L217:
	movzbl	17(%r11), %eax
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	imull	%edx, %eax
	addl	%esi, %eax
	cltq
	movzbl	1(%rcx,%rax), %r9d
	cvtsi2sdl	%r9d, %xmm0
	movzbl	(%rcx,%rax), %r9d
	movzbl	2(%rcx,%rax), %eax
	movl	%edx, (%rdi,%rdx,4)
	cvtsi2sdl	%r9d, %xmm1
	mulsd	%xmm4, %xmm0
	mulsd	%xmm3, %xmm1
	addsd	%xmm1, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	mulsd	%xmm2, %xmm1
	addsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %eax
	movb	%al, (%r8,%rdx)
	addq	$1, %rdx
	cmpq	%rdx, %r10
	jne	.L217
	addl	$1, %ebx
	addq	%rbp, %r8
	addq	%r15, %rdi
	cmpl	%r13d, %ebx
	jne	.L216
.L215:
	movq	8(%rsp), %rax
	movups	%xmm5, 8(%r12)
	movups	%xmm5, 32(%r12)
	movq	%rax, (%r12)
	movq	(%rsp), %rax
	movups	%xmm5, 56(%r12)
	movq	%rax, 24(%r12)
	movq	16(%rsp), %rax
	movups	%xmm5, 80(%r12)
	movq	%rax, 48(%r12)
	movq	24(%rsp), %rax
	movq	%xmm6, 96(%r12)
	movq	%rax, 72(%r12)
	addq	$72, %rsp
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE5582:
	.size	format_image, .-format_image
	.p2align 4
	.globl	free_image
	.type	free_image, @function
free_image:
.LFB5583:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	movq	24(%rdi), %rdi
	call	free@PLT
	movq	(%rbx), %rdi
	call	free@PLT
	movq	48(%rbx), %rdi
	call	free@PLT
	movq	72(%rbx), %rdi
	popq	%rbx
	.cfi_def_cfa_offset 8
	jmp	free@PLT
	.cfi_endproc
.LFE5583:
	.size	free_image, .-free_image
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC3:
	.string	"completed 0%%"
.LC5:
	.string	"\033[K"
.LC6:
	.string	"\rcompleted %3d%%\r"
.LC7:
	.string	"\rcompleted 100%%\n"
	.text
	.p2align 4
	.globl	compile_vertical_curves
	.type	compile_vertical_curves, @function
compile_vertical_curves:
.LFB5584:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %rsi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$136, %rsp
	.cfi_def_cfa_offset 192
	movq	%fs:40, %rax
	movq	%rax, 120(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rbp
	movq	%rbp, %rdi
	call	format_image
	movslq	112(%rsp), %r14
	leaq	0(,%r14,8), %rdi
	call	malloc@PLT
	movq	%rbp, %rdi
	movq	%rax, %r12
	call	calculate_gradient
	xorl	%eax, %eax
	movl	$1, %edi
	leaq	.LC3(%rip), %rsi
	call	__printf_chk@PLT
	testl	%r14d, %r14d
	jle	.L224
	pxor	%xmm2, %xmm2
	xorl	%ebx, %ebx
	xorl	%r13d, %r13d
	cvtsi2sdl	%r14d, %xmm2
	movsd	%xmm2, 8(%rsp)
	jmp	.L226
	.p2align 4,,10
	.p2align 3
.L225:
	addq	$1, %rbx
	cmpq	%r14, %rbx
	je	.L224
.L226:
	movq	%rbp, %rdi
	call	calculate_vertical_gradient_sum
	movq	%rbp, %rdi
	call	find_min_vertical_curve
	movq	%rbp, %rdi
	movq	%rax, %rsi
	movq	%rax, (%r12,%rbx,8)
	call	remove_vertical_curve_from_image
	movq	(%r12,%rbx,8), %rsi
	movq	%rbp, %rdi
	pxor	%xmm0, %xmm0
	subl	$1, 112(%rsp)
	call	calculate_gradient_near_curve
	cvtsi2sdl	%ebx, %xmm0
	divsd	8(%rsp), %xmm0
	mulsd	.LC4(%rip), %xmm0
	cvttsd2sil	%xmm0, %r15d
	cmpl	%r13d, %r15d
	jle	.L225
	leaq	.LC5(%rip), %rsi
	xorl	%eax, %eax
	addq	$1, %rbx
	movl	%r15d, %r13d
	movl	$1, %edi
	call	__printf_chk@PLT
	movl	%r15d, %edx
	movl	$1, %edi
	xorl	%eax, %eax
	leaq	.LC6(%rip), %rsi
	call	__printf_chk@PLT
	movq	stdout(%rip), %rdi
	call	fflush@PLT
	cmpq	%r14, %rbx
	jne	.L226
.L224:
	leaq	.LC7(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movq	40(%rsp), %rdi
	call	free@PLT
	movq	16(%rsp), %rdi
	call	free@PLT
	movq	64(%rsp), %rdi
	call	free@PLT
	movq	88(%rsp), %rdi
	call	free@PLT
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L230
	addq	$136, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L230:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE5584:
	.size	compile_vertical_curves, .-compile_vertical_curves
	.p2align 4
	.globl	create_resizable_image
	.type	create_resizable_image, @function
create_resizable_image:
.LFB5585:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%edx, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movl	%r8d, %r13d
	imull	%ecx, %r13d
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movl	%ecx, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movslq	%r13d, %r13
	movq	%r13, %rdi
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	%r9d, 12(%rsp)
	movl	%r8d, 8(%rsp)
	call	malloc@PLT
	movq	%r13, %rdx
	movq	%r12, %rsi
	movslq	%r14d, %r13
	movq	%rax, %rdi
	movq	%rax, %rbx
	call	memcpy@PLT
	movslq	%ebp, %rax
	movq	%rax, %rdi
	movq	%rax, (%rsp)
	imulq	%r13, %rdi
	call	malloc@PLT
	movq	%r12, %xmm0
	movd	12(%rsp), %xmm3
	movd	%r14d, %xmm2
	movhps	80(%rsp), %xmm0
	movd	%ebp, %xmm1
	movl	%ebp, 24(%r15)
	movups	%xmm0, (%r15)
	movd	8(%rsp), %xmm0
	punpckldq	%xmm3, %xmm1
	movq	%rbx, 32(%r15)
	punpckldq	%xmm2, %xmm0
	movq	%rax, 56(%r15)
	movq	%r15, %rax
	movq	%xmm0, 16(%r15)
	punpcklqdq	%xmm1, %xmm0
	movups	%xmm0, 40(%r15)
	movq	%r13, %xmm0
	movhps	(%rsp), %xmm0
	movups	%xmm0, 64(%r15)
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE5585:
	.size	create_resizable_image, .-create_resizable_image
	.p2align 4
	.globl	resize_img
	.type	resize_img, @function
resize_img:
.LFB5586:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%esi, %ebx
	xorl	%esi, %esi
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	64(%rdi), %rdx
	imulq	72(%rdi), %rdx
	movq	56(%rdi), %rdi
	call	memset@PLT
	movslq	24(%rbp), %r11
	testl	%r11d, %r11d
	jle	.L234
	movl	20(%rbp), %esi
	movl	%esi, %eax
	subl	%ebx, %eax
	testl	%eax, %eax
	jle	.L235
	movq	8(%rbp), %r12
	subl	$1, %eax
	movq	56(%rbp), %rcx
	xorl	%r10d, %r10d
	movq	64(%rbp), %r13
	leaq	8(%r12,%rax,8), %r9
	.p2align 4,,10
	.p2align 3
.L236:
	movq	%r13, %rdx
	leaq	0(,%r10,8), %r8
	movq	%r12, %rax
	imulq	%r10, %rdx
	leaq	(%rcx,%rdx), %rdi
	.p2align 4,,10
	.p2align 3
.L237:
	movq	(%rax), %rdx
	addq	$8, %rax
	movl	4(%rdx,%r8), %edx
	movb	$1, (%rdi,%rdx)
	cmpq	%r9, %rax
	jne	.L237
	addq	$1, %r10
	cmpq	%r10, %r11
	jne	.L236
.L235:
	movl	52(%rbp), %eax
	movd	%ebx, %xmm1
	xorl	%r13d, %r13d
	movl	%r13d, %r12d
	movl	%r13d, %r15d
	imull	%ebx, %eax
	movd	%eax, %xmm0
	punpckldq	%xmm1, %xmm0
	movq	%xmm0, 40(%rbp)
	testl	%esi, %esi
	jle	.L233
	.p2align 4,,10
	.p2align 3
.L245:
	xorl	%ebx, %ebx
	xorl	%r14d, %r14d
.L249:
	movq	56(%rbp), %rcx
.L241:
	movq	64(%rbp), %rax
	leaq	(%rcx,%rbx), %rdx
	imulq	%r13, %rax
	cmpb	$0, (%rdx,%rax)
	je	.L250
	addq	$1, %rbx
	cmpl	%ebx, %esi
	jg	.L241
.L240:
	addl	$1, %r12d
	cmpl	24(%rbp), %r12d
	jge	.L233
	addq	$1, %r13
	movl	%r13d, %r12d
	movl	%r13d, %r15d
	testl	%esi, %esi
	jg	.L245
.L233:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L250:
	.cfi_restore_state
	movl	52(%rbp), %eax
	movl	40(%rbp), %edi
	movl	16(%rbp), %esi
	movl	%eax, %edx
	imull	%r15d, %edi
	imull	%r14d, %edx
	addl	$1, %r14d
	imull	%r15d, %esi
	addl	%edx, %edi
	movslq	%eax, %rdx
	imull	%ebx, %eax
	movslq	%edi, %rdi
	addq	32(%rbp), %rdi
	addq	$1, %rbx
	addl	%eax, %esi
	movslq	%esi, %rsi
	addq	0(%rbp), %rsi
	call	memcpy@PLT
	movl	20(%rbp), %esi
	cmpl	%ebx, %esi
	jg	.L249
	jmp	.L240
.L234:
	movl	52(%rbp), %eax
	movd	%ebx, %xmm2
	imull	%ebx, %eax
	movd	%eax, %xmm0
	punpckldq	%xmm2, %xmm0
	movq	%xmm0, 40(%rbp)
	addq	$8, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE5586:
	.size	resize_img, .-resize_img
	.p2align 4
	.globl	window_loop
	.type	window_loop, @function
window_loop:
.LFB5587:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$248, %rsp
	.cfi_def_cfa_offset 304
	movl	24(%rcx), %r9d
	movl	20(%rcx), %r13d
	movslq	16(%rcx), %rbx
	movq	32(%rcx), %r14
	movq	%r8, 16(%rsp)
	movl	%r9d, %edx
	movd	%r9d, %xmm1
	movd	%r13d, %xmm0
	imull	%r13d, %edx
	movd	%ebx, %xmm4
	movq	%fs:40, %rax
	movq	%rax, 232(%rsp)
	xorl	%eax, %eax
	movq	8(%rcx), %rax
	punpckldq	%xmm4, %xmm1
	movl	%r9d, 52(%rsp)
	movdqa	%xmm1, %xmm2
	movq	%xmm1, 56(%rsp)
	movzbl	17(%rax), %eax
	movslq	%edx, %rdx
	movq	%rdx, %rdi
	movq	%rdx, 8(%rsp)
	movd	%eax, %xmm3
	punpckldq	%xmm3, %xmm0
	punpcklqdq	%xmm0, %xmm2
	movaps	%xmm2, 32(%rsp)
	call	malloc@PLT
	movq	8(%rsp), %rdx
	movq	%r14, %rsi
	movq	%rax, %rdi
	movq	%rax, 24(%rsp)
	call	memcpy@PLT
	movslq	%r13d, %rax
	movq	%rax, %rdi
	movq	%rax, 8(%rsp)
	imulq	%rbx, %rdi
	call	malloc@PLT
	movq	%r14, %xmm0
	movl	52(%rsp), %ecx
	xorl	%esi, %esi
	movq	24(%rsp), %r8
	movhps	16(%rsp), %xmm0
	movq	56(%rsp), %xmm1
	movq	%r12, %rdi
	movdqa	32(%rsp), %xmm2
	movaps	%xmm0, 96(%rsp)
	movq	%rbx, %xmm0
	leaq	176(%rsp), %rbx
	movhps	8(%rsp), %xmm0
	movq	%r8, %rdx
	movl	%r13d, 120(%rsp)
	leaq	76(%rsp), %r13
	movq	%r8, 128(%rsp)
	movq	%rax, 152(%rsp)
	movq	%xmm1, 112(%rsp)
	movups	%xmm2, 136(%rsp)
	movaps	%xmm0, 160(%rsp)
	call	SDL_UpdateTexture@PLT
	.p2align 4,,10
	.p2align 3
.L257:
	movq	%rbx, %rdi
	call	SDL_WaitEvent@PLT
	movl	176(%rsp), %eax
	cmpl	$512, %eax
	je	.L252
	cmpl	$768, %eax
	je	.L253
	cmpl	$256, %eax
	jne	.L257
.L251:
	movq	232(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L269
	addq	$248, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L253:
	.cfi_restore_state
	movl	196(%rsp), %eax
	cmpl	$27, %eax
	je	.L251
	cmpl	$113, %eax
	jne	.L257
	jmp	.L251
	.p2align 4,,10
	.p2align 3
.L252:
	movl	$255, %r8d
	movl	$40, %ecx
	movl	$40, %edx
	movq	%rbp, %rdi
	movl	$40, %esi
	call	SDL_SetRenderDrawColor@PLT
	movq	%rbp, %rdi
	call	SDL_RenderClear@PLT
	leaq	72(%rsp), %rsi
	movq	%r13, %rdx
	movq	%r15, %rdi
	call	SDL_GetWindowSize@PLT
	movq	116(%rsp), %xmm0
	movl	72(%rsp), %esi
	movq	$0, 80(%rsp)
	movd	%xmm0, %eax
	movq	%xmm0, 88(%rsp)
	cmpl	%eax, %esi
	jl	.L270
.L256:
	movq	%rbp, %rdi
	leaq	80(%rsp), %rcx
	xorl	%edx, %edx
	movq	%r12, %rsi
	call	SDL_RenderCopy@PLT
	movq	%rbp, %rdi
	call	SDL_RenderPresent@PLT
	jmp	.L257
	.p2align 4,,10
	.p2align 3
.L270:
	leaq	96(%rsp), %rdi
	call	resize_img
	movl	140(%rsp), %ecx
	xorl	%esi, %esi
	movq	%r12, %rdi
	imull	148(%rsp), %ecx
	movq	128(%rsp), %rdx
	call	SDL_UpdateTexture@PLT
	jmp	.L256
.L269:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE5587:
	.size	window_loop, .-window_loop
	.p2align 4
	.globl	die
	.type	die, @function
die:
.LFB5588:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rsi
	call	fputs@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE5588:
	.size	die, .-die
	.section	.rodata.str1.1
.LC8:
	.string	"Please provide an image path\n"
.LC9:
	.string	"Image not found\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC10:
	.string	"(x: %d, y: %d, channels: %d, pitch: %d)\n"
	.section	.rodata.str1.1
.LC12:
	.string	"Compiling took: %f\n"
.LC13:
	.string	"Image Evolution"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB5589:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movl	%edi, %ebx
	xorl	%edi, %edi
	call	SDL_Init@PLT
	cmpl	$2, %ebx
	jne	.L277
	movq	8(%rbp), %rdi
	call	IMG_Load@PLT
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L278
	movq	8(%rax), %rax
	movl	20(%rbp), %ecx
	movl	$1, %edi
	leaq	.LC10(%rip), %rsi
	movl	16(%rbp), %edx
	movl	24(%rbp), %r9d
	movzbl	17(%rax), %r8d
	xorl	%eax, %eax
	call	__printf_chk@PLT
	call	clock@PLT
	movq	%rbp, %rdi
	movq	%rax, %r12
	call	compile_vertical_curves
	movq	%rax, %rbx
	call	clock@PLT
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	leaq	.LC12(%rip), %rsi
	cvtsi2sdq	%r12, %xmm1
	movl	$1, %edi
	cvtsi2sdq	%rax, %xmm0
	movl	$1, %eax
	subsd	%xmm1, %xmm0
	divsd	.LC11(%rip), %xmm0
	call	__printf_chk@PLT
	movl	$32, %r9d
	movl	$800, %r8d
	movl	$800, %ecx
	movl	$805240832, %edx
	movl	$805240832, %esi
	leaq	.LC13(%rip), %rdi
	call	SDL_CreateWindow@PLT
	movl	$2, %edx
	movl	$-1, %esi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	SDL_CreateRenderer@PLT
	movl	16(%rbp), %ecx
	movl	20(%rbp), %r8d
	xorl	%edx, %edx
	movq	%rax, %r13
	movq	8(%rbp), %rax
	movq	%r13, %rdi
	movl	(%rax), %esi
	call	SDL_CreateTexture@PLT
	movq	%rbx, %r8
	movq	%rbp, %rcx
	movq	%r13, %rsi
	movq	%rax, %r14
	movq	%rax, %rdx
	movq	%r12, %rdi
	call	window_loop
	movq	%r14, %rdi
	call	SDL_DestroyTexture@PLT
	movq	%rbp, %rdi
	call	SDL_FreeSurface@PLT
	movq	%r13, %rdi
	call	SDL_DestroyRenderer@PLT
	movq	%r12, %rdi
	call	SDL_DestroyWindow@PLT
	call	SDL_Quit@PLT
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	xorl	%eax, %eax
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L277:
	.cfi_restore_state
	leaq	.LC8(%rip), %rdi
	call	die
.L278:
	leaq	.LC9(%rip), %rdi
	call	die
	.cfi_endproc
.LFE5589:
	.size	main, .-main
	.globl	SOBEL_Y
	.section	.rodata
	.align 32
	.type	SOBEL_Y, @object
	.size	SOBEL_Y, 36
SOBEL_Y:
	.long	-1
	.long	-2
	.long	-1
	.long	0
	.long	0
	.long	0
	.long	1
	.long	2
	.long	1
	.globl	SOBEL_X
	.align 32
	.type	SOBEL_X, @object
	.size	SOBEL_X, 36
SOBEL_X:
	.long	-1
	.long	0
	.long	1
	.long	-2
	.long	0
	.long	2
	.long	-1
	.long	0
	.long	1
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	962072674
	.long	1071827124
	.align 8
.LC1:
	.long	-446676599
	.long	1070801616
	.align 8
.LC2:
	.long	-1614907703
	.long	1069362970
	.align 8
.LC4:
	.long	0
	.long	1079574528
	.align 8
.LC11:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
