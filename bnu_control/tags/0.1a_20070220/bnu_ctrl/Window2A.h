// $Id$

#pragma once


// CWindow2A dialog

class CWindow2A : public CWindow
{
	DECLARE_DYNAMIC(CWindow2A)

public:
	CWindow2A(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow2A();

	enum { IDD = IDD_WINDOW_2A_DIALOG };

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
