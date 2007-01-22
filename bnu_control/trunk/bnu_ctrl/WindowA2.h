#pragma once


// CWindowA2 dialog

class CWindowA2 : public CWindow
{
	DECLARE_DYNAMIC(CWindowA2)

public:
	CWindowA2(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowA2();

	enum { IDD = IDD_WINDOW_A2_DIALOG };

	CGridCtrl grid;

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedA2Get();
	afx_msg void OnBnClickedA2Set();
};
