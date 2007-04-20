// $Id$

#include "stdafx.h"


void caesar_cc(void *p, unsigned int size, char key)
{
	unsigned int i;
	for (i=0; i<size; i++)
		((char*)p) [i] += key;
}


void caesar_encode(void *p, unsigned int size, char key)
{
	caesar_cc(p, size, key);
}


void caesar_decode(void *p, unsigned int size, char key)
{
	caesar_cc(p, size, -key);
}

