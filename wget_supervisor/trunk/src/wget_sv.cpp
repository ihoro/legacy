// $Id$

#include "stdafx.h"
#include "wget_sv.h"


// configuration
////////////////

// load defined configuration
#include "default.conf"

// wget
TCHAR *WGET_DIR;
TCHAR WGET_DIR_LAST[] = _T(conf_wget_dir);
TCHAR *WGET_PATH;
TCHAR WGET_FILENAME[] = _T("\\") _T(conf_wget_filename);
TCHAR WGET_DIR_PREFIX_FIRST[] = _T(" -P \"");
TCHAR WGET_DIR_PREFIX_LAST[] = _T(conf_wget_dir_prefix) _T("\"");
TCHAR *WGET_ARGS;
TCHAR WGET_ARGS_LAST[] =		// with first and last space
		_T(" -a ")		_T(conf_wget_logfile)						\
		_T(" ")			_T(conf_wget_args)			_T(" ")
		;

// file of URLs list
int URLS_TIME = conf_urls_time;
TCHAR URLS_PATH[] = _T(conf_urls_path);

// active URLs
int AURLS_MAX_COUNT = 2;	// maximum number of active URLs (i.e. concurrent downloads)



// one record for one active URL (it can be already done)
/////////////////////////////////////////////////////////

struct ACTIVE_URL
{
	TCHAR *url;		// actually it's WGET_ARGS + URL
	DWORD pID;		// process ID
	bool done;		// true if this URL has been downloaded
};

// active URLs
ACTIVE_URL *aurl;	// array of active URLs
int aurl_count;		// items count in array
int aurl_undone;	// really active URLs

// directories
TCHAR sys_dir[MAX_PATH];


DWORD __stdcall wait_for_downloading(LPVOID lp)
{
	#define au (*(ACTIVE_URL*)lp)

	// get process handle
	HANDLE ph = OpenProcess(SYNCHRONIZE, FALSE, au.pID);

	// wait for process
	WaitForSingleObject(ph, INFINITE);
	CloseHandle(ph);

	// mark this download as done
	au.done = true;
	au.pID = 0;
										  
	return 0;

	#undef au
}


DWORD find_process_id()
{
	DWORD *pid = new DWORD [2048];
	DWORD cbNeeded, pc;
	DWORD fid = 0;	// found ID

	EnumProcesses(pid, sizeof(DWORD)*2048, &cbNeeded);
	pc = cbNeeded/sizeof(DWORD);	// processes count

	// find new pid
	HANDLE ph;
	TCHAR *path = new TCHAR [MAX_PATH];
	for (DWORD i=1; i<pc; i++)
		if ( ph = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, pid[i]) )  
		{
			path[0] = 0;
			GetModuleFileNameEx(ph, 0, path, MAX_PATH);

			// if it's wget then check ID
			if ( _tcscmp(path, WGET_PATH) == 0 )
				for (int j=0; j<aurl_count; j++)
					if (pid[i] == aurl[j].pID)
						break;
					else if (j == aurl_count-1)
						fid = pid[i];

			// if found it
			if (fid)
				break;
		}

	delete [] pid;
	delete [] path;

	return fid;
}


void __stdcall reload_url_list(HWND hwnd, UINT uMsg, UINT_PTR idEvent, DWORD dwTime)
{
	// refresh count of done URLs
	/////////////////////////////
	int i;
	aurl_undone = 0;
	for (i=0; i<aurl_count; i++)
		if ( !aurl[i].done )
			aurl_undone++;


	// try to open file of URLs
	///////////////////////////

	HANDLE hf = CreateFile(URLS_PATH, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0);
	if (hf == INVALID_HANDLE_VALUE)
		return;
	int fsize = GetFileSize(hf, 0);

	HANDLE hMap = CreateFileMapping(hf, 0, PAGE_READONLY, 0, 0, 0);
	if (hMap == NULL)
	{
		CloseHandle(hf);
		return;
	}

	void *pMem = MapViewOfFile(hMap, FILE_MAP_READ, 0, 0, 0);
	if (pMem == NULL)
	{
		CloseHandle(hMap);
		CloseHandle(hf);
	}


	// read and decode each line
	////////////////////////////

	char *p = (char*)pMem;
	char *pbase = p;
	for (; p-(char*)pMem < fsize; p++)
	{
		// check active URLs count
		if (aurl_undone >= AURLS_MAX_COUNT)
			break;

		// if found end of line
		if (*(short*)p == 0x0A0D)
		{
			int line_len = (int)(p - pbase);

			// copy and decode line
			char *line = new char [line_len];
			memcpy(line, pbase, line_len);
			caesar_decode(line, line_len, (char)conf_caesar_key);

			// first part: add wget args to url
			TCHAR *url = new TCHAR [ _tcslen(WGET_ARGS) + line_len + 1 ];
			url[0] = 0;
			_tcscat(url, WGET_ARGS);

			// second part: add url itself
			TCHAR *url_itself = url + _tcslen(WGET_ARGS);
			for (i=0; i<line_len; i++)
				url_itself[i] = (TCHAR)line[i];
			url_itself[i] = 0;
			delete [] line;

			// set new base and offset for the next line
			p += 2;
			pbase = p;

			// check if it's already active URL
			bool new_url = true;
			for (i=0; i<aurl_count; i++)
				if ( _tcscmp(aurl[i].url, url) == 0)
				{
					new_url = false;
					break;
				}

			// if it's not new then look for the next line
			if (!new_url)
			{
				 delete [] url;
				 continue;
			}

			// start new process to download it...
			STARTUPINFO si;
			PROCESS_INFORMATION pi;
			ZeroMemory( &si, sizeof(si) );
			si.cb = sizeof(si);
			ZeroMemory( &pi, sizeof(pi) );

			if ( CreateProcess(WGET_PATH, url,
							   NULL, NULL, FALSE,
							   CREATE_NO_WINDOW | NORMAL_PRIORITY_CLASS,
							   NULL,
							   WGET_DIR,
							   &si, &pi) )
			{
				// remember this URL as active
				aurl_count++;
				aurl = (ACTIVE_URL*)realloc(aurl, sizeof(ACTIVE_URL)*aurl_count);
				aurl[aurl_count-1].url = url;
				aurl[aurl_count-1].done = false;

				// wait just some time ;)
				WaitForSingleObject(pi.hProcess, INFINITE);
				CloseHandle(pi.hThread);
				CloseHandle(pi.hProcess);

				// get process ID
				aurl[aurl_count-1].pID = find_process_id();

				// new undone URL
				aurl_undone++;

				// start to wait for process' termination
				DWORD thread_id;
				CreateThread(0, 0, wait_for_downloading, (LPVOID)(aurl + aurl_count - 1), 0, &thread_id);
			}
			else
				// free this URL
				delete [] url;
		}
	}

	// close file
	/////////////

	UnmapViewOfFile(pMem);
	CloseHandle(hMap);
	CloseHandle(hf);
}
				  
	 
int __stdcall _tWinMain(HINSTANCE hInstance,
				        HINSTANCE hPrevInstance,
					    LPTSTR    lpCmdLine,
						int       nCmdShow)
{
	// get system directory
	SHGetFolderPath(0, CSIDL_SYSTEM, 0, 0, sys_dir);

	// get wget dir
	WGET_DIR = new TCHAR [ _tcslen(sys_dir) + _tcslen(WGET_DIR_LAST) + 1 ];
	WGET_DIR[0] = 0;
	_tcscat(WGET_DIR, sys_dir);
	_tcscat(WGET_DIR, WGET_DIR_LAST);

	// get wget path
	WGET_PATH = new TCHAR [ _tcslen(WGET_DIR) + _tcslen(WGET_FILENAME) + 1 ];
	WGET_PATH[0] = 0;
	_tcscat(WGET_PATH, WGET_DIR);
	_tcscat(WGET_PATH, WGET_FILENAME);

	// get full args string
	WGET_ARGS = new TCHAR	[
							_tcslen(WGET_DIR_PREFIX_FIRST) +
							_tcslen(sys_dir) +
							_tcslen(WGET_DIR_PREFIX_LAST) +
							_tcslen(WGET_ARGS_LAST) +
							1
							];
	WGET_ARGS[0] = 0;
	_tcscat(WGET_ARGS, WGET_DIR_PREFIX_FIRST);
	_tcscat(WGET_ARGS, sys_dir);
	_tcscat(WGET_ARGS, WGET_DIR_PREFIX_LAST);
	_tcscat(WGET_ARGS, WGET_ARGS_LAST);

	
	// set timer to reread URLs list from file
	SetTimer(NULL, 0, URLS_TIME*1000, reload_url_list);


	// Main message loop:
	MSG msg;
	while (GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return (int) msg.wParam;
}