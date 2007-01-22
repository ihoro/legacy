#pragma once


// CWindow1B dialog

class CWindow1B : public CWindow
{
	DECLARE_DYNAMIC(CWindow1B)

public:
	CWindow1B(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow1B();

	enum { IDD = IDD_WINDOW_1B_DIALOG };

	CGridCtrl grid;

	virtual void tmr_do();

	void hide_device(int dev);

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
};
