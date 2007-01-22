#pragma once


// CWindow39 dialog

class CWindow39 : public CWindow
{
	DECLARE_DYNAMIC(CWindow39)

public:
	CWindow39(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow39();

	enum { IDD = IDD_WINDOW_39_DIALOG };

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
