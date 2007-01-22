#pragma once


// CWindowA4 dialog

class CWindowA4 : public CWindow
{
	DECLARE_DYNAMIC(CWindowA4)

public:
	CWindowA4(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);

	enum { IDD = IDD_WINDOW_A4_DIALOG };

	void ShowParams(FP32 course, FP32 roll, FP32 different,
					FP32 courseCKO, FP32 rollCKO, FP32 differentCKO);

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
};
