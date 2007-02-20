// $Id$

#pragma once


// WindowBA dialog

class CWindowBA : public CWindow
{
	DECLARE_DYNAMIC(CWindowBA)

public:
	CWindowBA(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowBA();

	enum { IDD = IDD_WINDOW_BA_DIALOG };

	CGridCtrl grid;

	bool is_on;

	void SwitchInterface();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedBaOn();
	afx_msg void OnBnClickedBaOff();
};
