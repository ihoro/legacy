// $Id$

#pragma once


// CWindowB8 dialog

class CWindowB8 : public CWindow
{
	DECLARE_DYNAMIC(CWindowB8)

public:
	CWindowB8(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowB8();

	enum { IDD = IDD_WINDOW_B8_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedB8Reset();
};
