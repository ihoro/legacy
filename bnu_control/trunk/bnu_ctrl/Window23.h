#pragma once


// CWindow23 dialog

class CWindow23 : public CWindow
{
	DECLARE_DYNAMIC(CWindow23)

public:
	CWindow23(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow23();

	enum { IDD = IDD_WINDOW_23_DIALOG };

	CGridCtrl grid;

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked23Get();
	afx_msg void OnBnClicked23Set();
};
