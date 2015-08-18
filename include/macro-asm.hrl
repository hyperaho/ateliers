-define(
   ENTRY_POINT_ASM, 
   <<".file \"out.s\"
	.globl	i
	.bss
	.align 4
	.type	i, @object
	.size	i, 4
i:
	.zero	4
	.comm	p,12000,64
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
.cfi_def_cfa_register 6
movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	cltq
	movl	$0, p(,%rax,4)
	addl	$1, -4(%rbp)
.L2:
	cmpl	$2999, -4(%rbp)
	jle	.L3\n
">>
).

-define(
   CLOSED_POINT_ASM, 
   <<"	movl	$0, %eax
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	\"GCC: (Debian 4.9.2-10) 4.9.2\"
	.section	.note.GNU-stack,\"\",@progbits\n
   ">>).

-define(
   ADD_ASM(N), 
   <<"movl	i(%rip), %ecx
   movl	i(%rip), %eax
   cltq
   movl	p(,%rax,4), %eax
   leal	",N/binary,"(%rax), %edx
   movslq	%ecx, %rax
   movl	%edx, p(,%rax,4)\n
   ">>).

-define(
   INCREASE_ASM(N), 
   <<"movl	i(%rip), %eax
      addl  \$",N/binary,", %eax
      movl	%eax, i(%rip)\n
    ">>).


-define(
   DECREASE_ASM(N), 
   <<"movl	i(%rip), %eax
      subl	\$",N/binary,", %eax
      movl	%eax, i(%rip)\n
    ">>).


-define(
   PUTCHAR_ASM, 
   <<"
      movl	i(%rip), %eax
      cltq
      movl	p(,%rax,4), %eax
      movl	%eax, %edi
      call	putchar\n"
   >>).

-define(
   GETCHAR_ASM, 
   <<"
      pushq	%rbx
      subq	$8, %rsp
      .cfi_offset 3, -24
      movl	i(%rip), %ebx
      call	getchar
      movl	%eax, %edx
      movslq	%ebx, %rax
      movl	%edx, p(,%rax,4)\n
   ">>
  ).

-define(
   LOOP_ASM(L, M, A), 
   <<"jmp	.L", L/binary, "
      .L",M/binary,":\n",A/binary,"

     .L",L/binary,":
	    movl	i(%rip), %eax
	    cltq
	    movl	p(,%rax,4), %eax
	    testl	%eax, %eax
	    jne	.L", M/binary, "\n"
    >>
).

-define(
   TOZERO_ASM, 
   <<"movl	i(%rip), %eax
	    cltq
	    movl	$0, p(,%rax,4)\n"
   >>).
