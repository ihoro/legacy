#pragma once


// CWindowB1 dialog

class CWindowB1 : public CWindow
{
	DECLARE_DYNAMIC(CWindowB1)

public:
	CWindowB1(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowB1();

	enum { IDD = IDD_WINDOW_B1_DIALOG };

	CGridCtrl grid;
	INT8U hour;
	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedB1Get();
};
