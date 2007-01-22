#pragma once


// CWindowA8 dialog

class CWindowA8 : public CWindow
{
	DECLARE_DYNAMIC(CWindowA8)

public:
	CWindowA8(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowA8();

	enum { IDD = IDD_WINDOW_A8_DIALOG };

	CGridCtrl grid;

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedA8Set();
};
