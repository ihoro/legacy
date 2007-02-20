// $Id$

#pragma once


// CWindowBC dialog

class CWindowBC : public CWindow
{
	DECLARE_DYNAMIC(CWindowBC)

public:
	CWindowBC(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowBC();

	enum { IDD = IDD_WINDOW_BC_DIALOG };

	CGridCtrl grid;

	bool is_on;

	void SwitchInterface();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedBcOn();
	afx_msg void OnBnClickedBcOff();
};
