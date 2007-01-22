// stp_client.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "stp_client.h"
#include "stp_clientDlg.h"
#include ".\stp_client.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// Cstp_clientApp

BEGIN_MESSAGE_MAP(Cstp_clientApp, CWinApp)
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()


// Cstp_clientApp construction

Cstp_clientApp::Cstp_clientApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only Cstp_clientApp object

Cstp_clientApp theApp;


// Cstp_clientApp initialization

BOOL Cstp_clientApp::InitInstance()
{
	WSADATA wsadata;
	if (WSAStartup(2, &wsadata))
		return false;

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



	Cstp_clientDlg dlg;
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

int Cstp_clientApp::ExitInstance()
{
	WSACleanup();

	return CWinApp::ExitInstance();
}
