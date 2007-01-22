#pragma once


// CWindowInfo dialog

class CWindow19_20;

class CWindowInfo : public CWindow
{
	DECLARE_DYNAMIC(CWindowInfo)

public:
	CWindowInfo(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindowInfo();

	enum { IDD = IDD_WINDOW_INFO_DIALOG };

	CWindow19_20 *dlg;

	INT8U flat_id;			// 0, ..., 55
	INT8U system;			// 1/2
	INT8U num;				// 1, ..., 32/24

	void ShowInfo();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
};
