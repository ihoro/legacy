// $Id$

#pragma once


// CWindowD6 dialog

class CWindowD6 : public CWindow
{
	DECLARE_DYNAMIC(CWindowD6)

public:
	CWindowD6(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowD6();

	enum { IDD = IDD_WINDOW_D6_DIALOG };

	int OnOff;
	bool OnOrOff;
	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	CFont fntState;

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg void OnBnClickedD6On();
	afx_msg void OnBnClickedD6Off();
};
