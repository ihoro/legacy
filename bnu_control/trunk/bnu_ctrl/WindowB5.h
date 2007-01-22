// $Id$

#pragma once


// CWindowB5 dialog

class CWindowB5 : public CWindow
{
	DECLARE_DYNAMIC(CWindowB5)

public:
	CWindowB5(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowB5();

	enum { IDD = IDD_WINDOW_B5_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedB5Reset();
};
