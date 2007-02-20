// $Id$

#pragma once


// CWindowB2 dialog

class CWindowB2 : public CWindow
{
	DECLARE_DYNAMIC(CWindowB2)

public:
	CWindowB2(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowB2();

	enum { IDD = IDD_WINDOW_B2_DIALOG };

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedB2Get();
	afx_msg void OnBnClickedB2Set();
};
