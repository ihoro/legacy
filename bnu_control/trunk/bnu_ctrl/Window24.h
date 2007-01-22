// $Id$

#pragma once


// CWindow24 dialog

class CWindow24 : public CWindow
{
	DECLARE_DYNAMIC(CWindow24)

public:
	CWindow24(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow24();

	enum { IDD = IDD_WINDOW_24_DIALOG };

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
