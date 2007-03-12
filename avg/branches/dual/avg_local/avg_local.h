#pragma once


/////////////////////////////////////////////////////
// refs debugging
/////////////////////////////////////////////////////

#ifdef _DEBUG
	#define REFS_DEBUG
#endif

#ifdef REFS_DEBUG

	void _trace_sz(char*);
	void _trace_int(int);
	void _trace_nl();

#endif



#define INT8U unsigned char


// common tasks
void locks_inc();
void locks_dec();
void obj_inc();
void obj_dec();
void update_status();


// type info
extern LPTYPEINFO type_info;


// common (inc/dec)rementation style
#define INC(v) InterlockedIncrement(&(v)); update_status();
#define DEC(v) InterlockedDecrement(&(v)); update_status();


#include "resource.h"
#include "avg_reg.h"
#include "avg_interfaces.h"
#include "Average.h"
#include "AverageClassFactory.h"