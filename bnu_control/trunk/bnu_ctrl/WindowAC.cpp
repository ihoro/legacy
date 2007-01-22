#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowAC dialog

INI_VALUE_INFO ivi_AC[] =
{
	{"course",		INI_TYPE_EDIT, IDC_AC_COURSE_NEW, 0},
	{"different",	INI_TYPE_EDIT, IDC_AC_DIFFERENT_NEW, 0},
	{"roll",		INI_TYPE_EDIT, IDC_AC_ROLL_NEW, 0}
};

IMPLEMENT_DYNAMIC(CWindowAC, CWindow)
CWindowAC::CWindowAC(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowAC::~CWindowAC()
{
	bcp->Handler[0xAD] = 0;
}

void gotAD_AC(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowAC*) (mdlg->wnd[WND_AC]) )
#define	BCP_PACKET		0xAD
#include "bcp2packet.h"

	CString s;

	// set for course
	s.Format("%.3f", _course);
	dlg->SetDlgItemText(IDC_AC_COURSE, s);

	// set for different
	s.Format("%.3f", _different);
	dlg->SetDlgItemText(IDC_AC_DIFFERENT, s);

	// set for roll
	s.Format("%.3f", _roll);
	dlg->SetDlgItemText(IDC_AC_ROLL, s);

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowAC::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindowAC, CWindow)
	ON_BN_CLICKED(IDC_AC_GET, OnBnClickedAcGet)
	ON_BN_CLICKED(IDC_AC_SET, OnBnClickedAcSet)
END_MESSAGE_MAP()


// CWindowAC message handlers

BOOL CWindowAC::OnInitDialog()
{
	// specify settings
	ini_init(3, ivi_AC);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_AC_GET, TITLE_GET);
	SetDlgItemText(IDC_AC_SET, TITLE_SET);

	OnBnClickedAcGet();

	return TRUE;
}

void CWindowAC::OnBnClickedAcGet()
{
	char *fmtOriginal = bcp->Format[0xAC];
	bcp->Format[0xAC] = "C";

	size = bcp->MakePacket(p, 0xAC, 0);
	bcp->Handler[0xAD] = gotAD_AC;
	tmr_on();
	sendp();

	bcp->Format[0xAC] = fmtOriginal;

	SwitchInterface(false);
}

void CWindowAC::OnBnClickedAcSet()
{
	CString s;

	// get new course
	GetDlgItemText(IDC_AC_COURSE_NEW, s);
	BCP_VALUE course;
	course.f = (float)atof(s);

	// get new different
	GetDlgItemText(IDC_AC_DIFFERENT_NEW, s);
	BCP_VALUE different;
	different.f = (float)atof(s);

	// get new roll
	GetDlgItemText(IDC_AC_ROLL_NEW, s);
	BCP_VALUE roll;
	roll.f = (float)atof(s);

	// set new values by sending ACh
	size = bcp->MakePacket(p, 0xAC, 1, course.L, different.L, roll.L);
	bcp->Handler[0xAD] = gotAD_AC;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

BOOL CWindowAC::OnCommand(WPARAM wParam, LPARAM lParam)
{
	if (HIWORD(wParam) == EN_KILLFOCUS)
	{
		CString s;
		GetDlgItemText(LOWORD(wParam), s);
		FixFloatStr(s.GetBuffer());
		SetDlgItemText(LOWORD(wParam), s);
	}

	return CWindow::OnCommand(wParam, lParam);
}

void CWindowAC::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_AC_GET, OnOff);
	ENABLE_ITEM(IDC_AC_SET, OnOff);
}

void CWindowAC::tmr_do()
{
	bcp->Handler[0xAD] = 0;
	SwitchInterface(true);
}