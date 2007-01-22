#pragma once


// CWindow2B dialog

class CWindow2B : public CWindow
{
	DECLARE_DYNAMIC(CWindow2B)

public:
	CWindow2B(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow2B();

	enum { IDD = IDD_WINDOW_2B_DIALOG };

	CGridCtrl grid;

	virtual void req_periodic(INT8U period);
	virtual void req_off();
	virtual void req_once();

	virtual void tmr_do();

	virtual BOOL OnInitDialog();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
};
