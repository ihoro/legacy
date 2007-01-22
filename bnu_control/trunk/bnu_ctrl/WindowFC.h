#pragma once


// CWindowFC dialog

class CWindowFC : public CWindow
{
	DECLARE_DYNAMIC(CWindowFC)

public:
	CWindowFC(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowFC();

	enum { IDD = IDD_WINDOW_FC_DIALOG };

	CGridCtrl grid;

	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
};
