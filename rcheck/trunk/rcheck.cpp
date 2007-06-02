// $Id$

#include "stdafx.h"
#include "winsock2.h"
#include <string.h>
#include <stdlib.h>

#define WM_SOCKET WM_USER+100

SOCKET sock;

HWND hwnd;
char wnd_class[] = "CheckerClass";

#define buf_size 128*1024
char *buf = 0;
char *offset;

char *cmd;			// command line
char *command;		// what to run

int op = 1;

int p_dorval;
int p_nod;
bool speaker;
bool do_command;

bool problem;


void check_it()
{
	char *p = buf;

	// find table
	p = strstr(p, "<TABLE");
	if (!p)
		return;
	
	// shift to second row
	p = strstr(p+1, "<TR");
	if (!p) return;
	p = strstr(p+1, "<TR");
	if (!p) return;

	// shift to fourth/fifth column
	int column = (p_dorval != 0 && p_nod == 6) ? 5 : 4;
	for (int i=0; i < column; i++)
	{
		p = strstr(p+1, "<TD");
		if (!p) return;
	}

	// find end of column
	p = strstr(p+1, ">");
	if (!p) return;
	// find end of number
	char *e = strstr(p, "<");
	if (!e) return;

	*e = 0;
	int n = atoi(p+1);

	if (n)
		problem = true;
}

int send_req();
LRESULT __stdcall wnd_proc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	int got;
	bool end = false;

	if (uMsg == WM_SOCKET)
	{
		switch(LOWORD(lParam))
		{
		case FD_READ:
			got = recv(sock, offset, buf_size - (offset-buf), 0);
			offset += got;
			if (got==0)
				end = true;
			break;

		case FD_CLOSE:
			*offset = 0;
			end = true;
			break;
		}

		if (end)
		{
			shutdown(sock, SD_RECEIVE);
			closesocket(sock);
			check_it();
			op++;
			if (op > 2)
				PostQuitMessage(0);
			else
				if (send_req())
					PostQuitMessage(0);
		}
	}

	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}


int cmd_err()
{
	MessageBox(
		0,
		"Использование:\n"
		"  rcheck Дор Нод Спикер [команда]\n\n"
		"Дор = {0;32;35;40;43;45;48}, где 0 - УЗ\n"
		"Нод = {1;2;3;4;5;6}, где 6 - ВСЕ\n"
		"Cпикер = {0;1}, где 1 - подача сигнала на PC-Speaker\n"
		"команда - весь остаток строки (без каких-либо кавычек!)"
		, "rcheck",
		MB_OK|MB_ICONINFORMATION
		);
	return 1;
}


int send_req()
{
	if ( (sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == INVALID_SOCKET )
		return 1;

	sockaddr_in sin;
	sin.sin_family = AF_INET;
	sin.sin_port = htons(80);
	sin.sin_addr.s_addr = inet_addr("10.1.100.16");

	if (connect(sock, (SOCKADDR*)&sin, sizeof(sin)) == SOCKET_ERROR)
		return 2;

	if (WSAAsyncSelect(sock, hwnd, WM_SOCKET, FD_READ|FD_CLOSE) == SOCKET_ERROR)
		return 3;
	

	delete [] buf;
	buf = new char [buf_size];
	offset = buf;

	char req[] =
		"POST /pls/uzop/PKG_HTM_CTRL2.res_q HTTP/1.0\r\n"
		"Host: 10.1.100.16\r\n"
		"Pragma: no-cache\r\n"
		"Referer: http://10.1.100.16/pls/uzop/pkg_htm_CTRL2.form_r1\r\n"
		"Accept: */*\r\n"
		"User-Agent: Mozilla\r\n"
		"Content-Type: application/x-www-form-urlencoded\r\n"
		"Content-Length: 42\r\n"
		"\r\n"
		"p_dorval=??&"
		"p_nod=?&"
		"p_op=?&"
		"p_dt=??.??.????"
		;

	// set p_dorval
	char *p = req;
	p = strstr(p, "p_dorval=");
	if (p_dorval>0)
	{
		itoa(p_dorval, p+9, 10);
		*(p+9+2) = '&';
	}
	else
	{
		p[9+0] = 'У';
		p[9+1] = 'З';
	}


	// set p_nod
	p = strstr(p, "p_nod=");
	itoa(p_nod, p+6, 10);
	*(p+6+1) = '&';

	// set op
	p = strstr(p, "p_op=");
	itoa(op, p+5, 10);
	*(p+5+1) = '&';

	// set current date
	SYSTEMTIME st;
	GetLocalTime(&st);
	GetDateFormat(LOCALE_USER_DEFAULT, 0, &st, "dd.MM.yyyy", strstr(p, "p_dt=") + 5, 10);
	
	// send request
	send(sock, req, strlen(req), 0);
	shutdown(sock, SD_SEND);

	return 0;
}


int WinMain(HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPSTR lpCmdLine,
    int nCmdShow
)
{
	// parse command line
	// format:
	// Дор Нод Спикер(0/1) [command]

	#define iferr(p) if (!p) return cmd_err()

	cmd = new char [strlen(lpCmdLine)+1];
	strcpy(cmd, lpCmdLine);
	char *b = cmd;
	char *p = b;

	// Дор
	p = strstr(p, " ");
	iferr(p);
	*p = 0;
	p_dorval = atoi(b);
	if ( !(p_dorval>=0 && p_dorval<100) )
		return cmd_err();

	// Нод
	b = ++p;
	p = strstr(p, " ");
	iferr(p);
	p_nod = atoi(b);
	if ( !(p_nod>0 && p_nod<7) )
		return cmd_err();

	// Спикер
	b = ++p;
	p = strstr(p, " ");
	speaker = atoi(b);

	// команда
	if (p)
	{
		command = p+1;
		do_command = true;
	}

	#undef iferr

						  
	// init winsock
	WSADATA wsadata;
	WSAStartup(1, &wsadata);


	HINSTANCE hinstance = GetModuleHandle(0);
	WNDCLASSEX wc;
	memset(&wc, 0, sizeof(WNDCLASSEX));
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.hInstance = hinstance;
	wc.lpfnWndProc = wnd_proc;
	wc.lpszClassName = wnd_class;
	RegisterClassEx(&wc);

	hwnd = CreateWindowEx(0, wnd_class, 0,0,0,0,0,0,0,0, hinstance, 0);


	if (send_req())
		return 1;
	

	MSG msg;
	while (GetMessage(&msg, 0, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	WSACleanup();
						

	if (problem)
	{
		// use PC-speaker if need
		if (speaker)
			for (int j=0; j<3; j++)
				for (int i=0; i<100; i++)
					Beep(1000+20*i, i+1);

		// run command if need
		if (do_command)
		{
			STARTUPINFO si;
			PROCESS_INFORMATION pi;
			ZeroMemory( &si, sizeof(si) );
			si.cb = sizeof(si);
			ZeroMemory( &pi, sizeof(pi) );
			CreateProcess(0, command, 0, 0, 0, NORMAL_PRIORITY_CLASS, 0, 0, &si, &pi);
		}

		// show message
		char msg[] = "??.??.???? ??:??\nПроблемы!";
		SYSTEMTIME st;
		GetLocalTime(&st);
		GetDateFormat(LOCALE_USER_DEFAULT, 0, &st, "dd.MM.yyyy", msg, 10);
		msg[10] = ' ';
		GetTimeFormat(LOCALE_USER_DEFAULT, TIME_FORCE24HOURFORMAT, &st, "hh:mm", msg + 11, 5);
		msg[11+5] = '\n';
		MessageBox(0, msg, "rcheck", MB_OK|MB_ICONERROR);
	}


	delete [] cmd;
	delete [] buf;

	return 0;
}

