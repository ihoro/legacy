#pragma once


// CWindow1E dialog

class CWindow1E : public CWindow
{
	DECLARE_DYNAMIC(CWindow1E)

public:
	CWindow1E(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow1E();

	enum { IDD = IDD_WINDOW_1E_DIALOG };

	CGridCtrl grid;
	CGridCtrl grid2;

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
};
