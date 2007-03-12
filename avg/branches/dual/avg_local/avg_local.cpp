#include "stdafx.h"
#include "avg_local.h"


// type info

LPTYPEINFO type_info;


/////////////////////////////////////////////////////
// refs debugging
/////////////////////////////////////////////////////

#ifdef REFS_DEBUG

	#include <stdio.h>

	HANDLE file;
	int cSet;

	void _init_debug(char *cline)
	{
		// get file path
		char fn[2*MAX_PATH + 1];		// 2* - more space - less headache :)
		GetModuleFileName(0, fn, MAX_PATH);
		strcpy(strstr(fn, ".exe"), "_debug.log");

		// create file
		file = CreateFile(fn, GENERIC_WRITE, FILE_SHARE_READ, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, 0);

		// set separator
		SetFilePointer(file, 0, 0, FILE_END);
		_trace_nl();
		for (int i=0; i<70; i++)
			_trace_sz("/");
		_trace_nl();
		_trace_sz("// new instance: ");
		_trace_sz(cline);
		_trace_nl();
		for (int i=0; i<70; i++)
			_trace_sz("/");
		_trace_nl();
		_trace_nl();
	}

	void _trace_sz(char *str)
	{
		WriteFile(file, str, (int)strlen(str), (LPDWORD)&cSet, 0);
	}

	void _trace_int(int i)
	{
		char buf[12];
		sprintf(buf, "%d", i);
		WriteFile(file, buf, (int)strlen(buf), (LPDWORD)&cSet, 0);
	}

	void _trace_nl()
	{
		char buf[] = "\r\n";
		WriteFile(file, buf, (int)strlen(buf), (LPDWORD)&cSet, 0);
	}

#endif


char *cmd_line;		// command line in lower-case
bool user = false;	// is it user's call of program
HWND hdlg;			// main dialog


/////////////////////////////////////////////////////
// server locks routines
/////////////////////////////////////////////////////

long svr_locks;

void locks_inc()
{
	INC(svr_locks);

#ifdef REFS_DEBUG

	_trace_sz("++ svr_locks = ");
	_trace_int(svr_locks);
	_trace_nl();

#endif

}

void locks_dec()
{
	DEC(svr_locks);

#ifdef REFS_DEBUG

	_trace_sz("-- svr_locks = ");
	_trace_int(svr_locks);
	_trace_nl();

#endif

	if (svr_locks == 0)
		PostQuitMessage(0);
}


/////////////////////////////////////////////////////
// object counting routines
/////////////////////////////////////////////////////

long obj_count;

void obj_inc()
{
	INC(obj_count);
}

void obj_dec()
{
	DEC(obj_count);
}

/////////////////////////////////////////////////////
// class factory
/////////////////////////////////////////////////////

CAverageClassFactory acf;
DWORD co_id;


/////////////////////////////////////////////////////
// (un)initialization
/////////////////////////////////////////////////////

inline void avg_initialize()
{
	// system
	CoInitialize(0);

	// register class object
	HRESULT hr = CoRegisterClassObject(CLSID_Average, (IUnknown*)&acf, CLSCTX_LOCAL_SERVER, REGCLS_MULTIPLEUSE, &co_id);
	if (FAILED(hr))
	{
		MessageBox(0, "Can't register class object.", "avg.exe", MB_OK|MB_ICONERROR);
		PostQuitMessage(1);
	}

	acf.Release();
}

inline void avg_uninitialize()
{
	// unregister class object
	CoRevokeClassObject(co_id);

	// system
	CoUninitialize();
}


/////////////////////////////////////////////////////
// main dialog
/////////////////////////////////////////////////////

void update_status()
{
	if (!user || !hdlg)
		return;

	SetDlgItemInt(hdlg, IDC_CLASS_OBJECT, acf.refs, true);
	SetDlgItemInt(hdlg, IDC_OBJECTS_COUNT, obj_count, true);
	SetDlgItemInt(hdlg, IDC_SERVER_LOCKS, svr_locks, true);
}

int __stdcall MainProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
	case WM_INITDIALOG:

		// set icon
		HICON hicon;
		hicon = LoadIcon(GetModuleHandle(0), (LPCTSTR)IDI_ICON);
		SendMessage(hwnd, WM_SETICON, ICON_BIG, (LPARAM)hicon);

		// set pos
		SetWindowPos(hwnd, 0, 10,10, 0,0, SWP_NOSIZE|SWP_NOZORDER);

		// some inits
		hdlg = hwnd;
		update_status();

		return true;

	case WM_CLOSE:

		EndDialog(hwnd, 0);
		return true;
	}

	return false;
}


/////////////////////////////////////////////////////
// entry point
/////////////////////////////////////////////////////

int __stdcall WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine,int nCmdShow)
{

#ifdef REFS_DEBUG
	_init_debug(lpCmdLine);
#endif

	// prepare command line
	cmd_line = (char*)malloc(strlen(lpCmdLine) + 1);
	strcpy(cmd_line, lpCmdLine);
	strlwr(cmd_line);

	// look for component registration
	if (avg_registration(cmd_line))
		return 0;

	avg_initialize();

	// is it user's call?
	if (!strstr(cmd_line, "embedding"))
	{
		locks_inc();
		user = true;
		DialogBoxParam(hInstance, (LPCSTR)IDD_MAIN, 0, MainProc, 0);
		hdlg = 0;
		locks_dec();
		user = (svr_locks == 0);
	}

	MSG msg;
	msg.wParam = 0;
	if (!user)
	{
		while (GetMessage(&msg, 0, 0, 0)) 
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	avg_uninitialize();

	// free command line
	free(cmd_line);

	return (int) msg.wParam;
}