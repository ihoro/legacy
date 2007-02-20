// $Id$

#pragma once


// CWindowFD dialog

class CWindowFD : public CWindow
{
	DECLARE_DYNAMIC(CWindowFD)

public:
	CWindowFD(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowFD();

	enum { IDD = IDD_WINDOW_FD_DIALOG };

	CGridCtrl grid;

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
