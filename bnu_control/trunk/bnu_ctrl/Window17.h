#pragma once


// CWindow17 dialog

class CWindow17 : public CWindow
{
	DECLARE_DYNAMIC(CWindow17)

public:
	CWindow17(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow17();

	enum { IDD = IDD_WINDOW_17_DIALOG };

	CGridCtrl grid;

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked17Get();
	afx_msg void OnBnClicked17SetDopler();
	afx_msg void OnBnClicked17Set();
};
