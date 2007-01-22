#include "stdafx.h"
#include "stp_server.h"


// defaults
char def_resp_helo[] = "STPServer/0.1";

// sock
SOCKET sock;
char srv_name[200];

// window
char srv_class[] = "STPServer";
HWND hwnd;

// root dir
char *srv_root;


int error(int code)
{
	// show error message
	if (code)
		printe(code);
	else
		printf("stopped.\n");

	// handle this error by levels
	// level 1
	if (code > 502)
		closesocket(sock);
	// level 0
	WSACleanup();
	free(srv_root);

	return code;
}

bool is_dir(char *dir)
{
	int i = GetFileAttributes(dir);
	return
		i != INVALID_FILE_ATTRIBUTES &&
		( i & FILE_ATTRIBUTE_DIRECTORY ) == FILE_ATTRIBUTE_DIRECTORY;
}

void fix_dir(char *dir)
{
	char *c;
	while ( c = strchr(dir, '/') )
		*c = '\\';
}

LRESULT CALLBACK srv_proc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	if (uMsg == WM_SOCKET)
	{
		if (LOWORD(lParam) == FD_ACCEPT)
		{
			if (HIWORD(lParam) != NULL)
			{
				printe(506);
				return 0;
			}
			SOCKET s;
			if ( (s = accept(wParam, 0, 0)) == INVALID_SOCKET )
			{
				printe(507);
				return 0;
			}			 
			new CConnection(s, srv_root);
		}
	}
	else
		return DefWindowProc(hWnd, uMsg, wParam, lParam);

	return 0;
}

int main(int argc, char* argv[])
{
	// check & set root directory
	if (argc == 1)
		return error(500);
	if (!is_dir(argv[1]))
		return error(500);
	srv_root = (char*)malloc( strlen(argv[1]) + 1 + 1 );
	memcpy(srv_root, argv[1], strlen(argv[1]) + 1);
	if ( srv_root[ strlen(argv[1]) - 1 ] != '\\')
	{
		srv_root[ strlen(argv[1]) ] = '\\';
		srv_root[ strlen(argv[1]) + 1 ] = 0;
	}
	if (!SetCurrentDirectory(srv_root))
		return error(500);
	if ( srv_root[ strlen(srv_root) - 1 ] == '\\')
		srv_root[ strlen(srv_root) - 1 ] = 0;

	// init winsock
	WSADATA wsadata;
	if (WSAStartup(2, &wsadata))
		return error(501);

	// reg class & create fucking window
	WNDCLASSEX wc;
	memset(&wc, 0, sizeof(WNDCLASSEX));
	wc.cbSize = sizeof(WNDCLASSEX);
	HINSTANCE hinst = GetModuleHandle(0);
	wc.hInstance = hinst;
	wc.lpfnWndProc = srv_proc;
	wc.lpszClassName = srv_class;
	RegisterClassEx(&wc);
	hwnd = CreateWindowEx(0, srv_class, 0,0,0,0,0,0,0,0, hinst, 0);

	// open socket
	if ( (sock = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET )
		return error(502);

	// catching events
	if ( WSAAsyncSelect(sock, hwnd, WM_SOCKET, FD_ACCEPT|FD_READ) == SOCKET_ERROR)
		return error(503);

	// bind & listen
	sockaddr_in sin;
	sin.sin_family = AF_INET;
	sin.sin_port = htons(9001);
	sin.sin_addr.s_addr = inet_addr("0.0.0.0");
	if (bind(sock, (SOCKADDR*)&sin, sizeof(sin)) == SOCKET_ERROR)
		return error(504);
	if (listen(sock, 5) == SOCKET_ERROR)
		return error(505);


	// i'm ready
	gethostname(srv_name, 200);
	printf("%s at %s is ready. root = %s\n", wsadata.szDescription, srv_name, srv_root);

	
	// well known loop :)
	MSG msg;
	while (GetMessage(&msg, 0, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	// exit
	return error(0);
}

void Int64ToStr(INT64U x, char *s)
{
	bool first = true;
	INT64U mod = 10000000000000000000;
	char figure;

	for (int i=0; i<20; i++)
	{
		mod /= i ? 10 : 1;
		figure = (char)(x / mod);
		x -= figure * mod;
		if ( !first || (first && figure) || (first && i == 19) )
		{
			first = false;
			*s++ = figure + 0x30;
		}
	}

	*s = 0;
}