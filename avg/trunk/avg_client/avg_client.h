// avg_client.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols


// Cavg_clientApp:
// See avg_client.cpp for the implementation of this class
//

class Cavg_clientApp : public CWinApp
{
public:
	Cavg_clientApp();

// Overrides
	public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
	virtual int ExitInstance();
};

extern Cavg_clientApp theApp;