// stp_client.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols


// Cstp_clientApp:
// See stp_client.cpp for the implementation of this class
//

class Cstp_clientApp : public CWinApp
{
public:
	Cstp_clientApp();

// Overrides
	public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
	virtual int ExitInstance();
};

extern Cstp_clientApp theApp;