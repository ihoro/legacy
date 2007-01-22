#pragma once


// CWindow11 dialog

class CWindow11 : public CWindow
{
	DECLARE_DYNAMIC(CWindow11)

public:
	CWindow11(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	~CWindow11();

	enum { IDD = IDD_WINDOW_11_DIALOG };

	bool beganStart;
	bool beganGet;

	bool no_info;						// flag for first SetDlgItemText

	void rnpi_my_init(INT8U mask);

	INT8U GetDevice();
	void SwitchInterface();

	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClicked11Begin();
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked11Results();
};
