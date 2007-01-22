#pragma once


#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

// whole project headers
#include "resource.h"				// main res symbols
#include "str_routines.h"
#include "grid_routines.h"
#include "bcp2engine.h"				// protocol engine
#include "bnu_ctrlDlg.h"			// main dialog


// math
#define PI			3.1415926538
#define	XCHG(a,b)	b=b-a, a=a+b, b=a-b;

// global BCP2Engine object pointer
extern CBCP2Engine *bcp;

// some useful fonts
extern HFONT lfMonospace;
extern HFONT lfVerdana7;

// common dirs
extern char DIR_PROGRAM_ROOT[];

// used by load_ini() functions for loading window position
#define DEF_XY	-999999


// Cbnu_ctrlApp
///////////////

class Cbnu_ctrlApp : public CWinApp
{
public:
	Cbnu_ctrlApp();

// Overrides
	public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
	virtual int ExitInstance();
};

// itself
extern Cbnu_ctrlApp theApp;