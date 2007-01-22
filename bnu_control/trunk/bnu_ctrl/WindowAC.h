#pragma once


// CWindowAC dialog

class CWindowAC : public CWindow
{
	DECLARE_DYNAMIC(CWindowAC)

public:
	CWindowAC(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowAC();

	enum { IDD = IDD_WINDOW_AC_DIALOG };

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedAcGet();
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedAcSet();	
};
