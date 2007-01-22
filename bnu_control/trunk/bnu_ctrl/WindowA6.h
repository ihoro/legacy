#pragma once


// CWindowA6 dialog

class CWindowA6 : public CWindow
{
	DECLARE_DYNAMIC(CWindowA6)

public:
	CWindowA6(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowA6();

	enum { IDD = IDD_WINDOW_A6_DIALOG };

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedA6Set();
};
