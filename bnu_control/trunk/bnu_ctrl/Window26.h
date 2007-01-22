#pragma once


// CWindow26 dialog

class CWindow26 : public CWindow
{
	DECLARE_DYNAMIC(CWindow26)

public:
	CWindow26(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	~CWindow26();

	enum { IDD = IDD_WINDOW_26_DIALOG };

	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
};
