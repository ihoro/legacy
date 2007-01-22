comment `#####################################################
#
#  fpu_pow.asm    07.06.2005 by fnt0m32
#
#  Функция вычисляет выражение f=x^y.
#
#  in:
#    x>0  - основание в st(1)
#    y    - степень   в st(0)
#  out:
#    f    - результат в st(0)
#
#  -  finit не используется
#  -  Параметры из стека fpu выталкиваются - остается
#     результат
#  -  Всего используется 3 регистра st(i) - так что
#     кроме параметров нужно иметь в запасе, как минимум,
#     один регистр st(i) свободным (иначе - баг)
#  -  Никаких проверок на валидность параметров и
#     результатов операций
#  -  Функция относится к предыдущим значениям регистров cpu
#     в стиле WinAPI
#
##############################################################`

.386
.model flat, stdcall
option casemap:none

.code

fpu_pow proc uses esi edi

	LOCAL	cwr:WORD

	lea		esi,exit		;y>0
	ftst					;cmp y,0
	fstsw	ax
	sahf
	jz		y_equ_0			;if y=0
	jnc		y_above_0		;if y>0

y_below_0:

	lea		esi,div_it		;y<0
	fabs					;st(1) = x st(0) = |y|

y_above_0:

	fxch					;st(1) = y st(0) = x
	fyl2x					;st(0) = z  	; z = y*log2(x)
	fst		st(7)			;st(7) = z st(0) = z
	fdecstp					;st(1) = z st(0) = z
	fabs					;st(1) = z st(0) = |z|
	fld1					;st(2) = z st(1) = |z| st(0) = 1
	fxch					;st(2) = z st(1) = 1 st(0) = |z| 
	lea		edi,last_step	;|z|<=1
	fcompp					;cmp st(0),st(1) -> st(0) = z
	fstsw	ax
	sahf
	jc		abs_z_be_1		;if |z|<1
	jz		abs_z_be_1		;if |z|=1

abs_z_above_1:

	lea		edi,mul_it		;|z|>1
	fst		st(7)			;st(7) = z st(0) = z
	fdecstp					;st(1) = z st(0) = z
	fstcw	cwr
	or		cwr,0000110000000000b
	fldcw	cwr
	frndint					;st(1) = a.b st(0) = a.0   ; z = a.b
	fsub	st(1),st		;st(1) = 0.b st(0) = a.0
	fld1					;st(2) = 0.b st(1) = a.0 st(0) = 1
	fscale					;st(2) = 0.b st(1) = a.0 st(0) = 2^(a.0)
	fxch					;st(2) = 0.b st(1) = 2^(a.0) st(0) = a.0
	fincstp					;st(1) = 0.b st(0) = 2^(a.0)
	ffree	st(7)
	fxch					;st(1) = 2^(a.0) st(0) = 0.b

abs_z_be_1:

	f2xm1					;.. st(0) = 2^(0.b)-1      ; z = a.b
	fld1					;.. st(1) = 2^(0.b)-1 st(0) = 1
	fadd					;.. st(0) = 2^(0.b)
	jmp		edi

y_equ_0:

	fincstp					;pop y
	ffree	st(7)
	fincstp					;pop x
	ffree	st(7)
	fld1					;result is 1
	jmp		exit
	
mul_it:
							;st(1) = 2^(a.0) st(0) = 2^(0.b)
	fmul					;st(0) = 2^(a.b)

last_step:

	jmp		esi

div_it:

	fld1					;st(1) = 2^(a.b) st(0) = 1
	fxch					;st(1) = 1 st(0) = 2^(a.b)
	fdiv					;st(0) = 1 / 2^(a.b)

exit:

	ret

fpu_pow endp

end