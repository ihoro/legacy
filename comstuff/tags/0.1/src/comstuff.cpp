// $Id$

#include "stdafx.h"
#include "comstuff.h"


char app_title[] = "COM Stuff v0.1";
char app_about[] = "19.07.2007 by fnt0m32 'at' gmail.com\nHave fun!";


bool idle = true;

const int timer_elapse = 1000;

#define COM_MAX_COUNT 8
char com_list[COM_MAX_COUNT];
int com_list_count = 0;
int com_speed[] = {CBR_110,CBR_300,CBR_600,CBR_1200,CBR_2400,CBR_4800,CBR_9600,CBR_14400,CBR_19200,CBR_38400,CBR_56000,CBR_57600,CBR_115200,CBR_128000,CBR_256000};
int com_speed_count = 15;
const int com_speed_default = 5;

int com_buffer_in =  1024 *4;
int com_buffer_out = 1024 *4;

HANDLE comH;
OVERLAPPED ovr;

// can fuck me later, but this studio has fucked me already! why in 2003 it ...?
char *parity[] = {"No", "Even", "Mark", "Odd", "Space"};
char *stopbits[] = {"1", "1.5", "2"};


// time left
int time_left;

// packets data
int zero_or_one;
double course;
const double course_offset = 0.1;
double depth;
const double depth_offset = -1.0;



// s must points to char after '$'
void calc_crc(char *s)
{
	unsigned char crc = *s ++;

	for (; *s != '*'; s++)
		crc ^= *s;

	s++;

	sprintf(s, "%02X\r\n", crc);
}


INT_PTR __stdcall DlgProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	char s[10];
	HANDLE h;
	DCB dcb;
	COMMTIMEOUTS cto;

	switch (uMsg)
	{
	//------------------------------------------------
	case WM_INITDIALOG:

		// set title
		SetWindowText(hwnd, app_title);

		// init time edit box
		SendDlgItemMessage(hwnd, IDC_TIME, EM_SETLIMITTEXT, 7, 0);
		SetDlgItemInt(hwnd, IDC_TIME, 3600, FALSE);

		// find COM ports
		strcpy(s, "\\\\.\\COM");
		
		for (int i=0; i<8; i++)
		{
			sprintf(s+7, "%d", i+1);
			if ( (h = CreateFile(s, GENERIC_READ|GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0)) != INVALID_HANDLE_VALUE )
			{
				// add to list
				com_list[com_list_count] = i+1;
				com_list_count++;

				// close port
				ClearCommBreak(h);
				CloseHandle(h);

				// add to combobox
				SendDlgItemMessage(hwnd, IDC_PORT, CB_ADDSTRING, 0, (LPARAM)(s+4));
			}
		}

		// if no ports
		if (!com_list_count)
		{
			MessageBox(hwnd, "Нет свободных СОМ-портов. Дальнейшая работа невозможна.", "Ошибка", MB_OK|MB_ICONERROR);
			PostMessage(hwnd, WM_CLOSE, 0, 0);
			break;
		}

		// set default port
		if (com_list_count)
			SendDlgItemMessage(hwnd, IDC_PORT, CB_SETCURSEL, 0, 0);

		// init speed combo box
		for (int i=0; i<com_speed_count; i++)
		{
			sprintf(s, "%d", com_speed[i]);
			SendDlgItemMessage(hwnd, IDC_SPEED, CB_ADDSTRING, 0, (LPARAM)s);
		}

		// set default speed
		SendDlgItemMessage(hwnd, IDC_SPEED, CB_SETCURSEL, com_speed_default, 0);

		// init parity combo box
		for (int i=0; i<5; i++)
			SendDlgItemMessage(hwnd, IDC_PARITY, CB_ADDSTRING, 0, (LPARAM)parity[i]);

		// set default parity
		SendDlgItemMessage(hwnd, IDC_PARITY, CB_SETCURSEL, 0, 0);

		// init stopbits combo box
		for (int i=0; i<3; i++)
			SendDlgItemMessage(hwnd, IDC_STOPBITS, CB_ADDSTRING, 0, (LPARAM)stopbits[i]);

		// set default stopbit
		SendDlgItemMessage(hwnd, IDC_STOPBITS, CB_SETCURSEL, 0, 0);

		break;

	//------------------------------------------------
	case WM_COMMAND:

		switch (LOWORD(wParam))
		{
		case IDC_START:

			if (idle = !idle)

			// do stop
			//------------------------------------------
			{
				KillTimer(hwnd, 1);
				CloseHandle(comH);
				CloseHandle(ovr.hEvent);

				// set new button caption
				SetDlgItemText(hwnd, IDC_START, "Старт");
			}

			// do start
			//------------------------------------------
			else
			{
				// get time
				time_left = GetDlgItemInt(hwnd, IDC_TIME, FALSE, FALSE);
				SetDlgItemInt(hwnd, IDC_TIME_LEFT, time_left, FALSE);
				if (!time_left)
					break;

				// try to open selected COM port
				sprintf(s, "\\\\.\\COM%d", com_list[ SendDlgItemMessage(hwnd, IDC_PORT, CB_GETCURSEL, 0, 0) ]);
				comH = CreateFile(s, GENERIC_READ|GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
				if (comH == INVALID_HANDLE_VALUE)
				{
					MessageBox(hwnd, "Не могу открыть СОМ-порт.", "Ошибка", MB_OK|MB_ICONERROR);
					break;
				}

				// reset
				PurgeComm(comH, PURGE_TXABORT | PURGE_RXABORT | PURGE_TXCLEAR | PURGE_RXCLEAR);
				ClearCommBreak(comH);

				// set queue length
				SetupComm(comH, com_buffer_in, com_buffer_out);
				// set speed
				GetCommState(comH, &dcb);
				dcb.BaudRate = com_speed[SendDlgItemMessage(hwnd, IDC_SPEED, CB_GETCURSEL, 0, 0)];
				// set parity
				dcb.Parity = (BYTE)SendDlgItemMessage(hwnd, IDC_PARITY, CB_GETCURSEL, 0, 0);
				// set stopbits
				dcb.StopBits = (BYTE)SendDlgItemMessage(hwnd, IDC_STOPBITS, CB_GETCURSEL, 0, 0);
				// set byte size
				dcb.ByteSize = 8;
				// set it up
				SetCommState(comH, &dcb);

				// set timeouts
				GetCommTimeouts(comH, &cto);
				cto.ReadIntervalTimeout = 10;
				cto.WriteTotalTimeoutMultiplier = 10;
				cto.WriteTotalTimeoutConstant = 2000;
				SetCommTimeouts(comH, &cto);

				// init ovr
				ovr.hEvent = CreateEvent(0, TRUE, FALSE, 0);

				// reset all global params
				zero_or_one = 0;
				course = 0.0;
				depth = 50.0;

				// start timer
				SetTimer(hwnd, 1, timer_elapse, 0);

				// set new button caption
				SetDlgItemText(hwnd, IDC_START, "Стоп");
			}

			break;

		case IDC_ABOUT:

			ShellAbout(hwnd, app_title, app_about, 0);

			break;
		};

		break;

	//------------------------------------------------
	case WM_TIMER:
		{

		char s[50];
		int c;

		// $EPVHW
		sprintf(s, "$EPVHW,,,,,14.%d,N,,,A*%d\r\n", zero_or_one, 64+zero_or_one);
		WriteFile(comH, s, strlen(s), (LPDWORD)&c, &ovr);

		// $EPVTG
		sprintf(s, "$EPVTG,,,,,14.%d,N,,,A*%d\r\n", zero_or_one, 68+zero_or_one);
		WriteFile(comH, s, strlen(s), (LPDWORD)&c, &ovr);

		// $EPHDT
		sprintf(s, "$EPHDT,%.1f,T*??\r\n", course);
		calc_crc(s+1);
		WriteFile(comH, s, strlen(s), (LPDWORD)&c, &ovr);

		// $EPDBT
		sprintf(s, "$EPDBT,%.1f,f,%.1f,M,%.1f,F*??\r\n", depth * 0.305, depth, depth * 1.83);
		calc_crc(s+1);
		WriteFile(comH, s, strlen(s), (LPDWORD)&c, &ovr);

		// switch params
		zero_or_one ^= 1;
		course += course_offset;
		if (course > 359.9)
			course = 0.0;
		depth += depth_offset;
		if (depth < 10.0)
			depth = 50.0;

		// shift time
		SetDlgItemInt(hwnd, IDC_TIME_LEFT, --time_left, FALSE);
		if (time_left <= 0)
			PostMessage(hwnd, WM_COMMAND, (BN_CLICKED << 16) | IDC_START, (LPARAM)GetDlgItem(hwnd, IDC_START));

		}
		break;

	//------------------------------------------------
	case WM_CLOSE:

		if (!idle)
			SendMessage(hwnd, WM_COMMAND, (BN_CLICKED << 16) | IDC_START, (LPARAM)GetDlgItem(hwnd, IDC_START));
		EndDialog(hwnd, 0);

		break;

	//------------------------------------------------
	default:

		return FALSE;
	};

	return TRUE;
}


int __stdcall WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	DialogBoxParam(hInstance, (LPCSTR)IDD_MAIN_DIALOG, 0, DlgProc, 0);

	return 0;
}