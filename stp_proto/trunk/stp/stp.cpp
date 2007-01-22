#include "stdafx.h"


// TODO: hey, throw it into bioreactor!
// TODO: try to do more intelligence error handlers, plz ;)


#define INT64U unsigned long long

// defaults
#define WM_SOCKET			WM_USER+100
#define NVT_LINE_MAX_SIZE	1000+2
#define CMD_LINE_MAX_SIZE	1000

char def_helo[] = "HELO STPClient/0.1";

// sock
SOCKET sock = 0;
SOCKET sock1;
SOCKET sock1_con;

// window
char wnd_class[] = "STPClient";
HWND hwnd;

// commands
enum COMMAND
{
	CMD_NONE,
	CMD_HELP,
	CMD_OPEN,
	CMD_CLOSE,
	CMD_EXIT,
	CMD_HELO,
	CMD_PWD,
	CMD_CD,
	CMD_LS,
	CMD_LCD,
	CMD_PORT,
	CMD_GET,
	CMD_PUT
};

// thread
HANDLE waiting_for_response;
int thread_id;

// commands
COMMAND cmd_cur = CMD_NONE;
COMMAND cmd_after_port = CMD_NONE;
char *cmd_ready = 0;
int x;

// dir
char cur_dir[CMD_LINE_MAX_SIZE];

// file transfer
char *file_name;
HANDLE file;
#define FILE_BUF_SIZE 30*1024
char file_buf[FILE_BUF_SIZE];
INT64U file_size;

// local host
sockaddr_in host_sin;


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

void send_it(char *s)
{
	char *b = (char*)malloc(strlen(s) + 2 + 1);
	sprintf(b, "%s\r\n", s);
	send(sock, b, strlen(b), 0);
	free(b);
}

void handle_port_error()
{
	printf("PORT command error.\n");
	closesocket(sock1);
	CloseHandle(file);
	DeleteFile(file_name);
	cmd_cur = CMD_NONE;
	SetEvent(waiting_for_response);
}

LRESULT CALLBACK wnd_proc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	if (uMsg == WM_SOCKET)
	{
		////////////////////////////////////////////////////////////
		// sock events
		////////////////////////////////////////////////////////////

		if (wParam == sock)

			switch (LOWORD(lParam))
			{

			////////////////////////////////////////////////////////////
			case FD_CONNECT:

				if (HIWORD(lParam) != NULL)
				{
					closesocket(sock);
					sock = 0;
					printf("Connection error.\n");
					SetEvent(waiting_for_response);
					return 0;
				}
				printf("Connected.\n");
				send_it(def_helo);
				cmd_cur = CMD_HELO;

				// remember info
				int i;
				i = sizeof(host_sin);
				getsockname(sock, (SOCKADDR*)&host_sin, &i);

				break;

			////////////////////////////////////////////////////////////
			case FD_CLOSE:

				printf("\nConnection has been closed by peer.\n");
				closesocket(sock);
				sock = 0;

				break;

			////////////////////////////////////////////////////////////
			case FD_READ:

				char buf[1460];

				int count = recv(sock, buf, NVT_LINE_MAX_SIZE, 0);
				buf[count] = 0;
				printf(buf);

				// process or finish command
				switch (cmd_cur)
				{

				case CMD_HELO:
				case CMD_PWD:
				case CMD_CD:

					cmd_cur = CMD_NONE;
					SetEvent(waiting_for_response);

					break;

				case CMD_LS:

					char *c;
					c = buf;
					while (*c && x != 0x0D0A0D0A)
						x = (x << 8) | (unsigned int)*c++;

					if (x == 0x0D0A0D0A)
					{
						cmd_cur = CMD_NONE;
						SetEvent(waiting_for_response);
					}

					break;

				case CMD_PORT:

					if (strstr(buf, "200 ") != buf)
					{
						handle_port_error();
						break;
					}

					cmd_cur = cmd_after_port;
					send_it(cmd_ready);

					break;

				case CMD_GET:

					if (strstr(buf, "251 ") != buf)
					{
						closesocket(sock1_con);
						closesocket(sock1);
						CloseHandle(file);
						DeleteFile(file_name);
						cmd_cur = CMD_NONE;
						SetEvent(waiting_for_response);
					}

					break;
				}

				break;
			}

		////////////////////////////////////////////////////////////
		// sock1 events
		////////////////////////////////////////////////////////////

		else if (wParam == sock1)

			switch (LOWORD(lParam))
			{

			////////////////////////////////////////////////////////////
			case FD_ACCEPT:

				// TODO: check ip, etc - kill yourself and use FTP. ÀÃÑËing plagiary??? ;)

				if
				(
					HIWORD(lParam) != NULL ||
					(sock1_con = accept(wParam, 0, 0)) == INVALID_SOCKET
				)
				{
					handle_port_error();
					break;
				}

				WSAAsyncSelect(sock1_con, hwnd, WM_SOCKET, FD_READ|FD_CLOSE);
				
				break;

			}

		////////////////////////////////////////////////////////////
		// sock1_con events
		////////////////////////////////////////////////////////////

		else if (wParam == sock1_con)

			switch (LOWORD(lParam))
			{

			////////////////////////////////////////////////////////////
			case FD_READ:

				// TODO: is there only get command?
				int count;
				count = recv(sock1_con, file_buf, FILE_BUF_SIZE, 0);
				int cSet;
				if (count > 0)
					WriteFile(file, file_buf, count, (LPDWORD)&cSet, 0);

				file_size += count;

				break;

			////////////////////////////////////////////////////////////
			case FD_CLOSE:

				//shutdown(sock1, SD_RECEIVE);
				
				do
				{
					count = recv(sock1_con, file_buf, FILE_BUF_SIZE, 0);
					int cSet;
					if (count > 0)
					{
						WriteFile(file, file_buf, count, (LPDWORD)&cSet, 0);
						file_size += count;
					}
				}
				while ( !(count == 0 || count == SOCKET_ERROR) );				

				closesocket(sock1_con);
				closesocket(sock1);
				CloseHandle(file);
				
				char tmp[21];
				Int64ToStr(file_size, tmp);
				printf("%s", tmp);
				printf(" byte(s) done.\n");

				cmd_cur = CMD_NONE;
				SetEvent(waiting_for_response);

				break;
			}
	}
	else

		return DefWindowProc(hWnd, uMsg, wParam, lParam);
	
	return 0;
}

COMMAND recognize_command(char *s)
{

	#define IS(str)	strstr(s,str) == s

	if ( IS("help") )
		return CMD_HELP;

	else if ( IS("open ") )
		return CMD_OPEN;

	else if ( IS("close") )
		return CMD_CLOSE;

	else if ( IS("exit") || IS("bye") || IS("by") )
		return CMD_EXIT;

	else if ( IS("pwd") )
		return CMD_PWD;

	else if ( IS("cd ") )
		return CMD_CD;

	else if ( IS("ls") )
		return CMD_LS;

	else if ( IS("lcd") )
		return CMD_LCD;

	else if ( IS("get ") )
		return CMD_GET;

	#undef IS
	
	return CMD_NONE;
}

bool is_connected()
{
	if (!sock)
	{
		printf("Try to connect first :)\n");
		return false;
	}

	return true;
}

void set_command(COMMAND c)
{
	cmd_cur = c;
	ResetEvent(waiting_for_response);

	// some inits
	switch (c)
	{
	case CMD_LS:
		x = 0;
		break;
	}
}

DWORD WINAPI thread_proc(LPVOID lpParameter)
{
	char *cmd = new char[CMD_LINE_MAX_SIZE + 1];
	char *c;
	bool working = true;

	char *tmp;
	sockaddr_in sin;

	do
	{
		// can we request for command?
		while (WaitForSingleObject(waiting_for_response,INFINITE) != WAIT_OBJECT_0);

		// wait a command
		printf(">");
		c = cmd;
		while ( (*c++ = (char)getch()) != '\r' )
			if ( *(c-1) == '\b' )
				if ( c > cmd+1 )
				{
					putch('\b');
					putch(' ');
					putch('\b');
					c -= 2;
				}
				else
					c--;
			else if (c > cmd + CMD_LINE_MAX_SIZE)
			{
				cmd[CMD_LINE_MAX_SIZE] = 0;
				break;
			}
			else
				putch(*(c-1));
		*(c-1) = 0;
		printf("\n");

		// look for command
		switch (recognize_command(cmd))
		{

		////////////////////////////////////////////////////////////
		// none
		////////////////////////////////////////////////////////////

		case CMD_NONE:

			printf("No such command.\n");
			break;

		////////////////////////////////////////////////////////////
		// help
		////////////////////////////////////////////////////////////

		case CMD_HELP:

			printf
			(
				"open - create connection to STP server\n"			\
				"close - close current connection\n"				\
				"exit/bye/by - program exit\n"						\
				"pwd - print work directory\n"						\
				"cd - change work directory\n"						\
				"ls - list files of current directory\n"			\
				"lcd - change/show local directory\n"				\
				"get - download remote file\n"
			);
			break;

		////////////////////////////////////////////////////////////
		// open
		////////////////////////////////////////////////////////////

		case CMD_OPEN:

			// if connection exists yet
			if (sock)
			{
				printf("Close current connection first.\n");
				break;
			}

			// check for address
			if (strlen(cmd) <= 5)
			{
				printf("Undefined host.\n");
				break;
			}

			// try to resolve address
			addrinfo *ai, ai_hints;
			ai = 0;

			memset(&ai_hints, 0, sizeof(ai_hints));
			ai_hints.ai_family = AF_INET;
			ai_hints.ai_socktype = SOCK_STREAM;
			ai_hints.ai_protocol = IPPROTO_TCP;

			if ( getaddrinfo(cmd+5, 0, &ai_hints, &ai) != 0 )
			{
				printf("Can't find such address.\n");
				break;
			}

			// open socket
			sock = socket(AF_INET, SOCK_STREAM, 0);

			// catching events
			WSAAsyncSelect(sock, hwnd, WM_SOCKET, FD_CONNECT|FD_READ|FD_CLOSE);

			// just info
			cmd = inet_ntoa(((sockaddr_in*)ai->ai_addr)->sin_addr);
			printf("Connecting to %s...\n", cmd);

			// try to connect
			sin.sin_family = AF_INET;
			sin.sin_port = htons(9001);
			sin.sin_addr = ((sockaddr_in*)ai->ai_addr)->sin_addr;
			ResetEvent(waiting_for_response);
			connect(sock, (SOCKADDR*)&sin, sizeof(sin));

			freeaddrinfo(ai);

			break;

		////////////////////////////////////////////////////////////
		// close
		////////////////////////////////////////////////////////////

		case CMD_CLOSE:

			if (is_connected())
			{
				closesocket(sock);
				sock = 0;
				printf("Disconnected.\n");
			}

			break;

		////////////////////////////////////////////////////////////
		// exit
		////////////////////////////////////////////////////////////

		case CMD_EXIT:

			if (sock)
				closesocket(sock);

			PostMessage(hwnd, WM_QUIT, 0, 0);
			working = false;

			break;

		////////////////////////////////////////////////////////////
		// pwd
		////////////////////////////////////////////////////////////

		case CMD_PWD:

			if (!is_connected())
				break;

			set_command(CMD_PWD);
			send_it("PWD ");

			break;

		////////////////////////////////////////////////////////////
		// cd
		////////////////////////////////////////////////////////////

		case CMD_CD:

			if (!is_connected())
				break;

			// form request
			tmp = new char[strlen(cmd) + 1 + 1];
			*(int*)tmp = 0x20445743;
			tmp[4] = 0;
			strcat(tmp, cmd+3);
			
			// send request
			set_command(CMD_CD);
			send_it(tmp);

			delete [] tmp;

			break;

		////////////////////////////////////////////////////////////
		// ls
		////////////////////////////////////////////////////////////

		case CMD_LS:

			if (!is_connected())
				break;

			set_command(CMD_LS);

			// if parameter exists
			if (strlen(cmd) > 3)
			{
				// form request
				tmp = new char[strlen(cmd) + 2 + 1];
				*(int*)tmp = 0x5453494C;
				*(int*)(tmp+4) = 0x00000020;
				strcat(tmp, cmd+3);
				
				// send request
				send_it(tmp);

				delete [] tmp;
			}
			else
				send_it("LIST");
        
			break;

		////////////////////////////////////////////////////////////
		// lcd
		////////////////////////////////////////////////////////////

		case CMD_LCD:

			if (strlen(cmd) == 3)
			{
				printf("%s\n", cur_dir);
				break;
			}

			if (!SetCurrentDirectory(cmd + 4))
			{
				printf("Can't change local directory.\n");
				break;
			}

			GetCurrentDirectory(CMD_LINE_MAX_SIZE, cur_dir);
			printf("%s\n", cur_dir);

			break;

		////////////////////////////////////////////////////////////
		// get
		////////////////////////////////////////////////////////////

		case CMD_GET:

			// some checks
			if (!is_connected())
				break;
			if (strlen(cmd) < 5)
			{
				printf("Undefined file name.\n");
				break;
			}


			// try to create local file
			///////////////////////////

			file_name = cmd + 4;
			file = CreateFile(file_name,
							  GENERIC_WRITE,
							  FILE_SHARE_READ,
							  0,
							  CREATE_NEW,					// it's for care
							  FILE_ATTRIBUTE_ARCHIVE,
							  0);
			if (file == INVALID_HANDLE_VALUE)
			{
				printf("Can't create local file.\n");
				break;
			}


			// prepare future GET command
			/////////////////////////////

			if (cmd_ready)
				free(cmd_ready);
			cmd_ready = (char*)malloc(strlen(cmd) + 1);
			memcpy(cmd_ready, cmd, strlen(cmd) + 1);
			*(int*)cmd_ready = 0x20544547;


			// prepare new socket
			/////////////////////

			// open socket
			sock1 = socket(AF_INET, SOCK_STREAM, 0);

			// catching events
			WSAAsyncSelect(sock1, hwnd, WM_SOCKET, FD_ACCEPT);

			// bind & listen
			sin.sin_family = AF_INET;
			sin.sin_port = 0;
			sin.sin_addr.s_addr = inet_addr("0.0.0.0");
			bind(sock1, (SOCKADDR*)&sin, sizeof(sin));
			listen(sock1, 1);


			// prepare PORT command
			///////////////////////

			int i = sizeof(sin);
			getsockname(sock1, (SOCKADDR*)&sin, &i);
			tmp = (char*)malloc(29);
			*tmp = 0;
			strcat(tmp, "PORT ");
			char *pos = tmp + 5;
			// ip
			for (int j=0; j<4; j++)
			{
				sprintf(pos, "%lu,", (host_sin.sin_addr.s_addr >> j*8) & 0xFF );
				pos += strlen(pos);
			}
			// port
			sprintf(pos, "%lu,%lu", sin.sin_port & 0xFF, (sin.sin_port & 0xFF00) >> 8);


			// send PORT command and wait for request
			/////////////////////////////////////////

			set_command(CMD_PORT);
			cmd_after_port = CMD_GET;
			file_size = 0;
			send_it(tmp);
			free(tmp);
        
			break;

		} // look for command
	}
	while (working);

	delete [] cmd;

	return 0;
}

int main(int argc, char* argv[])
{
	GetCurrentDirectory(CMD_LINE_MAX_SIZE, cur_dir);

	// just info
	printf("Stupid Transfer Protocol. STPClient v0.1 by ******* 'at' gmail.com\n" \
		   "ATT: stinky shit is near :) so, be careful. you did?!\n");

	// init winsock
	WSADATA wsadata;
	WSAStartup(2, &wsadata);

	// reg class & create fucking window
	WNDCLASSEX wc;
	memset(&wc, 0, sizeof(WNDCLASSEX));
	wc.cbSize = sizeof(WNDCLASSEX);
	HINSTANCE hinst = GetModuleHandle(0);
	wc.hInstance = hinst;
	wc.lpfnWndProc = wnd_proc;
	wc.lpszClassName = wnd_class;
	RegisterClassEx(&wc);
	hwnd = CreateWindowEx(0, wnd_class, 0,0,0,0,0,0,0,0, hinst, 0);

	// create interface thread
	waiting_for_response = CreateEvent(0, true, true, 0);
	CreateThread(0, 0, thread_proc, 0, 0, (LPDWORD)&thread_id);

	// well known loop :)
	MSG msg;
	while (GetMessage(&msg, 0, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	CloseHandle(waiting_for_response);
	WSACleanup();

	return 0;
}