#pragma once


// info windows
#define IWND_MAX	56									// max count of info windows		


// CWindow19_20 dialog

class CWindow19_20 : public CWindow
{
	DECLARE_DYNAMIC(CWindow19_20)

public:
	CWindow19_20(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow19_20();

	enum { IDD = IDD_WINDOW_19_20_DIALOG };

	void SwitchInterface(bool OnOff, bool ProgressBar);

	// grids
	CGridCtrl gps;
	CGridCtrl gln;

	void ResetCells();									// set all cells into unknown state

	// progress timer's counter
	int tmr_counter;

	// time out timer
	virtual void tmr_do();

	// what ofn is used by this window
	int ofn_id;

	// info
	char *si;											// satellite info
	int si_size;										// size of si
	char si_ok[56];										// =0/1, if 'si' is present or not for certain satellite
	int sat_gotten;										// count of gotten sats info

	void ResetSatOk();									// it will reset si_ok to value 0x03 (unknown state)
	bool gotten(INT8U *data_ptr, INT32U data_size);		// handler of response packets
	void UpdateSatInfo(INT8U system, INT8U num);		// update cell's state and info

	// info windows
	CWindowInfo *iwnd[IWND_MAX];
	bool iwndOpen(unsigned char id);					// try to open some window
	bool iwndClose(unsigned char id);					// try to close some window
	void iwndCloseAll();								// try to close all opened windows
	void iwndSwitch(unsigned char id);					// try to switch window on or off

	virtual BOOL OnInitDialog();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	afx_msg void OnGpsDblClick(NMHDR *pNotifyStruct, LRESULT* pResult);
	afx_msg void OnGlnDblClick(NMHDR *pNotifyStruct, LRESULT* pResult);

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClicked1920Save();
	afx_msg void OnBnClicked1920Get();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnBnClicked1920Set();
	afx_msg void OnBnClicked1920Load();
};
