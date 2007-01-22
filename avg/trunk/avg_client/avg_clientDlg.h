// avg_clientDlg.h : header file
//

#pragma once


#define ENABLE_ITEM(id,enable)	GetDlgItem(id)->EnableWindow(enable)


// Cavg_clientDlg dialog
class Cavg_clientDlg : public CDialog
{
// Construction
public:
	Cavg_clientDlg(CWnd* pParent = NULL);	// standard constructor
	virtual ~Cavg_clientDlg();

// Dialog Data
	enum { IDD = IDD_AVG_CLIENT_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


	IClassFactory *pcf;
	IUnknown **pobj;
	unsigned obj_count;


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedCalc();
	afx_msg void OnBnClickedCreateObject();
	afx_msg void OnBnClickedFreeObject();
	afx_msg void OnBnClickedGetClassObject();
	afx_msg void OnBnClickedCoRelease();
	afx_msg void OnBnClickedButton2();
};
