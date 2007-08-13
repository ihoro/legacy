// $Id$

#include "stdafx.h"
#include "comstuff.h"


char app_title[] = "COM Stuff v0.6.1";
char app_about[] = "13.08.2007 by fnt0m32 'at' gmail.com\nHave fun!";


// program state
//---------------

bool idle = true;


// COM port
//----------

// system numbers
#define COM_MAX_COUNT 8
char com_list[COM_MAX_COUNT];
int com_list_count = 0;

// speed
int com_speed[] = {CBR_110,CBR_300,CBR_600,CBR_1200,CBR_2400,CBR_4800,CBR_9600,CBR_14400,CBR_19200,CBR_38400,CBR_56000,CBR_57600,CBR_115200,CBR_128000,CBR_256000};
int com_speed_count = 15;
const int com_speed_default = 5;

// parity
char *com_parity[] = {"No", "Even", "Mark", "Odd", "Space"};
const int com_parity_default = 0;

// stop-bits
char *com_stopbits[] = {"1", "1.5", "2"};
const int com_stopbits_default = 0;

// driver's buffers
int com_buffer_in  = 1024 *4;
int com_buffer_out = 1024 *4;

// system handle
HANDLE com_h;


// time & timer
//--------------

const int time_period = 1000;	// in ms
int time_left;


// packets data
//--------------

Value<int> zero_or_one(0, 1, 1);
Value<double> speed(18.0, 18.1, 0.1);
Value<double> course(0, 359.9, 0.1);
Value<double> depth(0, 100, 1.0);


// window's stuff
//----------------

HWND hwnd;	// main dialog window
HWND hTT;	// tooltip window



void switchInterface(bool enable)
{
	EnableWindow(GetDlgItem(hwnd, IDC_PORT), enable);
	EnableWindow(GetDlgItem(hwnd, IDC_SPEED), enable);
	EnableWindow(GetDlgItem(hwnd, IDC_PARITY), enable);
	EnableWindow(GetDlgItem(hwnd, IDC_STOPBITS), enable);
	EnableWindow(GetDlgItem(hwnd, IDC_TIME), enable);
}


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

		// remember handle
		::hwnd = hwnd;

		// set tooltips
		TOOLINFO ti;
		ti.cbSize = sizeof(TOOLINFO);
		ti.uFlags = TTF_IDISHWND | TTF_SUBCLASS;
		// about button
		ti.uId = (UINT_PTR)GetDlgItem(hwnd, IDC_ABOUT);
		ti.lpszText = "О программе";
		SendMessage(hTT, TTM_ADDTOOL, 0, (LPARAM)&ti);
		// exit button
		ti.uId = (UINT_PTR)GetDlgItem(hwnd, IDC_EXIT);
		ti.lpszText = "Выход";
		SendMessage(hTT, TTM_ADDTOOL, 0, (LPARAM)&ti);

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
			if ( (h = CreateFile(s, GENERIC_READ|GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0/*FILE_FLAG_OVERLAPPED*/, 0)) != INVALID_HANDLE_VALUE )
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
			SendDlgItemMessage(hwnd, IDC_PARITY, CB_ADDSTRING, 0, (LPARAM)com_parity[i]);

		// set default parity
		SendDlgItemMessage(hwnd, IDC_PARITY, CB_SETCURSEL, com_parity_default, 0);

		// init stopbits combo box
		for (int i=0; i<3; i++)
			SendDlgItemMessage(hwnd, IDC_STOPBITS, CB_ADDSTRING, 0, (LPARAM)com_stopbits[i]);

		// set default stopbit
		SendDlgItemMessage(hwnd, IDC_STOPBITS, CB_SETCURSEL, com_stopbits_default, 0);

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
				CloseHandle(com_h);

				// set button's caption
				SetDlgItemText(hwnd, IDC_START, "Старт");

				switchInterface(true);
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
				com_h = CreateFile(s, GENERIC_READ|GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0/*FILE_FLAG_OVERLAPPED*/, 0);
				if (com_h == INVALID_HANDLE_VALUE)
				{
					MessageBox(hwnd, "Не могу открыть СОМ-порт.", "Ошибка", MB_OK|MB_ICONERROR);
					break;
				}

				// set queue length
				SetupComm(com_h, com_buffer_in, com_buffer_out);
				// set speed
				GetCommState(com_h, &dcb);
				dcb.BaudRate = com_speed[SendDlgItemMessage(hwnd, IDC_SPEED, CB_GETCURSEL, 0, 0)];
				// set parity
				dcb.Parity = (BYTE)SendDlgItemMessage(hwnd, IDC_PARITY, CB_GETCURSEL, 0, 0);
				// set stopbits
				dcb.StopBits = (BYTE)SendDlgItemMessage(hwnd, IDC_STOPBITS, CB_GETCURSEL, 0, 0);
				// set byte size
				dcb.ByteSize = 8;
				// set it up
				SetCommState(com_h, &dcb);

				// set timeouts
				GetCommTimeouts(com_h, &cto);
				cto.WriteTotalTimeoutMultiplier = 10;
				cto.WriteTotalTimeoutConstant = 2000;
				SetCommTimeouts(com_h, &cto);

				// reset all global params
				zero_or_one.reset();
				speed.reset();
				course.set(355.0);
				depth.reset();

				// start timer
				SetTimer(hwnd, 1, time_period, 0);

				// set button's caption
				SetDlgItemText(hwnd, IDC_START, "Стоп");

				
				switchInterface(false);
			}

			break;

		case IDC_ABOUT:

			ShellAbout(hwnd, app_title, app_about, 0);

			break;

		case IDC_EXIT:

			PostMessage(hwnd, WM_CLOSE, 0, 0);

			break;

		};

		break;

	//------------------------------------------------
	case WM_TIMER:
		{

		char s[60];
		DWORD c;

		// $EPVHW
		sprintf(s, "$EPVHW,,,,,14.%d,N,,,A*%d\r\n", zero_or_one(), 64+zero_or_one());
		WriteFile(com_h, s, strlen(s), &c, 0);

		// $EPVTG
		sprintf(s, "$EPVTG,,,,,%.1f,N,%.1f,K,A*", speed(), speed() * 1.852);
		calc_crc(s+1);
		WriteFile(com_h, s, strlen(s), &c, 0);

		// $EPHDT
		sprintf(s, "$EPHDT,%.1f,T*", course());
		calc_crc(s+1);
		WriteFile(com_h, s, strlen(s), &c, 0);

		// $EPHDG
		sprintf(s, "$EPHDG,%.1f,,,,*", course(-5.0));
		calc_crc(s+1);
		WriteFile(com_h, s, strlen(s), &c, 0);

		// $EPDBT
		sprintf(s, "$EPDBT,%.1f,f,%.1f,M,%.1f,F*", depth() * 0.305, depth(), depth() * 1.83);
		calc_crc(s+1);
		WriteFile(com_h, s, strlen(s), &c, 0);

		// $EPDPT
		sprintf(s, "$EPDPT,%.1f,,*", depth());
		calc_crc(s+1);
		WriteFile(com_h, s, strlen(s), &c, 0);

		// shift params
		zero_or_one++;
		speed++;
		course++;
		depth++;

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
	hTT = CreateWindowEx(0, "Tooltips_class32", 0, 0, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, 0, 0, hInstance, 0);

	DialogBoxParam(hInstance, (LPCSTR)IDD_MAIN_DIALOG, 0, DlgProc, 0);

	return 0;
}