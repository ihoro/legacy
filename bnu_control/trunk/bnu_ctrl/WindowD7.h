#pragma once


// CWindowD7 dialog

class CWindowD7 : public CWindow
{
	DECLARE_DYNAMIC(CWindowD7)

public:
	CWindowD7(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowD7();

	enum { IDD = IDD_WINDOW_D7_DIALOG };

	INT8U mode;
	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
protected:
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
public:
	afx_msg void OnBnClickedD7Get();
	afx_msg void OnBnClickedD7Set();
};
