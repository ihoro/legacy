// $Id$

#pragma once


// CWindowB6 dialog

class CWindowB6 : public CWindow
{
	DECLARE_DYNAMIC(CWindowB6)

public:
	CWindowB6(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowB6();

	enum { IDD = IDD_WINDOW_B6_DIALOG };

	CGridCtrl grid;
	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedB6Set();
};
