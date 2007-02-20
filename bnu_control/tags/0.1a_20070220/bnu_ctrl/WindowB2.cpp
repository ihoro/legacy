// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowB2 dialog

INI_VALUE_INFO ivi_B2[] =
{
	{"fki",		INI_TYPE_COMBOBOX, IDC_B2_FKI_NEW, 0},
	{"height",	INI_TYPE_COMBOBOX, IDC_B2_HEIGHT_NEW, 0},
	{"coords",	INI_TYPE_COMBOBOX, IDC_B2_COORDS_NEW, 0}
};

IMPLEMENT_DYNAMIC(CWindowB2, CWindow)
CWindowB2::CWindowB2(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowB2::~CWindowB2()
{
	bcp->Handler[0xC2] = 0;
}

void gotC2_B2(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowB2*) (mdlg->wnd[WND_B2]) )
#define	BCP_PACKET		0xC2
#include "bcp2packet.h"

	char s[20];

	// show FKI
	dlg->SendDlgItemMessage(IDC_B2_FKI_NEW, CB_GETLBTEXT, _fki, (LPARAM)s);
	dlg->SetDlgItemText(IDC_B2_FKI, s);

	// show height
	dlg->SendDlgItemMessage(IDC_B2_HEIGHT_NEW, CB_GETLBTEXT, _height, (LPARAM)s);
	dlg->SetDlgItemText(IDC_B2_HEIGHT, s);

	// show coords
	dlg->SendDlgItemMessage(IDC_B2_COORDS_NEW, CB_GETLBTEXT, _coords, (LPARAM)s);
	dlg->SetDlgItemText(IDC_B2_COORDS, s);

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowB2::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindowB2, CWindow)
	ON_BN_CLICKED(IDC_B2_GET, OnBnClickedB2Get)
	ON_BN_CLICKED(IDC_B2_SET, OnBnClickedB2Set)
END_MESSAGE_MAP()


// CWindowB2 message handlers

BOOL CWindowB2::OnInitDialog()
{
	// specify settings
	ini_init(3, ivi_B2);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_B2_GET, TITLE_GET);
	SetDlgItemText(IDC_B2_SET, TITLE_SET);

	OnBnClickedB2Get();

	return TRUE;
}

void CWindowB2::OnBnClickedB2Get()
{
	char *fmtOriginal = bcp->Format[0xB2];
	bcp->Format[0xB2] = "";

	size = bcp->MakePacket(p, 0xB2);
	bcp->Handler[0xC2] = gotC2_B2;
	tmr_on();
	sendp();

	bcp->Format[0xB2] = fmtOriginal;

	SwitchInterface(false);
}

void CWindowB2::OnBnClickedB2Set()
{
	INT16U state;

	if (DEVICE)
		state = 0x0400 << DEVICE;
	else
		state = 0xF000;

	state |= SendDlgItemMessage(IDC_B2_FKI_NEW, CB_GETCURSEL, 0, 0) << 1;
	state |= SendDlgItemMessage(IDC_B2_HEIGHT_NEW, CB_GETCURSEL, 0, 0) << 2;
	state |= SendDlgItemMessage(IDC_B2_COORDS_NEW, CB_GETCURSEL, 0, 0) << 3;

	size = bcp->MakePacket(p, 0xB2, state);
	bcp->Handler[0xC2] = gotC2_B2;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindowB2::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_B2_GET, OnOff);
	ENABLE_ITEM(IDC_B2_SET, OnOff);
}

void CWindowB2::tmr_do()
{
	bcp->Handler[0xC2] = 0;
	SwitchInterface(true);
}