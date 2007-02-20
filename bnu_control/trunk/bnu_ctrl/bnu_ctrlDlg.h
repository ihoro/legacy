// $Id$

#pragma once


// self
///////

class Cbnu_ctrlDlg;
extern Cbnu_ctrlDlg *mdlg;

// windows
//////////

#include "window.h"
#include "window01.h"
#include "window0B.h"
#include "window0D.h"
#include "window11.h"
#include "window12.h"
#include "window13.h"
#include "window16.h"
#include "window17.h"
#include "window1B.h"
#include "window1E.h"
#include "windowinfo.h"
#include "window19_20.h"
#include "window21.h"
#include "window22.h"
#include "window23.h"
#include "window24.h"
#include "window25.h"
#include "window26.h"
#include "window27.h"
#include "window2A.h"
#include "window2B.h"
#include "window32.h"
#include "window39.h"
#include "windowA0.h"
#include "windowA2.h"
#include "windowA4.h"
#include "windowA6.h"
#include "windowA8.h"
#include "windowAA.h"
#include "windowAC.h"
#include "windowAE.h"
#include "windowB1.h"
#include "windowB2.h"
#include "windowB5.h"
#include "windowB6.h"
#include "windowB8.h"
#include "windowBA.h"
#include "windowBC.h"
#include "windowD4.h"
#include "windowD6.h"
#include "windowD7.h"
#include "windowFC.h"
#include "windowFD.h"

#define WND_MAX 45			// without 0E, that hasn't window

#define WND_01 '\x2C'		// 44
#define WND_0E '\x2D'		// 45
#define WND_0B '\x01'		// 1
#define WND_0D '\x11'		// 17
#define WND_11 '\x02'		// 2
#define WND_12 '\x16'		// 22
#define WND_13 '\x13'		// 19
#define WND_16 '\x22'		// 34
#define WND_17 '\x17'		// 23
#define WND_19 '\x19'		// 25
#define WND_1B '\x03'		// 3
#define WND_1E '\x1D'		// 29
#define WND_20 '\x18'		// 24
#define WND_21 '\x14'		// 20
#define WND_22 '\x25'		// 37
#define WND_23 '\x1B'		// 27
#define WND_24 '\x15'		// 21
#define WND_25 '\x1A'		// 26
#define WND_26 '\x00'		// 0
#define WND_27 '\x12'		// 18
#define WND_2A '\x20'		// 32
#define WND_2B '\x21'		// 33
#define WND_32 '\x1C'		// 28
#define WND_39 '\x1E'		// 30
#define WND_A0 '\x0B'		// 11
#define WND_A2 '\x05'		// 5
#define WND_A4 '\x04'		// 4
#define WND_A6 '\x08'		// 8
#define WND_A8 '\x09'		// 9
#define WND_AA '\x0A'		// 10
#define WND_AC '\x0D'		// 13
#define WND_AE '\x0C'		// 12
#define WND_B1 '\x06'		// 6
#define WND_B2 '\x07'		// 7
#define WND_B5 '\x26'		// 38
#define WND_B6 '\x0E'		// 14
#define WND_B8 '\x27'		// 39
#define WND_BA '\x28'		// 40
#define WND_BC '\x29'		// 41
#define WND_D4 '\x1F'		// 31
#define WND_D6 '\x23'		// 35
#define WND_D7 '\x24'		// 36
#define WND_FC '\x0F'		// 15
#define WND_FD '\x10'		// 16



// BCP
#define GET_ONLINE_STATUS_TIMEOUT	5000	// ms

// last selected device
#define DEVICE	mdlg->device

// COM-port speed array
extern int comSpeed[];

// labels for common request buttons
extern CString TITLE_GET;					// label for 'get' buttons
extern CString TITLE_SET;					// label for 'set' buttons
extern CString TITLE_ON;					// label for 'on' buttons
extern CString TITLE_OFF;					// label for 'off' buttons

// files common defines
#define FILE_PATH_NAME_MAX_SIZE		1024
#define FILE_NAME_MAX_SIZE			256

// some useful macroses
#define ENABLE_ITEM(id,enable)	GetDlgItem(id)->EnableWindow(enable)
#define SHOW_ITEM(id,show)		GetDlgItem(id)->ShowWindow( (show) ? SW_NORMAL : SW_HIDE )
#define ENABLE_MMI(id,enable)	mm->EnableMenuItem(id, (enable) ? MF_ENABLED : MF_GRAYED)


//////////////
// main dialog
//////////////

class Cbnu_ctrlDlg : public CDialog
{
public:
	Cbnu_ctrlDlg(CWnd* pParent = NULL);
	virtual ~Cbnu_ctrlDlg();

	enum { IDD = IDD_BNU_CTRL_DIALOG };

	// main menu
	CMenu *mm;

	// settings
	void load_ini();
	void save_ini();

	// status info
	INT64U tx_bytes;
	INT64U tx_packets;

	// data sending function
	int SendData(char *pData, int count);

	// windows
	CWindow *wnd[WND_MAX];					// pointer to each opened window
	bool wndOpen(unsigned char id);			// try to open some window
	bool wndClose(unsigned char id);		// try to close some window
	void wndCloseAll();						// try to close all opened windows
	void wndSwitch(unsigned char id);		// try to switch window on or off
	void SwitchMode();						// enable/disable checkboxes (or something else) of windows that is dependent on current selected device

	// last selected device
	int device;

	// setup-box / COM-ports
	void ShowSetupBox(bool aShow);			// show/hide setup panel
	bool m_setupMode;
	CComboBox m_cmbSetupCOM;
	char m_setupCOM;
	CComboBox m_cmbSetupSpeed;
	char m_setupSpeed;
	CByteArray m_com_list;					// generated list of free COM-ports
	bool OpenCOMPort();						// try to open COM-port

	// program state
	bool m_isIdle;							// if program is doing nothing
	bool m_isDemo;							// if demo mode is turned on
	bool m_isFlat;							// if flat mode is turned on

	// show data of 88h packet
	void Show88(CWnd *w, INT8U *data_ptr);

	// main buttons handlers at client area
	afx_msg void OnBnClickedSetup();
	afx_msg void OnBnClickedSetupOk();
	afx_msg void OnBnClickedStart();
	afx_msg void OnBnClickedSystemReset();
	afx_msg void OnBnClickedRequestsReset();

protected:

	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support

	HICON m_hIcon;
	virtual void OnCancel() {};
	virtual void OnOK() {};
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);

	void SwitchInterface();

	virtual BOOL OnInitDialog();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnMmiExit();
	afx_msg void OnMmiAbout();
	afx_msg void OnMmiDemo();
	afx_msg void OnClose();
	afx_msg void OnMmiFlat();
};