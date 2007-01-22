#pragma once


// CWindow01 dialog

class CWindow01 : public CWindow
{
	DECLARE_DYNAMIC(CWindow01)

public:
	CWindow01(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);

	enum { IDD = IDD_WINDOW_01_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked01Reset();
};
