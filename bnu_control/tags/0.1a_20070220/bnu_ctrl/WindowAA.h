// $Id$

#pragma once


// CWindowAA dialog

class CWindowAA : public CWindow
{
	DECLARE_DYNAMIC(CWindowAA)

public:
	CWindowAA(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowAA();

	enum { IDD = IDD_WINDOW_AA_DIALOG };

	CGridCtrl grid;
	CGridCtrl grid2;

	INT8U point;

	virtual void req_periodic(INT8U period);
	virtual void req_off();
	virtual void req_once();

	virtual void tmr_do();

	virtual BOOL OnInitDialog();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnEnChangeAaNum();
};
