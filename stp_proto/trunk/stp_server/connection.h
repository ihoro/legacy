#pragma once


#define WM_SOCKET			WM_USER+100
#define NVT_LINE_MAX_SIZE	1000+2


class CConnection
{
public:
	CConnection(SOCKET s, char *chroot);
	~CConnection();

private:
	static void reg_wnd_class();

	// socket
public:
	HWND hwnd;
	SOCKET sock;			// this connection
	SOCKET sock1;			// transfer connection by PORT
	void read();
	void close();

	void send_err(int code);
	void send_msg(int code, char *msg);
	static void socket_aton(char *a, sockaddr_in *n);

	// buffer
private:
	char buf[NVT_LINE_MAX_SIZE + 1];
	unsigned buf_data_len;
	char *buf_line_end;

	// client
private:
	char client_ip[16];									// IPv4

	// dirs
private:
	char *dir_root;
	unsigned dir_root_len;
	char *dir_cur;

	// files list
private:
	static void make_file_info_line(WIN32_FIND_DATA fd, char **s);
	static bool file_is_printable(WIN32_FIND_DATA fd);

	// get command
public:
	HANDLE get_file;
	int get_thread_id;
};
