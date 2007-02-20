// $Id$

#pragma once


// CWindowD4 dialog

class CWindowD4 : public CWindow
{
	DECLARE_DYNAMIC(CWindowD4)

public:
	CWindowD4(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowD4();

	enum { IDD = IDD_WINDOW_D4_DIALOG };

	CGridCtrl grid;
	CGridCtrl grid2;

	virtual void req_periodic(INT8U period);
	virtual void req_off();
	virtual void req_once();

	virtual void tmr_do();

	virtual BOOL OnInitDialog();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
};
