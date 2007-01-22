#pragma once


// CWindow0B dialog

class CWindow0B : public CWindow
{
	DECLARE_DYNAMIC(CWindow0B)

public:
	CWindow0B(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	~CWindow0B();

	enum { IDD = IDD_WINDOW_0B_DIALOG };

	int i0, i1;		// port-combobox list of items
	INT8U get_port();
	int get_index(INT8U x);

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked0bGet();
	afx_msg void OnBnClicked0bSet();
};
