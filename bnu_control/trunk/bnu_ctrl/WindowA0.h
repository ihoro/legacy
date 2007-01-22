#pragma once


// CWindowA0 dialog

class CWindowA0 : public CWindow
{
	DECLARE_DYNAMIC(CWindowA0)

public:
	CWindowA0(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowA0();

	enum { IDD = IDD_WINDOW_A0_DIALOG };

	CGridCtrl grid;

	char task;
	FP32 value[2][22];
	void FixValues();

	void SwitchInterface(bool OnOff);

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnCbnSelchangeA0Task();
};
