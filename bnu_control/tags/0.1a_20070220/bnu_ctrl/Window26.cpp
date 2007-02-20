// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow26 dialog

INT8U dl_26[] =
{
	0xFF,
	0xFF,
	0x00,
	0x10,
	0x20,
	0x40,
	0xF0
};

IMPLEMENT_DYNAMIC(CWindow26, CDialog)
CWindow26::CWindow26(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow26::~CWindow26()
{
	bcp->Handler[0x54] = 0;
}

void got54_26(INT8U *data_ptr, INT32U data_size)
{

#define dlg			( (CWindow26*) (mdlg->wnd[WND_26]) )

	CString s, s2;

	s.LoadString(IDS_IS_ONLINE);
	mdlg->GetDlgItemText(IDC_MODE1 + dlg->device, s2);
	s += s2;
	s.AppendChar('.');

	dlg->SetDlgItemText(IDC_26_STATUS, s);
	dlg->tmr_off();
	bcp->Handler[0x54] = 0;

#undef	dlg

}

void CWindow26::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CWindow26, CWindow)
END_MESSAGE_MAP()


// CWindow26 message handlers

BOOL CWindow26::OnInitDialog()
{
	CWindow::OnInitDialog();

	// show performing text
	CString s;
	s.LoadString(IDS_PERFORMING);
	SetDlgItemText(IDC_26_STATUS, s);

	// init device selector
	ds_init(dl_26);

	// send request
	size = bcp->MakePacket(p, 0x26, ds_get());
	bcp->Handler[0x54] = got54_26;
	tmr_on(0, GET_ONLINE_STATUS_TIMEOUT);
	sendp();

	return TRUE;
}

void CWindow26::tmr_do()
{
	CString s, s2;

	s.LoadString(IDS_IS_NOT_ONLINE);
	mdlg->GetDlgItemText(IDC_MODE1 + device, s2);
	s += s2;
	s.AppendChar('.');

	SetDlgItemText(IDC_26_STATUS, s);
	bcp->Handler[0x54] = 0;
}