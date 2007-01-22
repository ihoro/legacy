#pragma once


// CWindow16 dialog

class CWindow16 : public CWindow
{
	DECLARE_DYNAMIC(CWindow16)

public:
	CWindow16(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow16();

	enum { IDD = IDD_WINDOW_16_DIALOG };

	INT8U number;
	INT32U code;
	virtual BOOL OnInitDialog();
	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
	
public:
	afx_msg void OnBnClicked16Set();
	afx_msg void OnBnClicked16Off();
};
