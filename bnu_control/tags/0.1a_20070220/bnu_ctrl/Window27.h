// $Id$

#pragma once


// CWindow27 dialog

class CWindow27 : public CWindow
{
	DECLARE_DYNAMIC(CWindow27)

public:
	CWindow27(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow27();

	enum { IDD = IDD_WINDOW_27_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
};
