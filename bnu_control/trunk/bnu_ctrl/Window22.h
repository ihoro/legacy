// $Id$

#pragma once


// CWindow22 dialog

class CWindow22 : public CWindow
{
	DECLARE_DYNAMIC(CWindow22)

public:
	CWindow22(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow22();

	enum { IDD = IDD_WINDOW_22_DIALOG };

	CGridCtrl grid;

	INT8U rnpi_got;
	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked22Get();
	afx_msg void OnBnClicked22Set();
};
