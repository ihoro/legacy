// avg_client.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "avg_client.h"
#include "avg_clientDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// Cavg_clientApp

BEGIN_MESSAGE_MAP(Cavg_clientApp, CWinApp)
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()


// Cavg_clientApp construction

Cavg_clientApp::Cavg_clientApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only Cavg_clientApp object

Cavg_clientApp theApp;


// Cavg_clientApp initialization

BOOL Cavg_clientApp::InitInstance()
{
	CoInitialize(0);

	// InitCommonControls() is required on Windows XP if an application
	// manifest specifies use of ComCtl32.dll version 6 or later to enable
	// visual styles.  Otherwise, any window creation will fail.
	InitCommonControls();

	CWinApp::InitInstance();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	// of your final executable, you should remove from the following
	// the specific initialization routines you do not need
	// Change the registry key under which our settings are stored
	// TODO: You should modify this string to be something appropriate
	// such as the name of your company or organization
	//SetRegistryKey(_T("Local AppWizard-Generated Applications"));

	Cavg_clientDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}

int Cavg_clientApp::ExitInstance()
{
	CoUninitialize();

	return CWinApp::ExitInstance();
}
