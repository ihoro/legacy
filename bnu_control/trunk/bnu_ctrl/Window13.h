#pragma once


// CWindow13 dialog

class CWindow13 : public CWindow
{
	DECLARE_DYNAMIC(CWindow13)

public:
	CWindow13(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow13();

	enum { IDD = IDD_WINDOW_13_DIALOG };

	virtual void req_periodic(INT8U period);
	virtual void req_off();
	virtual void req_once();

	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
};
