// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// windows appearance
#include ".\res\appearance\pic.h"

// main dialog
Cbnu_ctrlDlg *mdlg;

// common labels
CString TITLE_GET;
CString TITLE_SET;
CString TITLE_ON;
CString TITLE_OFF;

// checkboxes map
#include "checkboxes.map"

// title / version / about
char titleVersion[] = "BNU Control v0.1a";
char aboutStuff[] = "12.11.2006 by fnt0m32 'at' gmail.com\nBCP2 Protocol of 17.08.2006";

// BCP
HANDLE hOnline;

// COMThread
bool isWorking = false;						// flag for COMThread
HANDLE hThread;
DWORD ThreadID;

// COM-port
#define COM_IN_BUFFER_SIZE		20480
#define COM_OUT_BUFFER_SIZE		20480
char comBuffer[COM_IN_BUFFER_SIZE];
int comSpeed[] = {CBR_110,CBR_300,CBR_600,CBR_1200,CBR_2400,CBR_4800,CBR_9600,CBR_14400,CBR_19200,CBR_38400,CBR_56000,CBR_57600,CBR_115200,CBR_128000,CBR_256000};
HANDLE hCom;
OVERLAPPED ovr, ovr2;


////////////////////////////////
// implementation of main dialog
////////////////////////////////

Cbnu_ctrlDlg::Cbnu_ctrlDlg(CWnd* pParent)
	: CDialog(Cbnu_ctrlDlg::IDD, pParent)
	, m_setupMode(false)							   
	, m_isIdle(true)
	, m_isDemo(false)
	, m_isFlat(false)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	
	// init other windows pointers
	for (int i=0; i<WND_MAX; i++)
		wnd[i] = 0;
}

void Cbnu_ctrlDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_SETUP_COM, m_cmbSetupCOM);
	DDX_Control(pDX, IDC_SETUP_SPEED, m_cmbSetupSpeed);
}

BEGIN_MESSAGE_MAP(Cbnu_ctrlDlg, CDialog)
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_SETUP, OnBnClickedSetup)
	ON_BN_CLICKED(IDC_SETUP_OK, OnBnClickedSetupOk)
	ON_BN_CLICKED(IDC_START, OnBnClickedStart)
	ON_BN_CLICKED(IDC_SYSTEM_RESET, OnBnClickedSystemReset)
	ON_BN_CLICKED(IDC_REQUESTS_RESET, OnBnClickedRequestsReset)
	ON_COMMAND(ID_MMI_EXIT, OnMmiExit)
	ON_COMMAND(ID_MMI_ABOUT, OnMmiAbout)
	ON_COMMAND(ID_MMI_DEMO, OnMmiDemo)
	ON_WM_CLOSE()
	ON_COMMAND(ID_MMI_FLAT, OnMmiFlat)
END_MESSAGE_MAP()

////////////////
// other windows
////////////////

bool procClose(unsigned char id)
{
	return mdlg->wndClose(id);
}

bool Cbnu_ctrlDlg::wndOpen(unsigned char id)
{
	if (wnd[id])
		return false;		// already opened
	if (id >= WND_MAX)
		return false;		// wrong window's id

	// switch checkbox
	if (id < WND_MAX - 1)
		CheckDlgButton(IDC_CHECK1 + id, !IsDlgButtonChecked(IDC_CHECK1 + id));
		// TODO: CheckDlgButton(IDC_CHECK1 + id, true);

	// create window
	switch (id)
	{
	case WND_01: wnd[id] = new CWindow01(this, procClose, id); break;
	case WND_0B: wnd[id] = new CWindow0B(this, procClose, id); break;
	case WND_0D: wnd[id] = new CWindow0D(this, procClose, id); break;
	case WND_11: wnd[id] = new CWindow11(this, procClose, id); break;
	case WND_12: wnd[id] = new CWindow12(this, procClose, id); break;
	case WND_13: wnd[id] = new CWindow13(this, procClose, id); break;
	case WND_16: wnd[id] = new CWindow16(this, procClose, id); break;
	case WND_17: wnd[id] = new CWindow17(this, procClose, id); break;
	case WND_19: wnd[id] = new CWindow19_20(this, procClose, id); break;
	case WND_1B: wnd[id] = new CWindow1B(this, procClose, id); break;
	case WND_1E: wnd[id] = new CWindow1E(this, procClose, id); break;
	case WND_20: wnd[id] = new CWindow19_20(this, procClose, id); break;
	case WND_21: wnd[id] = new CWindow21(this, procClose, id); break;
	case WND_22: wnd[id] = new CWindow22(this, procClose, id); break;
	case WND_23: wnd[id] = new CWindow23(this, procClose, id); break;
	case WND_24: wnd[id] = new CWindow24(this, procClose, id); break;
	case WND_25: wnd[id] = new CWindow25(this, procClose, id); break;
	case WND_26: wnd[id] = new CWindow26(this, procClose, id); break;
	case WND_27: wnd[id] = new CWindow27(this, procClose, id); break;
	case WND_2A: wnd[id] = new CWindow2A(this, procClose, id); break;
	case WND_2B: wnd[id] = new CWindow2B(this, procClose, id); break;
	case WND_32: wnd[id] = new CWindow32(this, procClose, id); break;
	case WND_39: wnd[id] = new CWindow39(this, procClose, id); break;
	//case WND_A0: wnd[id] = new CWindowA0(this, procClose, id); break;
	case WND_A2: wnd[id] = new CWindowA2(this, procClose, id); break;
	case WND_A4: wnd[id] = new CWindowA4(this, procClose, id); break;
	case WND_A6: wnd[id] = new CWindowA6(this, procClose, id); break;
	case WND_A8: wnd[id] = new CWindowA8(this, procClose, id); break;
	case WND_AA: wnd[id] = new CWindowAA(this, procClose, id); break;
	case WND_AC: wnd[id] = new CWindowAC(this, procClose, id); break;
	case WND_AE: wnd[id] = new CWindowAE(this, procClose, id); break;
	case WND_B1: wnd[id] = new CWindowB1(this, procClose, id); break;
	case WND_B2: wnd[id] = new CWindowB2(this, procClose, id); break;
	case WND_B5: wnd[id] = new CWindowB5(this, procClose, id); break;
	case WND_B6: wnd[id] = new CWindowB6(this, procClose, id); break;
	case WND_B8: wnd[id] = new CWindowB8(this, procClose, id); break;
	case WND_D4: wnd[id] = new CWindowD4(this, procClose, id); break;
	case WND_D6: wnd[id] = new CWindowD6(this, procClose, id); break;
	case WND_D7: wnd[id] = new CWindowD7(this, procClose, id); break;
	case WND_FC: wnd[id] = new CWindowFC(this, procClose, id); break;
	case WND_FD: wnd[id] = new CWindowFD(this, procClose, id); break;

	default: return false;
	}

	// show window
	wnd[id]->ShowWindow(SW_NORMAL);

	return true;
}

bool Cbnu_ctrlDlg::wndClose(unsigned char id)
{
	if (!wnd[id])
		return false;		// already closed
	if (id >= WND_MAX)
		return false;		// wrong window's id
	if (wnd[id]->isBusy)
		return false;		// window's waiting for message box or something else

	// save settings
	wnd[id]->ini_save();

	// delete window
	delete wnd[id];
	wnd[id] = 0;

	// switch checkbox
	if (id < WND_MAX - 1)
		CheckDlgButton(IDC_CHECK1 + id, !IsDlgButtonChecked(IDC_CHECK1 + id));
		// TODO: CheckDlgButton(IDC_CHECK1 + id, false);

	return true;
}

void Cbnu_ctrlDlg::wndCloseAll()
{
	for (int i=0; i < WND_MAX; i++)
		wndClose(i);
}

void Cbnu_ctrlDlg::wndSwitch(unsigned char id)
{
	if (wnd[id])
		wndClose(id);
	else
		wndOpen(id);
}

///////////////////////////////////////////////
// status handler as BCP2Engine::CounterHandler
///////////////////////////////////////////////

void show_status(INT8U *data_ptr, INT32U data_size)
{
	char s[21];

	// tx_bytes
	Int64ToStr(mdlg->tx_bytes, s);
	mdlg->SetDlgItemText(IDC_TX_BYTES, s);

	// rx_bytes
	Int64ToStr(bcp->rx_bytes, s);
	mdlg->SetDlgItemText(IDC_RX_BYTES, s);

	// tx_packets
	Int64ToStr(mdlg->tx_packets, s);
	mdlg->SetDlgItemText(IDC_TX_PACKETS, s);

	// rx_packets
	Int64ToStr(bcp->rx_packets, s);
	mdlg->SetDlgItemText(IDC_RX_PACKETS, s);
}

/////////////////////
// working COM thread
/////////////////////

DWORD __stdcall COMThread(LPVOID lpParam)
{	
	COMSTAT ComStat;
	DWORD EventMask;
	DWORD ErrorMask;
	DWORD cGot;

	// prepare work
	SetCommMask(hCom, EV_RXCHAR);
	ovr.hEvent = CreateEvent(0, TRUE, FALSE, 0);	// not autoreset
	  
	// working
	while (isWorking)
	{
		EventMask = 0;
		if (!WaitCommEvent(hCom, &EventMask, &ovr))
			if (GetLastError() == ERROR_IO_PENDING)
				WaitForSingleObject(ovr.hEvent, INFINITE);
		ClearCommError(hCom, &ErrorMask, &ComStat);
		ReadFile(hCom, comBuffer, ComStat.cbInQue, &cGot, &ovr);
		if (cGot)
			bcp->Process(comBuffer, cGot);
		ResetEvent(ovr.hEvent);
	}

	return 0;
}

/////////////////////////
// open COM-port function
/////////////////////////

bool Cbnu_ctrlDlg::OpenCOMPort()
{
	CString s, s2;
	DCB dcb;
	COMMTIMEOUTS cto;

	// open COM-port
	s.Format("\\\\.\\COM%d", m_setupCOM);
	if
	(
		(hCom = CreateFile(s, GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0)) != INVALID_HANDLE_VALUE &&
		PurgeComm(hCom, PURGE_TXABORT | PURGE_RXABORT | PURGE_TXCLEAR | PURGE_RXCLEAR) &&
		ClearCommBreak(hCom) &&
		SetupComm(hCom, COM_IN_BUFFER_SIZE, COM_OUT_BUFFER_SIZE) &&
		GetCommState(hCom, &dcb)	&&
		(dcb.BaudRate = comSpeed[m_setupSpeed])  &&
		(dcb.Parity = ODDPARITY) &&
		!(dcb.StopBits = ONESTOPBIT) &&
		(dcb.ByteSize = 8) &&
		SetCommState(hCom,&dcb) &&
		GetCommTimeouts(hCom,&cto) &&
		(cto.ReadIntervalTimeout = 10) &&
		(cto.WriteTotalTimeoutMultiplier = 10) &&
		(cto.WriteTotalTimeoutConstant = 2000) &&
		SetCommTimeouts(hCom, &cto)
	)
		return true;
	else
	{
		s.LoadString(IDS_COM_ERR_OPEN);
		s2.LoadString(IDS_ERROR);
		MessageBox(s, s2, MB_OK | MB_ICONERROR);
		return false;
	}
}

//////////////////////////////////
// packets handlers of main dialog
//////////////////////////////////

void got54(INT8U *data_ptr, INT32U data_size)
{
	SetEvent(hOnline);
}

void got60(INT8U *data_ptr, INT32U data_size)
{

#define BCP_PACKET 0x60
#include "bcp2packet.h"

	if (_rnpi == 0x00)
	{
		CString s, s2;
		s2.LoadString(IDS_FMT_CHANNELS);	
		s.Format(s2, _gps, _gln);
		mdlg->SetDlgItemText(IDC_RNPI_RABKA, s);
	}

	if (mdlg->wnd[WND_21]  &&  ((CWindow21*)mdlg->wnd[WND_21]) -> waiting)
		((CWindow21*)mdlg->wnd[WND_21]) -> ShowInfo(data_ptr);

#include "bcp2packet.h"

}

void got88(INT8U *data_ptr, INT32U data_size)
{

#define BCP_PACKET 0x88
#include "bcp2packet.h"

	// main window
	if (_rnpi == 0x00)
		mdlg->Show88(mdlg, data_ptr);

	// other windows
	if
	(
		DEVICE >= 2  &&  DEVICE <= 5
		&& mdlg->wnd[WND_27]
		&& ! ((CWindow*)mdlg->wnd[WND_27]) -> isMinimized
		&& _rnpi == ((CWindow27*)mdlg->wnd[WND_27]) -> ds_get()
	)
		mdlg->Show88(mdlg->wnd[WND_27], data_ptr);

#include "bcp2packet.h"

}

void gotA5(INT8U *data_ptr, INT32U data_size)
{

#define BCP_PACKET 0xA5
#include "bcp2packet.h"

	CString s;

	// show course
	s.Format("%.2f", _course);
	mdlg->SetDlgItemText(IDC_RNPI_COURSE, s);

	// show roll
	s.Format("%.2f", _roll);
	mdlg->SetDlgItemText(IDC_RNPI_ROLL, s);

	// show different
	s.Format("%.2f", _different);
	mdlg->SetDlgItemText(IDC_RNPI_DIFFERENT, s);

	// give A4 window this info
	if (mdlg->wnd[WND_A4])
		((CWindowA4*)mdlg->wnd[WND_A4])->ShowParams(_course, _roll, _different,
													_course_RMS, _roll_RMS, _different_RMS);

#include "bcp2packet.h"

}

void Cbnu_ctrlDlg::Show88(CWnd *w, INT8U *data_ptr)
{

#define BCP_PACKET 0x88
#include "bcp2packet.h"

	CString s, s2;
	BCP_TIME t;
	int deg;
	double min;
	char c;
	
	// if date is presented
	if (_week >= 0)
	{
		bcp->DecodeBCPTime(_week, bcp->to64(_time), t);
		// date
		s.Format("%.2u.%.2u.%.4u", t.day, t.month, t.year);
		// time
		s2.Format("%.2u:%.2u:%.2u", t.hour, t.minute, t.second);
	}
	else
	{
		s = "?";
		s2 = "?";
	}

	// show date
	w->SetDlgItemText(IDC_RNPI_DATE, s);

	// show time
	w->SetDlgItemText(IDC_RNPI_TIME, s2);

	// show RMS
	s.Format("%.2f", _RMS);
	w->SetDlgItemText(IDC_RNPI_RMS, s);

	// show latitude
	if (_latitude < 0)
	{
		c = 'S';
		_latitude = -_latitude;
	}
	else
		c = 'N';
	deg = (char)(_latitude / (PI/180));
	min = (_latitude / (PI/180) - deg) * 60;
	s.Format("%.2u\xB0%07.4f%c", deg, min, c);
	w->SetDlgItemText(IDC_RNPI_LATITUDE, s);

	// show longitude
	if (_longitude < 0)
	{
		c = 'W';
		_longitude = -_longitude;
	}
	else
		c = 'E';
	deg = (char)(_longitude / (PI/180));
	min = (_longitude / (PI/180) - deg) * 60;
	s.Format("%.3u\xB0%07.4f%c", deg, min, c);
	w->SetDlgItemText(IDC_RNPI_LONGITUDE, s);

	// show height
	s.Format("%.3f", _height);
	w->SetDlgItemText(IDC_RNPI_HEIGHT, s);

	// show latitude speed
	s.Format("%.3f", _latitude_speed);
	w->SetDlgItemText(IDC_RNPI_LATITUDE_SPEED, s);

	// show longitude speed
	s.Format("%.3f", _longitude_speed);
	w->SetDlgItemText(IDC_RNPI_LONGITUDE_SPEED, s);

	// show height speed
	s.Format("%.3f", _height_speed);
	w->SetDlgItemText(IDC_RNPI_HEIGHT_SPEED, s);

	// show mode
	w->SetDlgItemText(IDC_RNPI_MODE, (_status & 0x08) ? "D" : "");

#include "bcp2packet.h"

}

//////////////////////////
// load/save main settings
//////////////////////////

char *ini_main = "main";

void Cbnu_ctrlDlg::load_ini()
{
	// com-port
	m_setupCOM = theApp.GetProfileInt(ini_main, "com", 1);
	m_setupSpeed = theApp.GetProfileInt(ini_main, "com_speed", 12);

	// last selected device
	device = theApp.GetProfileInt(ini_main, "device", 0);
	CheckRadioButton(IDC_MODE1, IDC_MODE7, IDC_MODE1 + device);
	SwitchMode();

	// flat mode
	m_isFlat = !(theApp.GetProfileInt(ini_main, "flat", 0) == 0);
	mm->CheckMenuItem(ID_MMI_FLAT, m_isFlat ? MF_CHECKED : MF_UNCHECKED);

	// window position
	int x,y;
	x = theApp.GetProfileInt(ini_main, "x", DEF_XY);
	y = theApp.GetProfileInt(ini_main, "y", DEF_XY);
	if (x == DEF_XY || y == DEF_XY)
		CenterWindow();
	else
		SetWindowPos(0, x,y, 0,0, SWP_NOSIZE|SWP_NOZORDER);
}

void Cbnu_ctrlDlg::save_ini()
{
	// com-port
	theApp.WriteProfileInt(ini_main, "com", m_setupCOM);
	theApp.WriteProfileInt(ini_main, "com_speed", m_setupSpeed);

	// last selected device
	theApp.WriteProfileInt(ini_main, "device", device);

	// flat mode
	theApp.WriteProfileInt(ini_main, "flat", m_isFlat ? 1 : 0);

	// window position
	RECT r;
	GetWindowRect(&r);
	theApp.WriteProfileInt(ini_main, "x", r.left);
	theApp.WriteProfileInt(ini_main, "y", r.top);
}

////////////////////////////////////
// program-global keyboard shortcuts
////////////////////////////////////

HHOOK sc_hook;
bool sc_ctrl;			// false? :) it should be by default...
bool sc_alt;
bool sc_exit;

enum SHORTCUT
{
	SC_NONE,
	SC_EXIT
};

SHORTCUT sc_get(WPARAM wParam, LPARAM lParam)
{
	// key up
	if (lParam & 0x80000000)
	{
		// ctrl
		if (sc_ctrl && wParam == VK_CONTROL)
			sc_ctrl = false;
		// alt
		else if (sc_alt && wParam == VK_MENU)
			sc_alt = false;
		// exit
		else if (sc_exit && wParam == 0x58)
			sc_exit = false;
	}

	// key down
	else
	{
		// ctrl
		if (!sc_ctrl && wParam == VK_CONTROL)
			sc_ctrl = true;
		// alt
		else if (!sc_alt && wParam == VK_MENU)
			sc_alt = true;
		//	exit
		else if (!sc_exit && sc_alt && wParam == 0x58)
		{
			sc_exit = true;
			return SC_EXIT;
		}
	}

	return SC_NONE;
}

LRESULT WINAPI hook_proc(int code, WPARAM wParam, LPARAM lParam)
{
	//if (code < 0)
	//	return CallNextHookEx(sc_hook, code, wParam, lParam);

	switch (sc_get(wParam, lParam))
	{
	case SC_EXIT:

		mdlg->OnMmiExit();
		break;

	
	}
	
	return 0;
}

////////////////////////////////
// Cbnu_ctrlDlg message handlers
////////////////////////////////

BOOL Cbnu_ctrlDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// get main menu
	mm = GetMenu();

	// install keyboard hook
	sc_hook = SetWindowsHookEx(WH_KEYBOARD, hook_proc, 0, GetCurrentThreadId());

	/*
	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}
	*/

	// icons
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// init main dialog title
	SetWindowText(titleVersion);

	//CString sss;
	//sss.Format("sizeof(BCP_TIME) = %d, sizeof(CHANNEL_INFO) = %d", sizeof(BCP_TIME), sizeof(CHANNEL_INFO));
	//SetWindowText(sss);

	// TODO: init mode-box
	//CheckRadioButton(IDC_MODE1, IDC_MODE7, IDC_MODE1);
/*#ifndef _DEBUG
	HWND h;
	for (int i=1; i<9; i++)
	{
		h = ::GetDlgItem(m_hWnd, IDC_START+i);
		::ShowWindow(h, false);
	}
#endif*/

	CString s;

	// init common titles
	TITLE_GET.LoadString(IDS_GET);
	TITLE_SET.LoadString(IDS_SET);
	TITLE_ON.LoadString(IDS_ON);
	TITLE_OFF.LoadString(IDS_OFF);

	// init dialog titles
	SetDlgItemText(IDC_START, TITLE_ON);
	s.LoadString(IDS_SETUP_SETUP);
	SetDlgItemText(IDC_SETUP, s);

	// init windows titles
	for (int i=0; i < WND_MAX-1; i++)		// without WND_01, that hasn't own checkbox
	{
		s.LoadString(IDS_TITLE_0 + i);
		SetDlgItemText(IDC_CHECK1 + i, s);
	}
	s.LoadString(IDS_TITLE_0 + WND_01);
	SetDlgItemText(IDC_SYSTEM_RESET, s);
	s.LoadString(IDS_TITLE_0 + WND_0E);
	SetDlgItemText(IDC_REQUESTS_RESET, s);

	// init windows appearance pictures
	BITMAPINFO *bmi;
	HBITMAP bm;
	int pic_size = 0;

	HDC dc = ::GetDC(m_hWnd);

	for (int i=0; i<PICS_COUNT; i++)
	{	 
		bmi = new BITMAPINFO;
		memset(&bmi->bmiHeader, 0, sizeof(BITMAPINFOHEADER));
		bmi->bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
		bmi->bmiHeader.biPlanes = 1;
		bmi->bmiHeader.biBitCount = 24;
		bmi->bmiHeader.biWidth = pic_width[i];
		bmi->bmiHeader.biHeight = -pic_height[i];

		if (i)
			pic_size += (pic_width[i-1]*3 + 1) * pic_height[i-1];
	
		bm = ::CreateDIBitmap(dc, &bmi->bmiHeader, CBM_INIT, pic + pic_size, bmi, DIB_RGB_COLORS);

		dc_pic[i] = ::CreateCompatibleDC(dc);
        ::SelectObject(dc_pic[i], bm);

		delete bmi;
		::DeleteObject(bm);
	}

	// load settings
	load_ini();
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

//void Cbnu_ctrlDlg::OnSysCommand(UINT nID, LPARAM lParam)
//{
//	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
//		::ShellAbout(m_hWnd, titleVersion, aboutStuff, m_hIcon);
//	else
//		CDialog::OnSysCommand(nID, lParam);
//}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

//void Cbnu_ctrlDlg::OnPaint() 
//{
//	if (IsIconic())
//	{
//		CPaintDC dc(this); // device context for painting
//
//		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);
//
//		// Center icon in client rectangle
//		int cxIcon = GetSystemMetrics(SM_CXICON);
//		int cyIcon = GetSystemMetrics(SM_CYICON);
//		CRect rect;
//		GetClientRect(&rect);
//		int x = (rect.Width() - cxIcon + 1) / 2;
//		int y = (rect.Height() - cyIcon + 1) / 2;
//
//		// Draw the icon
//		dc.DrawIcon(x, y, m_hIcon);
//	}
//	else
//	{
//		CDialog::OnPaint();
//	}
//}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
//HCURSOR Cbnu_ctrlDlg::OnQueryDragIcon()
//{
//	return static_cast<HCURSOR>(m_hIcon);
//}

void Cbnu_ctrlDlg::ShowSetupBox(bool aShow)
{
	//int swShow = aShow ? SW_SHOW : SW_HIDE;
	//int swHide = aShow ? SW_HIDE : SW_SHOW;

	//HWND h;

	// hide/show basic elements 
	for (int i=0; i<9; i++)
		SHOW_ITEM(IDC_START+i, !aShow);
	/*{
		h = ::GetDlgItem(m_hWnd, IDC_START+i);
		::ShowWindow(h, swHide);
	}*/

	// show/hide setup box
	for (int i=0; i<5; i++)
		SHOW_ITEM(IDC_SETUP_BOX+i, aShow);
	/*{
		h = ::GetDlgItem(m_hWnd, IDC_SETUP_BOX+i);
		::ShowWindow(h, swShow);
	}*/
}

void Cbnu_ctrlDlg::OnBnClickedSetupOk()
{
	m_setupCOM = m_com_list[m_cmbSetupCOM.GetCurSel()];
	m_setupSpeed = m_cmbSetupSpeed.GetCurSel();
	OnBnClickedSetup();
}

void Cbnu_ctrlDlg::OnBnClickedSetup()
{
	HANDLE h;
	CString s;

	m_setupMode = !m_setupMode;
	ShowSetupBox(m_setupMode);
	
	s.LoadString( m_setupMode ? IDS_CANCEL : IDS_SETUP_SETUP );
	SetDlgItemText(IDC_SETUP, s);

	if (m_setupMode)
	{
		// generate COM-list
		m_com_list.RemoveAll();
		for (int i=1; i<=4; i++)
		{
			s.Format("\\\\.\\COM%d",i);
			if ((h = CreateFile(s,GENERIC_READ|GENERIC_WRITE,0,0,OPEN_EXISTING,FILE_FLAG_OVERLAPPED,0)) != INVALID_HANDLE_VALUE)
			{
				m_com_list.Add(i);
				ClearCommBreak(h);
				CloseHandle(h);
			}
		}
		// if no COM-ports
		if (m_com_list.GetSize() == 0)
			m_com_list.Add(0);

		// clear ComboBox strings
		while (m_cmbSetupCOM.GetCount())
			m_cmbSetupCOM.DeleteString(m_cmbSetupCOM.GetCount()-1);
		
		// fill ComboBox
		for (int i=0; i<m_com_list.GetSize(); i++)
			if (m_com_list[i])
			{
				s.Format("COM%d", m_com_list[i]);
				m_cmbSetupCOM.AddString(s);
			}
			else
				m_cmbSetupCOM.AddString("none");

		// set current COM-port
		for (int i=0; i<m_com_list.GetSize(); i++)
			if (m_setupCOM == m_com_list[i])
			{
				m_cmbSetupCOM.SetCurSel(i);
				break;
			}
			else
				if (i == m_com_list.GetSize()-1)
					m_cmbSetupCOM.SetCurSel(0);

		// set current COM-Speed
		m_cmbSetupSpeed.SetCurSel(m_setupSpeed);

		UpdateData(0);
	}
}

void Cbnu_ctrlDlg::SwitchMode()
{
	// set state of checkboxes by checkmap
	for (int i=0; i < WND_MAX - 1; i++)
	{
		HWND h = ::GetDlgItem(m_hWnd, IDC_CHECK1 + i);
		if (!m_isIdle)
			::EnableWindow(h, checkmap[i] & (1 << device));
		else
			::EnableWindow(h, false);
	}

	// system reset button
	ENABLE_ITEM(IDC_SYSTEM_RESET, !m_isIdle);
	
	// requests reset button
	ENABLE_ITEM(IDC_REQUESTS_RESET, !m_isIdle);

	// it's for special mode #1
	///////////////////////////

	bool sh = (device - 1) == 0;		// show/hide mode #1

	// hide checkboxes
	for (int i = 0; i < 13; i++)
		SHOW_ITEM(IDC_CHECK5 + i, !sh);

	// show new checkboxes
	for (int i = 0; i < 6; i++)
		SHOW_ITEM(IDC_CHECK1 + WND_B5 + i, sh);

	// buttons
	for (int i = 0; i < 2; i++)
		SHOW_ITEM(IDC_SYSTEM_RESET + i, !sh);

	// BOX1
	SHOW_ITEM(IDC_BOX1, !sh);

	// BOX2
	SHOW_ITEM(IDC_BOX2, !sh);

	// BOX_CPU
	SHOW_ITEM(IDC_BOX_CPU, sh);

	// BOX_TECH
	SHOW_ITEM(IDC_BOX_TECH, sh);
}

void Cbnu_ctrlDlg::OnBnClickedStart()
{
	CString s, s2;

	m_isIdle = !m_isIdle;
	
	if (m_isIdle)
	{
		// switch interface
		SwitchInterface();

		SetDlgItemText(IDC_START, TITLE_ON);

		// stop thread
		isWorking = false;
		CloseHandle(hCom);
		CloseHandle(ovr.hEvent);
		CloseHandle(ovr2.hEvent);

		// status updater
		bcp->CounterHandler = 0;

		// close all windows
		wndCloseAll();
	}
	else
	{
		// init bcp
		CTime t;
		t = t.GetCurrentTime();
		bcp->SetTimeOffset(t.GetDay(), t.GetMonth(), t.GetYear());
		bcp->ResetProcess();

		// init status info
		tx_bytes = 0;
		tx_packets = 0;
		show_status(0, 0);

		// switch interface
        SwitchInterface();
		UpdateWindow();

		// try to open COM-port
		if (!OpenCOMPort())
		{
			OnBnClickedStart();
			return;
		}

		ovr2.hEvent = CreateEvent(0, TRUE, FALSE, 0);	// not autoreset

		// start thread
		isWorking = true;
		hThread = ::CreateThread(0, 0, COMThread, 0, 0, &ThreadID);

		// send init packets
		char p[PACKET_MAX_SIZE];
		int size;

		// send 26h -> 54h and check if it's online
		s.LoadString(IDS_PERFORMING);
		SetDlgItemText(IDC_START, s);
		bcp->Handler[0x54] = got54;
		size = bcp->MakePacket(p, 0x26, 255);
		SendData(p, size);
		hOnline = CreateEvent(0, TRUE, FALSE, 0);
		if (WaitForSingleObject(hOnline, GET_ONLINE_STATUS_TIMEOUT) != WAIT_OBJECT_0)
		{
			CloseHandle(hOnline);
			isWorking = false;
			s.LoadString(IDS_BCP_ERR_ONLINE_TIMEOUT);
			s2.LoadString(IDS_ERROR);
			MessageBox(s ,s2, MB_ICONERROR | MB_OK);
			OnBnClickedStart();
			bcp->Handler[0x54] = 0;
			return;
		}
		CloseHandle(hOnline);
		bcp->Handler[0x54] = 0;
		SetDlgItemText(IDC_START, TITLE_OFF);

		// status updater
		bcp->CounterHandler = show_status;

		// send 21h -> 60h
		bcp->Handler[0x60] = got60;
		size = bcp->MakePacket(p, 0x21, 0x00, RESPONSE_PERIOD_IN_SECONDS);
		SendData(p, size);

		// send 27h -> 88h
		bcp->Handler[0x88] = got88;
		size = bcp->MakePacket(p, 0x27, 0x00, RESPONSE_PERIOD_IN_INTERVALS);
		SendData(p, size);

		// send A4h -> A5h
		bcp->Handler[0xA5] = gotA5;
		size = bcp->MakePacket(p, 0xA4, RESPONSE_PERIOD_IN_INTERVALS);
		SendData(p, size);
	}
}
								   
int Cbnu_ctrlDlg::SendData(char *pData, int count)
{
	if (m_isDemo)
		return 0;

	int cSent;

	WriteFile(hCom, pData, count, (LPDWORD)&cSent, &ovr2);

	tx_packets++;
	tx_bytes += count;
	show_status(0, 0);

	return cSent;
}

void Cbnu_ctrlDlg::OnClose()
{
	// uninstall hook
	UnhookWindowsHookEx(sc_hook);

	// stop work
	if (!m_isIdle && !m_isDemo)
		OnBnClickedStart();

	// kill windows
	else
		wndCloseAll();

	// save settings
	save_ini();

	CDialog::OnClose();

	EndDialog(0);
}

void Cbnu_ctrlDlg::OnBnClickedSystemReset()
{
	wndSwitch(WND_01);
}

void Cbnu_ctrlDlg::OnBnClickedRequestsReset()
{
	CString s;

	s.LoadString(IDS_TITLE_0 + WND_0E);
	if ( MessageBox("Вы уверены?", s, MB_ICONQUESTION | MB_YESNO | MB_DEFBUTTON2 ) != IDYES )
		return;

	char p[PACKET_MAX_SIZE];
	int size;

	// send 0Eh
	size = bcp->MakePacket(p, 0x0E, 255);
	SendData(p, size);
}

void Cbnu_ctrlDlg::SwitchInterface()
{
	// setup button
	ENABLE_ITEM(IDC_SETUP, m_isIdle);
	
	// switch to current mode
	SwitchMode();
}

BOOL Cbnu_ctrlDlg::OnCommand(WPARAM wParam, LPARAM lParam)
{
	// radiobuttons - mode
	if (LOWORD(wParam) >= IDC_MODE1 && LOWORD(wParam) <= IDC_MODE7)
		if (LOWORD(wParam) - IDC_MODE1 != device)
		{
			device = LOWORD(wParam) - IDC_MODE1;
			SwitchMode();
			if (!m_isIdle && !m_isFlat)
				wndCloseAll();
		}

	// checkboxes - windows
	if (LOWORD(wParam) >= IDC_CHECK1 && LOWORD(wParam) <= IDC_CHECK1 + WND_MAX - 2)
		wndSwitch(LOWORD(wParam) - IDC_CHECK1);

	return CDialog::OnCommand(wParam, lParam);
}

Cbnu_ctrlDlg::~Cbnu_ctrlDlg()
{
	for (int i=0; i<PICS_COUNT; i++)
		::DeleteDC(dc_pic[i]);
}

void Cbnu_ctrlDlg::OnMmiExit()
{
	OnClose();
}

void Cbnu_ctrlDlg::OnMmiFlat()
{
	// switch flag
	m_isFlat = !( mm->GetMenuState(ID_MMI_FLAT, 0) & MF_CHECKED );
	mm->CheckMenuItem(ID_MMI_FLAT, m_isFlat ? MF_CHECKED : MF_UNCHECKED);
}

void Cbnu_ctrlDlg::OnMmiDemo()
{
	// switch flag
	m_isDemo = !( mm->GetMenuState(ID_MMI_DEMO, 0) & MF_CHECKED );
	mm->CheckMenuItem(ID_MMI_DEMO, m_isDemo ? MF_CHECKED : MF_UNCHECKED);

	// stop current real work
	if (m_isDemo && !m_isIdle)
		OnBnClickedStart();

	// working like real
	m_isIdle = !m_isDemo;

	// switch part of interface
	ENABLE_ITEM(IDC_SETUP, !m_isDemo);
	ENABLE_ITEM(IDC_START, !m_isDemo);

	// close all windows
	if (!m_isDemo)
		wndCloseAll();

	// switch to current mode(device)
	SwitchMode();
}

void Cbnu_ctrlDlg::OnMmiAbout()
{
	::ShellAbout(m_hWnd, titleVersion, aboutStuff, m_hIcon);
}
