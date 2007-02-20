// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowA4 dialog

IMPLEMENT_DYNAMIC(CWindowA4, CWindow)
CWindowA4::CWindowA4(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

void CWindowA4::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


void CWindowA4::ShowParams(FP32 course, FP32 roll, FP32 different,
						   FP32 course_RMS, FP32 roll_RMS, FP32 different_RMS)
{
	if (isMinimized)
		return;

	CString s;

	// show course
	s.Format("%.2f", course);
	SetDlgItemText(IDC_A4_COURSE, s);

	// show roll
	s.Format("%.2f", roll);
	SetDlgItemText(IDC_A4_ROLL, s);

	// show different
	s.Format("%.2f", different);
	SetDlgItemText(IDC_A4_DIFFERENT, s);

	// show courseCKO
	s.Format("%.2f", course_RMS);
	SetDlgItemText(IDC_A4_CKO_COURSE, s);

	// show rollCKO
	s.Format("%.2f", roll_RMS);
	SetDlgItemText(IDC_A4_CKO_ROLL, s);

	// show differentCKO
	s.Format("%.2f", different_RMS);
	SetDlgItemText(IDC_A4_CKO_DIFFERENT, s);
}


BEGIN_MESSAGE_MAP(CWindowA4, CWindow)
END_MESSAGE_MAP()


// CWindowA4 message handlers
