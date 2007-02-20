// $Id$

#pragma once


// CWindow12 dialog

class CWindow12 : public CWindow
{
	DECLARE_DYNAMIC(CWindow12)

public:
	CWindow12(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow12();

	enum { IDD = IDD_WINDOW_12_DIALOG };

	CGridCtrl gps;
	CGridCtrl gln;

	// satellites map
	INT8U sat_map[56];
	void ClearSatMap();

	INT8U response_count;

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked12Set();
	afx_msg void OnBnClicked12ClearGps();
	afx_msg void OnBnClicked12ClearGln();
};
