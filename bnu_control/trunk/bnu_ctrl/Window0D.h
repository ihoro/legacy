#pragma once


// CWindow0D dialog

class CWindow0D : public CWindow
{
	DECLARE_DYNAMIC(CWindow0D)

public:
	CWindow0D(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow0D();

	enum { IDD = IDD_WINDOW_0D_DIALOG };

	CGridCtrl grid;

	void SwitchInterface(bool OnOff);
	virtual void tmr_do();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();	
	afx_msg void OnBnClicked0dSet();
	afx_msg void OnCbnSetfocus0dCoordsSystem();
	afx_msg void OnCbnSetfocus0dSystem();
	afx_msg void OnEnSetfocus0dAngle();
	afx_msg void OnEnSetfocus0dCko();
	afx_msg void OnEnSetfocus0dPower();
};
