#pragma once


// CWindow25 dialog

class CWindow25 : public CWindow
{
	DECLARE_DYNAMIC(CWindow25)

public:
	CWindow25(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow25();

	enum { IDD = IDD_WINDOW_25_DIALOG };

	CGridCtrl grid;
	CGridCtrl grid2;

	bool is_on;

	void SwitchInterface();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClicked25On();
	afx_msg void OnBnClicked25Off();
};
