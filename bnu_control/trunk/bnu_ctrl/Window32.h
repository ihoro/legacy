// $Id$

#pragma once


// CWindow32 dialog

class CWindow32 : public CWindow
{
	DECLARE_DYNAMIC(CWindow32)

public:
	CWindow32(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow32();

	enum { IDD = IDD_WINDOW_32_DIALOG };

	CGridCtrl grid;

	BCP_VALUE v[9];
	INT8U req_type;

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked32Set();
	afx_msg void OnBnClicked32Time();
};
