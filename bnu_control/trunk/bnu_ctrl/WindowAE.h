#pragma once


// CWindowAE dialog

// calibration timeout
#define TIMER_AE_CALIB 15*60*1000		// 15 minutes

class CWindowAE : public CWindow
{
	DECLARE_DYNAMIC(CWindowAE)

public:
	CWindowAE(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowAE();

	enum { IDD = IDD_WINDOW_AE_DIALOG };

	bool beganStart;
	bool beganCancel;
	bool beganGet;
	bool dynamic;

	void SwitchInterface();
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedAeStart();
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedAeResults();
};
