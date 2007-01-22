#include "stdafx.h"
#include "stp_server.h"


// window stuff
///////////////

HINSTANCE hinstance;
bool wnd_class_reged = false;
char wnd_class[] = "STPConnection";

#define IF_ERROR(code)									\
			if (HIWORD(lParam) != NULL)					\
				printe(code)							

#define IF_ERROR_THEN_BREAK(code)						\
			if (HIWORD(lParam) != NULL)					\
				{										\
					printe(code);						\
					break;								\
				}											

LRESULT CALLBACK wnd_proc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	if (uMsg == WM_SOCKET)
	{
		CConnection *c = (CConnection*)GetWindowLongPtr(hWnd, GWLP_USERDATA);

		switch (LOWORD(lParam))
		{
		case FD_CONNECT:
			if (HIWORD(lParam) != NULL)
			{
				closesocket(c->sock1);
				c->sock1 = 0;
				c->send_err(455);
				break;
			}
			c->send_msg(200, "PORT command successful.");
			break;

		case FD_READ:					// TODO: put mode!
			IF_ERROR_THEN_BREAK(403);
			if (wParam == c->sock)
				c->read();
			break;

		case FD_CLOSE:
			//IF_ERROR(404);		//WSAENETDOWN  WSAECONNRESET  WSAECONNABORTED
			if (wParam == c->sock)
				c->close();
			break;
		}
	}
	else
		return DefWindowProc(hWnd, uMsg, wParam, lParam);

	return 0;
}


DWORD CALLBACK get_thread_proc(LPVOID lpParameter)
{

#define con (*(CConnection*)lpParameter)
	
	OVERLAPPED ovr;
	memset(&ovr, 0, sizeof(ovr));
	ovr.hEvent = CreateEvent(0, false, false, 0);

	// TODO: and what about big files? about 2 GBytes? ¿√—À???

	// send entire file
	if (TransmitFile(con.sock1, con.get_file, 0, 0, &ovr, 0, TF_USE_KERNEL_APC) == 0)
		if (GetLastError() == ERROR_IO_PENDING)
			WaitForSingleObject(ovr.hEvent, INFINITE);

	// close connection
	shutdown(con.sock1, SD_SEND);
    closesocket(con.sock1);
	con.sock1 = 0;

	// close file
	CloseHandle(con.get_file);

	CloseHandle(ovr.hEvent);

	return 0;

#undef con

}



// CConnection
//////////////

#define SEND(v1,v2,v3,v4)								\
			if (send(v1, v2, v3, v4) == SOCKET_ERROR)	\
				printe(407);

CConnection::CConnection(SOCKET s, char *chroot)
{
	// socket
	sock = s;
	sock1 = 0;

	// it needs to have their own 'root dir' string
	dir_root_len = strlen(chroot);
	dir_root = (char*)malloc(dir_root_len + 1);
	*dir_root = 0;
	strcpy(dir_root, chroot);

	// buffer
	buf_data_len = 0;

	// init current directory
	dir_cur = (char*)malloc(2);
	*(short*)dir_cur = 0x002F;

	// set up this connection for further work
	reg_wnd_class();
	hwnd = 0;	// for destructor
	hwnd = CreateWindowEx(0, wnd_class, 0,0,0,0,0,0,0,0, hinstance, 0);
	SetWindowLongPtr(hwnd, GWLP_USERDATA, (LONG_PTR)this);
	if ( WSAAsyncSelect(sock, hwnd, WM_SOCKET, FD_READ|FD_CLOSE) == SOCKET_ERROR)
	{
		printe(401);
		delete this;
	}

	// get ip
	sockaddr_in sin;
	int sin_size = sizeof(sin);
	if (getpeername(sock, (SOCKADDR*)&sin, &sin_size) == SOCKET_ERROR)
	{
		client_ip[0] = '?';
		client_ip[1] = 0;
		printe(406);
	}
	else
	{
		char *cip = inet_ntoa(sin.sin_addr);
		strcpy(client_ip, cip);
	}

	// there is new one!
	printf("%s: connected\n", client_ip);
}

CConnection::~CConnection()
{
	// free mem
	free(dir_root);
	free(dir_cur);

	// kill window
	if (hwnd)
		DestroyWindow(hwnd);

	// free sock
	if (sock)
		closesocket(sock);
}

void CConnection::reg_wnd_class()
{
	if (wnd_class_reged)
		return;

	// register window class
	hinstance = GetModuleHandle(0);
	WNDCLASSEX wc;
	memset(&wc, 0, sizeof(WNDCLASSEX));
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.cbWndExtra = sizeof(CConnection*);
	wc.hInstance = hinstance;
	wc.lpfnWndProc = wnd_proc;
	wc.lpszClassName = wnd_class;
	RegisterClassEx(&wc);

	wnd_class_reged = true;
}

void CConnection::read()
{
	// check for overflow
	if (buf_data_len == NVT_LINE_MAX_SIZE)
		buf_data_len = 0;

	// get
	int i;
	if ( (i = recv(sock, buf + buf_data_len, NVT_LINE_MAX_SIZE - buf_data_len, 0)) == SOCKET_ERROR )
	{
		printe(405);
		return;
	}
	buf_data_len += i;
	buf[buf_data_len] = 0;

	// find end of NVT line, so, find a line
	while (buf_line_end = strstr(buf, "\r\n"))
	{
		// print line
		*buf_line_end = 0;
		printf("%s: %s\n", client_ip, buf);

		// look for command
		switch (*(int*)buf)
		{

		//////////////////////////////////////////////////////////////
		// HELO
		//////////////////////////////////////////////////////////////

		case 0x4F4C4548:

			send_msg(200, def_resp_helo);
			break;

		//////////////////////////////////////////////////////////////
		// PWD
		//////////////////////////////////////////////////////////////

		case 0x20445750:

			send_msg(200, dir_cur);
			break;

		//////////////////////////////////////////////////////////////
		// CWD
		//////////////////////////////////////////////////////////////

		case 0x20445743:

			// check buf
			if (strlen(buf) < 5)
			{
				send_err(450);
				break;
			}

			char *cwd;
			char *tmp;
			tmp = 0;

			// fix merger
			if (buf[4] == '/')
			{
				buf[3] = '.';
				cwd = buf + 3;
			}
			else
			{
				cwd = tmp = (char*)malloc(1 + strlen(dir_cur) + strlen(buf+4) + 1);
				*(int*)tmp = 0x0000002E;
				strcat(tmp, dir_cur);
				tmp[1 + strlen(dir_cur)] = 0;
				strcat(tmp, buf+4);
			}
			// fix separators
			fix_dir(cwd);

			// get full path
			char *fp;
			fp = new char[NVT_LINE_MAX_SIZE * 3];				// fucking MAX_PATH? :)
			char *fp_file;
			GetFullPathName(cwd, NVT_LINE_MAX_SIZE * 3, fp, &fp_file);
			if (tmp)
				free(tmp);

			// check root dir
			if (strstr(fp, dir_root) != fp)
			{
				send_err(450);
				delete [] fp;
				break;
			}

			// is it really dir?
			if (!is_dir(fp))
			{
				send_err(450);
				delete [] fp;
				break;
			}

			// normalize & save current dir
			size_t fpl;
			fpl = strlen(fp);
			if (fp[fpl-1] != '\\')
			{
				fp[fpl++] = '\\';
				fp[fpl] = 0;
			}
			dir_cur = (char*)realloc(dir_cur, fpl - dir_root_len + 1);
			*dir_cur = 0;
			strcpy(dir_cur, fp + dir_root_len);
			for (char *i = dir_cur; *i; i++)
				if (*i == '\\')
					*i = '/';

			delete [] fp;

			send_msg(200, dir_cur);

			break;

		//////////////////////////////////////////////////////////////
		// LIST
		//////////////////////////////////////////////////////////////

		case 0x5453494C:

			char *list;
			list = buf + 5;

			// check buf
			if (strlen(buf) < 5)
			{
				buf[4] = '*';
				buf[5] = 0;
				list =  buf + 4;
			}

			// cat cur_dir & list
			tmp = (char*)malloc(strlen(dir_cur) - 1 + strlen(list) + 1);
			*tmp = 0;
			strcpy(tmp, dir_cur+1);		// without first '/'
			strcat(tmp, list);

			// begin search
			int files;
			files = 0;
			WIN32_FIND_DATA fd;
			HANDLE sh;
			if ( (sh = FindFirstFile(tmp, &fd)) != INVALID_HANDLE_VALUE)
			{
				char *line;

				// search loop
				do
					if (file_is_printable(fd))
					{
						make_file_info_line(fd, &line);
						SEND(sock, line, (size_t)strlen(line), 0);
						files++;
					}
				while (FindNextFile(sh, &fd));
			}

			// end search
			FindClose(sh);

			// total files & ending line
			char tf[22];
			sprintf(tf, "%lu file(s).\r\n\r\n", files);
			SEND(sock, tf, strlen(tf), 0);

			free(tmp);

			break;

		//////////////////////////////////////////////////////////////
		// PORT
		//////////////////////////////////////////////////////////////

		case 0x54524F50:

			if (strlen(buf) < 16)
			{
				send_err(451);
				break;
			}

			// close previous
			if (sock1)
			{
				closesocket(sock1);
				sock1 = 0;
			}

			// try to create
			if ( (sock1 = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET )
			{
				send_err(502);
				break;
			}
			if (WSAAsyncSelect(sock1, hwnd, WM_SOCKET, FD_CONNECT|FD_READ|FD_CLOSE) == SOCKET_ERROR)
			{
				send_err(503);
				closesocket(sock1);
				sock1 = 0;
				break;
			}

			// try to connect
			sockaddr_in sin;
			socket_aton(buf+5, &sin);
			connect(sock1, (SOCKADDR*)&sin, sizeof(sin));			

			break;

		//////////////////////////////////////////////////////////////
		// GET
		//////////////////////////////////////////////////////////////

		case 0x20544547:

			if (!sock1)
			{
				send_err(454);
				break;
			}

			if (strlen(buf) < 5)
			{
				send_err(452);
				break;
			}

			// try to open file
			tmp = (char*)malloc(strlen(dir_cur) - 1 + strlen(buf+4) + 1);
			*tmp = 0;
			strcpy(tmp, dir_cur+1);
			strcat(tmp, buf+4);
			get_file = CreateFile(tmp,
								  GENERIC_READ,
								  FILE_SHARE_READ,
								  0,
							      OPEN_EXISTING,
							      FILE_ATTRIBUTE_ARCHIVE|FILE_FLAG_SEQUENTIAL_SCAN,
							      0);
			if (get_file == INVALID_HANDLE_VALUE)
			{
				send_err(453);
				break;
			}
			free(tmp);

			// send good notification
			send_err(251);

			// create thread and begin transfer...
			CreateThread(0, 0, get_thread_proc, this, 0, (LPDWORD)&get_thread_id);

			break;

		//////////////////////////////////////////////////////////////
		// wrong command
		//////////////////////////////////////////////////////////////

		default:

			send_err(400);

		} // end of looking for command


		// shift to next line
		buf_data_len -= buf_line_end + 2 - buf;
		memcpy(buf, buf_line_end + 2, buf_data_len);
		buf[buf_data_len] = 0;
	}
}

void CConnection::close()
{
	if (closesocket(sock) == SOCKET_ERROR)
		printe(402);
	else
		sock = 0;
	printf("%s: disconnected\n", client_ip);
	delete this;
}

void CConnection::send_err(int code)
{
	char *b;
	forme(code, &b);
	SEND(sock, b, strlen(b), 0);
	free(b);
}

void CConnection::send_msg(int code, char *msg)
{
	char *b = (char*)malloc(7 + strlen(msg));
	if (code)
		sprintf(b, "%d %s\r\n", code, msg);
	else
		sprintf(b, "%s\r\n", msg);
	SEND(sock, b, strlen(b), 0);
	free(b);
}

void CConnection::make_file_info_line(WIN32_FIND_DATA fd, char **s)
{
	// allocate memory
	*s = (char*)malloc(1+1 + 20+1 + 5+1 + 8+1 + MAX_PATH + 1);

	// file size
	char fs[21];
	Int64ToStr(fd.nFileSizeHigh * ((INT64U)MAXDWORD + 1) + fd.nFileSizeLow, fs);

	// file time/date
	SYSTEMTIME st;
	FileTimeToSystemTime(&(fd.ftLastWriteTime), &st);

	// fill it
	sprintf(*s, "%c %20s %02d:%02d %02d.%02d.%02d %s\r\n",
			(fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == FILE_ATTRIBUTE_DIRECTORY ? 'd' : '-',
			fs,
			st.wHour, st.wMinute,
			st.wDay, st.wMonth, st.wYear,
			fd.cFileName);
}

bool CConnection::file_is_printable(WIN32_FIND_DATA fd)
{
	return
		(
			(strlen(fd.cFileName) == 1 && fd.cFileName[0] == '.') ||
			(strlen(fd.cFileName) == 2 && fd.cFileName[0] == '.' && fd.cFileName[1] == '.')
		)
		?
			false
		:
			true;
}

void CConnection::socket_aton(char *a, sockaddr_in *n)
{
	char *cur = a;
	char *sep;
	unsigned ip = 0;
	unsigned short port = 0;
	char count = 0;

	while
	(
		count == 5 ||
		count < 6  &&  ( sep = strchr(cur, ',') )
	)
	{
		*sep = 0;
		int i = atoi(cur) & 0xFF;
		if (count < 4)
			ip = (ip >> 8) | (i << 24);
		else
			port = (port << 8) | i;
		cur = sep + 1;
		count++;
	}

	n->sin_family = AF_INET;
	n->sin_addr.S_un.S_addr = ip;
	n->sin_port = htons(port);
}