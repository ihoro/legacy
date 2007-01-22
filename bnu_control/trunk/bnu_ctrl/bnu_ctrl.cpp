#include "stdafx.h"
#include "bnu_ctrl.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// global engine object
CBCP2Engine *bcp;

// fonts structures
LOGFONT LF_MONOSPACE = {-12,0,0,0,400,0,0,0,-52,3,2,1,49,"Courier New"};						
LOGFONT LF_VERDANA7 = {-9,0,0,0,700,0,0,0,-52,3,2,1,34,"Verdana"};

// fonts
HFONT lfMonospace;
HFONT lfVerdana7;

// common dirs
char DIR_PROGRAM_ROOT[FILE_PATH_NAME_MAX_SIZE];

// ini-file
char INI_FILE_NAME[] = "\\bnu_ctrl.ini";


///////////////
// Cbnu_ctrlApp
///////////////

BEGIN_MESSAGE_MAP(Cbnu_ctrlApp, CWinApp)
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

// Cbnu_ctrlApp construction

Cbnu_ctrlApp::Cbnu_ctrlApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only Cbnu_ctrlApp object
Cbnu_ctrlApp theApp;


// Cbnu_ctrlApp initialization

BOOL Cbnu_ctrlApp::InitInstance()
{
	//InitCommonControls();

	// InitCommonControlsEx() is required on Windows XP if an application
	// manifest specifies use of ComCtl32.dll version 6 or later to enable
	// visual styles.  Otherwise, any window creation will fail.
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// Set this to include all the common control classes you want to use
	// in your application.
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinApp::InitInstance();

	//AfxEnableControlContainer();

	// program's root directory
	GetCurrentDirectory(FILE_PATH_NAME_MAX_SIZE, DIR_PROGRAM_ROOT);

	// set ini-file
	free((void*)m_pszProfileName);
	char *ini_file = new char[FILE_PATH_NAME_MAX_SIZE];
	ini_file[0] = 0;
	ini_file = strcat(ini_file, DIR_PROGRAM_ROOT);
	ini_file = strcat(ini_file, INI_FILE_NAME);
	m_pszProfileName=_tcsdup(ini_file);
	delete ini_file;

	// fonts
	lfMonospace = ::CreateFontIndirect(&LF_MONOSPACE);
	lfVerdana7 = ::CreateFontIndirect(&LF_VERDANA7);

	// BCP2 Engine
	bcp = new CBCP2Engine();

	Cbnu_ctrlDlg dlg;
	m_pMainWnd = &dlg;
	mdlg = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	/*
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
	*/

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}

int Cbnu_ctrlApp::ExitInstance()
{
	// free fonts
	::DeleteObject(lfMonospace);
	::DeleteObject(lfVerdana7);

	// free BCP2 Engine
	delete bcp;

	return CWinApp::ExitInstance();
}
