#include "StdAfx.h"
#include "stp_server.h"


char* getm(int code)
{
	char *m;
	switch (code)
	{
	case 251: m = "begin transferring file.."; break;

	case 400: m = "wrong command"; break;
	case 401: m = "WSASyncSelect"; break;
	case 402: m = "closesocket"; break;
	case 403: m = "FD_READ"; break;
	case 404: m = "FD_CLOSE"; break;
	case 405: m = "recv"; break;
	case 406: m = "getpeername"; break;
	case 407: m = "send"; break;
	case 450: m = "wrong dir"; break;
	case 451: m = "wrong parameter"; break;
	case 452: m = "undefined file name"; break;
	case 453: m = "can't open file"; break;
	case 454: m = "use PORT before"; break;
	case 455: m = "can't connect"; break;

	case 500: m = "invalid root dir"; break;
	case 501: m = "WSAStartup"; break;
	case 502: m = "socket"; break;
	case 503: m = "WSASyncSelect"; break;
	case 504: m = "bind"; break;
	case 505: m = "listen"; break;
	case 506: m = "FD_ACCEPT"; break;
	case 507: m = "accept"; break;
	}

	return m;
}

void printe(int code)
{
	printf("*** %02d: %s\n", code, getm(code));
}

void forme(int code, char **s)
{
	char *m = getm(code);
	*s = (char*)malloc(8 + strlen(m));
	sprintf(*s, "%d %s.\r\n", code, m);
}