.386
.model flat,c

.code

fp80to64 proc public fp80:DWORD, fp64:DWORD 

	mov		eax,fp80
	fld		tbyte ptr [eax]
	mov		eax,fp64
	fstp	qword ptr [eax]
	
	ret

fp80to64 endp


fp64to80 proc public fp64:DWORD, fp80:DWORD 

	mov		eax,fp64
	fld		qword ptr [eax]
	mov		eax,fp80
	fstp	tbyte ptr [eax]
	
	ret

fp64to80 endp

end