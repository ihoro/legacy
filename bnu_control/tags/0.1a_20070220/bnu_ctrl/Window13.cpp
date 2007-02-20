// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow13 dialog

INT8U dl_13[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

INI_VALUE_INFO ivi_13[] =
{
	{"req_periodic",	INI_TYPE_CHECKBOX,	IDC_13_PERIODIC, 0},
	{"req_period",		INI_TYPE_EDIT,		IDC_13_PERIOD, 0}
};

IMPLEMENT_DYNAMIC(CWindow13, CWindow)
CWindow13::CWindow13(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow13::~CWindow13()
{
	bcp->Handler[0x41] = 0;
	req_free();
}

void got41_13(INT8U *data_ptr, INT32U data_size)
{
	
#define dlg				( (CWindow13*) (mdlg->wnd[WND_13]) )
#define	BCP_PACKET		0x41
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// if once then stop catching
	if (dlg->req_if_once())
	{
		dlg->tmr_off();
		bcp->Handler[0x41] = 0;
	}
	// reset rnpi-checker
	else
		dlg->rnpi_init(0xff, 0);

	if (dlg->isMinimized)
		return;

	CString s;

	// angle
	s.Format("%.2f", _angle);
	dlg->SetDlgItemText(IDC_13_ANGLE, s);

	// speed
	s.Format("%.2f", _speed);
	dlg->SetDlgItemText(IDC_13_SPEED, s);

	// time
	dlg->SetDlgItemInt(IDC_13_TIME, _time, 0);

#undef	dlg
#include "bcp2packet.h"

}

void CWindow13::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindow13, CWindow)
END_MESSAGE_MAP()


// CWindow13 message handlers

BOOL CWindow13::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_13);

	// init device selector
	ds_init(dl_13);
				   
	CWindow::OnInitDialog();

	// init periodic handler
	req_init(IDC_13_ONCE, IDC_13_PERIODIC, IDC_13_PERIOD);

	return TRUE;
}

void CWindow13::req_periodic(INT8U period)
{
	size = bcp->MakePacket(p, 0x13, ds_get(), period);
	bcp->Handler[0x41] = got41_13;
	rnpi_init(0xff, 0);
	sendp();
}

void CWindow13::req_off()
{
	size = bcp->MakePacket(p, 0x13, ds_get(), 0x00);
	sendp();
	bcp->Handler[0x41] = 0;
}

void CWindow13::req_once()
{
	char *fmtOriginal = bcp->Format[0x13];
	bcp->Format[0x13] = "C";

	size = bcp->MakePacket(p, 0x13, ds_get());
	bcp->Handler[0x41] = got41_13;
	rnpi_init(0xff, 0);
	sendp();

	bcp->Format[0x13] = fmtOriginal;
}

void CWindow13::tmr_do()
{
	bcp->Handler[0x41] = 0;
}