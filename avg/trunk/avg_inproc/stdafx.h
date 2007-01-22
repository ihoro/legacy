// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once


#define WIN32_LEAN_AND_MEAN		// Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#include <windows.h>
#include <unknwn.h>
#include <olectl.h>
#include <objbase.h>

// TODO: reference additional headers your program requires here
#define INT8U unsigned char
#include "avg.h"
#include "interface.h"
#include "AverageClassFactory.h"
#include "Average.h"