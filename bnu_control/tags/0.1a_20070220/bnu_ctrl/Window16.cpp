// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow16 dialog

INT8U dl_16[] =
{
	0x80,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

INI_VALUE_INFO ivi_16[] =
{
	{"num",	INI_TYPE_EDIT,	IDC_16_NUM_NEW, 0},
	{"BT",	INI_TYPE_EDIT,	IDC_16_BT_NEW, 0}
};

IMPLEMENT_DYNAMIC(CWindow16, CWindow)
CWindow16::CWindow16(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow16::~CWindow16()
{
	bcp->Handler[0x56] = 0;
}

void got56_16(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow16*) (mdlg->wnd[WND_16]) )
#define	BCP_PACKET		0x56
#include "bcp2packet.h"

	// check code before if need
	if (dlg->number < 33)
		if (_BT != dlg->code)
			return;

	if (!dlg->rnpi_add(_rnpi_full))
		return;

	if (dlg->rnpi_done())
	{
		if (dlg->number < 33)
		{
			// show num
			dlg->SetDlgItemInt(IDC_16_NUM, dlg->number, false);

			// show BT
			CString s;
			IntToHEXStr(_BT, s.GetBufferSetLength(8)); 
			dlg->SetDlgItemText(IDC_16_BT, s);
		}
		else
		{
			dlg->SetDlgItemText(IDC_16_NUM, "");
			dlg->SetDlgItemText(IDC_16_BT, "Выключен");
		}

		dlg->tmr_off();
		dlg->tmr_do();
	}

#undef	dlg
#include "bcp2packet.h"

}

void CWindow16::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CWindow16, CWindow)
	ON_BN_CLICKED(IDC_16_SET, OnBnClicked16Set)
	ON_BN_CLICKED(IDC_16_OFF, OnBnClicked16Off)
END_MESSAGE_MAP()

// CWindow16 message handlers

BOOL CWindow16::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_16);

	// init device selector
	ds_init(dl_16);

	// init edits
	SendDlgItemMessage(IDC_16_NUM_NEW, EM_LIMITTEXT, 2, 0);
	SendDlgItemMessage(IDC_16_BT_NEW, EM_LIMITTEXT, 8, 0);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_16_SET, TITLE_SET);

	return TRUE;
}

void CWindow16::OnBnClicked16Set()
{
	// get num
	number = GetDlgItemInt(IDC_16_NUM_NEW);
	if (number > 32)
	{
		number = 0;
		SetDlgItemInt(IDC_16_NUM_NEW, number);
	}

	// get BT [hex]
	CString s;
	GetDlgItemText(IDC_16_BT_NEW, s);
	FixHEXStr(s.GetBuffer());
	SetDlgItemText(IDC_16_BT_NEW, s);
	code = HEXStrToInt(s.GetBuffer());

	// send 16h
	size = bcp->MakePacket(p, 0x16,	ds_get_rnpi_need() * 50	+ number, code);
	rnpi_init(0xff, 0);
	bcp->Handler[0x56] = got56_16;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindow16::OnBnClicked16Off()
{
	number = 33;

	size = bcp->MakePacket(p, 0x16, ds_get_rnpi_need() * 50 + 33, 0);
	rnpi_init(0xff, 1);
	bcp->Handler[0x56] = got56_16;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindow16::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_16_OFF, OnOff);
	ENABLE_ITEM(IDC_16_SET, OnOff);
}

void CWindow16::tmr_do()
{
	bcp->Handler[0x56] = 0;
	SwitchInterface(true);
}