#pragma once


// CWindow21 dialog

class CWindow21 : public CWindow
{
	DECLARE_DYNAMIC(CWindow21)

public:
	CWindow21(CWnd* pParent = 0, PROCCLOSE procClose = 0, char wndID = 0);
	virtual ~CWindow21();

	enum { IDD = IDD_WINDOW_21_DIALOG };

	bool waiting;						// if request has been sent
	void ShowInfo(INT8U *data_ptr);

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
