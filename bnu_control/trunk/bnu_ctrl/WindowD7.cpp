#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowD7 dialog

INT8U dl_D7[] =
{
	0x80,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

INI_VALUE_INFO ivi_D7[] =
{
	{"accel",		INI_TYPE_EDIT,		IDC_D7_ACCEL, 0},
	{"rate",		INI_TYPE_COMBOBOX,	IDC_D7_RATE, 0},
	{"interval",	INI_TYPE_EDIT,		IDC_D7_INTERVAL, 0},
	{"category1",	INI_TYPE_EDIT,		IDC_D7_CATEGORY1, 0},
	{"category2",	INI_TYPE_EDIT,		IDC_D7_CATEGORY2, 0},
	{"time1",		INI_TYPE_COMBOBOX,	IDC_D7_TIME1, 0},
	{"time2",		INI_TYPE_COMBOBOX,	IDC_D7_TIME2, 0},
	{"time3",		INI_TYPE_COMBOBOX,	IDC_D7_TIME3, 0},
	{"time4",		INI_TYPE_COMBOBOX,	IDC_D7_TIME4, 0},
	{"time5",		INI_TYPE_CHECKBOX,	IDC_D7_TIME5, 0},
	{"time6",		INI_TYPE_EDIT,		IDC_D7_TIME6, 0},
	{"latency",		INI_TYPE_EDIT,		IDC_D7_LATENCY, 0},
	{"2d",			INI_TYPE_CHECKBOX,	IDC_D7_2D, 0},
	{"raim",		INI_TYPE_CHECKBOX,	IDC_D7_RAIM, 0},
	{"raim_type",	INI_TYPE_COMBOBOX,	IDC_D7_RAIM_TYPE, 0},
	{"one",			INI_TYPE_CHECKBOX,	IDC_D7_ONE, 0},
	{"rtcm",		INI_TYPE_CHECKBOX,	IDC_D7_RTCM, 0},
	{"sbas",		INI_TYPE_CHECKBOX,	IDC_D7_SBAS, 0},
	{"gbas",		INI_TYPE_CHECKBOX,	IDC_D7_GBAS, 0},
	{"count1",		INI_TYPE_EDIT,		IDC_D7_COUNT1, 0},
	{"count2",		INI_TYPE_EDIT,		IDC_D7_COUNT2, 0},
	{"count3",		INI_TYPE_EDIT,		IDC_D7_COUNT3, 0},
	{"mode",		INI_TYPE_RADIOBOX,	IDC_D7_MODE1 | (IDC_D7_MODE9 << 16), 0}
};

IMPLEMENT_DYNAMIC(CWindowD7, CWindow)
CWindowD7::CWindowD7(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowD7::~CWindowD7()
{
	bcp->Handler[0xE7] = 0;
}

void gotE7_D7(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowD7*) (mdlg->wnd[WND_D7]) )
#define	BCP_PACKET		0xE7
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	if (!dlg->rnpi_done())
		return;

	// show data
	CString s;
	int i;

	switch (_type)
	{
	case 1:
		s.Format("%.2f", _accel);
		dlg->SetDlgItemText(IDC_D7_ACCEL, s);
		break;

	case 2:
		switch (_rate)
		{
		case 1: i=0; break;
		case 2: i=1; break;
		case 5: i=2; break;
		case 10: i=3; break;
		default: i=0;
		}
		dlg->SendDlgItemMessage(IDC_D7_RATE, CB_SETCURSEL, i, 0);
		break;

	case 3:
		dlg->SetDlgItemInt(IDC_D7_INTERVAL, _interval, 0);
		break;

	case 4:
		dlg->SetDlgItemInt(IDC_D7_CATEGORY1, _category1, 0);
		dlg->SetDlgItemInt(IDC_D7_CATEGORY2, _category2, 0);
		break;

	case 5:
		dlg->SendDlgItemMessage(IDC_D7_TIME1, CB_SETCURSEL, _time1, 0);
		dlg->SendDlgItemMessage(IDC_D7_TIME2, CB_SETCURSEL, _time2, 0);
		dlg->SendDlgItemMessage(IDC_D7_TIME3, CB_SETCURSEL, _time3, 0);
		dlg->SendDlgItemMessage(IDC_D7_TIME4, CB_SETCURSEL, _time4 - 1, 0);
		dlg->CheckDlgButton(IDC_D7_TIME5, _time5);
		dlg->SetDlgItemInt(IDC_D7_TIME6, _time6, 0);
		break;

	case 6:
		s.Format("%.2f", _latency);
		dlg->SetDlgItemText(IDC_D7_LATENCY, s);
		break;

	case 7:
		dlg->CheckDlgButton(IDC_D7_RAIM, _RAIM);
		dlg->SendDlgItemMessage(IDC_D7_RAIM_TYPE, CB_SETCURSEL, _RAIM_type, 0);
		dlg->CheckDlgButton(IDC_D7_2D, _2D);
		dlg->CheckDlgButton(IDC_D7_ONE, _one);
		break;

	case 8:
		dlg->CheckDlgButton(IDC_D7_RTCM, _RTCM);
		dlg->CheckDlgButton(IDC_D7_SBAS, _SBAS);
		dlg->CheckDlgButton(IDC_D7_GBAS, _GBAS);
		break;

	case 9:
		dlg->SetDlgItemInt(IDC_D7_COUNT1, _count1, 0);
		dlg->SetDlgItemInt(IDC_D7_COUNT2, _count2, 0);
		dlg->SetDlgItemInt(IDC_D7_COUNT3, _count3, 0);
		break;
	}

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowD7::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindowD7, CWindow)
	ON_BN_CLICKED(IDC_D7_GET, OnBnClickedD7Get)
	ON_BN_CLICKED(IDC_D7_SET, OnBnClickedD7Set)
END_MESSAGE_MAP()


// CWindowD7 message handlers

BOOL CWindowD7::OnInitDialog()
{
	// specify settings
	ini_init(23, ivi_D7);

	// init device selector
	ds_init(dl_D7);

	SetDlgItemText(IDC_D7_GET, TITLE_GET);
	SetDlgItemText(IDC_D7_SET, TITLE_SET);

	SendDlgItemMessage(IDC_D7_INTERVAL, EM_LIMITTEXT, 5, 0);
	SendDlgItemMessage(IDC_D7_CATEGORY1, EM_LIMITTEXT, 1, 0);
	SendDlgItemMessage(IDC_D7_CATEGORY2, EM_LIMITTEXT, 2, 0);
	SendDlgItemMessage(IDC_D7_TIME6, EM_LIMITTEXT, 10, 0);
	SendDlgItemMessage(IDC_D7_COUNT1, EM_LIMITTEXT, 3, 0);
	SendDlgItemMessage(IDC_D7_COUNT2, EM_LIMITTEXT, 3, 0);
	SendDlgItemMessage(IDC_D7_COUNT3, EM_LIMITTEXT, 3, 0);

	CWindow::OnInitDialog();

	// get & set current mode
	mode = GetCheckedRadioButton(IDC_D7_MODE1, IDC_D7_MODE9) - IDC_D7_MODE1 + 1;
	SwitchInterface(true);

	return TRUE;
}

void CWindowD7::SwitchInterface(bool OnOff)
{
	// mode switch
	for (int i=0; i<9; i++)
		ENABLE_ITEM(IDC_D7_MODE1 + i, OnOff);

	// mode1
	ENABLE_ITEM(IDC_D7_ACCEL, mode == 1 && OnOff);

	// mode2
	ENABLE_ITEM(IDC_D7_RATE, mode == 2 && OnOff);

	// mode3
	ENABLE_ITEM(IDC_D7_INTERVAL, mode == 3 && OnOff);

	// mode4
	for (int i=0; i<4; i++)
		ENABLE_ITEM(IDC_D7_LBL1 + i, mode == 4 && OnOff);

	// mode5
	for (int i=0; i<7; i++)
		ENABLE_ITEM(IDC_D7_TIME1 + i, mode == 5 && OnOff);

	// mode6
	ENABLE_ITEM(IDC_D7_LATENCY, mode == 6 && OnOff);

	// mode7
	for (int i=0; i<4; i++)
		ENABLE_ITEM(IDC_D7_2D + i, mode == 7 && OnOff);

	// mode8
	for (int i=0; i<3; i++)
		ENABLE_ITEM(IDC_D7_RTCM + i, mode == 8 && OnOff);

	// mode9
	for (int i=0; i<6; i++)
		ENABLE_ITEM(IDC_D7_LBL4 + i, mode == 9 && OnOff);

	// buttons
	ENABLE_ITEM(IDC_D7_GET, OnOff);
	ENABLE_ITEM(IDC_D7_SET, OnOff);
}

BOOL CWindowD7::OnCommand(WPARAM wParam, LPARAM lParam)
{
	if (HIWORD(wParam) == BN_CLICKED &&
		LOWORD(wParam) >= IDC_D7_MODE1 &&
		LOWORD(wParam) <= IDC_D7_MODE9)
	{
		mode = LOWORD(wParam) - IDC_D7_MODE1 + 1;
		SwitchInterface(true);
	}

	return CWindow::OnCommand(wParam, lParam);
}

void CWindowD7::OnBnClickedD7Get()
{
	bcp->Handler[0xE7] = gotE7_D7;
	rnpi_init(0xff, mode);
	tmr_on();

	size = bcp->MakePacket(p, 0xD7, ds_get(), mode);
	sendp();

	if (mode == 2)
	{
		size = bcp->MakePacket(p, 0xD7, 0xFF, 0x02);
		sendp();
	}

	SwitchInterface(false);
}

void CWindowD7::OnBnClickedD7Set()
{
	// backup format
	char *fmtOriginal = bcp->Format[0xD7];

	// make current format
	char fmt[10] = {0};
	strcat(fmt, fmtOriginal);
	strcat(fmt, bcp->FormatD7E7[mode-1]);

	// set current format
	bcp->Format[0xD7] = fmt;

	// prepare catching response
	bcp->Handler[0xE7] = gotE7_D7;
	rnpi_init(0xff, mode);
	tmr_on();

	// make & send request
	CString s;
	BCP_VALUE v[3];

	switch (mode)
	{
	case 1:
		GetDlgItemText(IDC_D7_ACCEL, s);
		FixFloatStr(s.GetBuffer());
		v[0].f = (float)atof(s);
		if (v[0].f < 0.1)
			v[0].f = 0.1f;
		if (v[0].f > 100)
			v[0].f = 100.0f;
		s.Format("%.2f", v[0].f);
		SetDlgItemText(IDC_D7_ACCEL, s);
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x01, v[0].L);
		break;

	case 2:
		switch (SendDlgItemMessage(IDC_D7_RATE, CB_GETCURSEL, 0, 0))
		{
		case 0: v[0].C = 1; break;
		case 1: v[0].C = 2; break;
		case 2: v[0].C = 5; break;
		case 3: v[0].C = 10; break;
		}
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x02, v[0].C);
		sendp();
		size = bcp->MakePacket(p, 0xD7, 0xFF, 0x02, v[0].C);
		sendp();
		break;

	case 3:
		v[0].S = (INT16U)GetDlgItemInt(IDC_D7_INTERVAL, 0, 0);
		if (v[0].S == 0)
			v[0].S = 1;
		SetDlgItemInt(IDC_D7_INTERVAL, v[0].S, 0);
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x03, v[0].S);
		break;

	case 4:
		// category1
		v[0].C = (INT8U)GetDlgItemInt(IDC_D7_CATEGORY1, 0, 0);
		if (v[0].C < 1)
			v[0].C = 1;
		if (v[0].C > 5)
			v[0].C = 5;
		SetDlgItemInt(IDC_D7_CATEGORY1, v[0].C, 0);
		// category2
		v[1].C = (INT8U)GetDlgItemInt(IDC_D7_CATEGORY2, 0, 0);
		if (v[1].C < 1)
			v[1].C = 1;
		if (v[1].C > 12)
			v[1].C = 12;
		SetDlgItemInt(IDC_D7_CATEGORY2, v[1].C, 0);
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x04, v[0].C, v[1].C);
		break;

	case 5:
		v[0].C = (INT8U)SendDlgItemMessage(IDC_D7_TIME1, CB_GETCURSEL, 0, 0);
		v[0].C |= (INT8U)SendDlgItemMessage(IDC_D7_TIME2, CB_GETCURSEL, 0, 0) << 1;
		v[0].C |= (INT8U)SendDlgItemMessage(IDC_D7_TIME3, CB_GETCURSEL, 0, 0) << 3;
		v[0].C |= ((INT8U)SendDlgItemMessage(IDC_D7_TIME4, CB_GETCURSEL, 0, 0) + 1) << 4;
		v[1].C = IsDlgButtonChecked(IDC_D7_TIME5) ? 1 : 0;
		v[2].L = GetDlgItemInt(IDC_D7_TIME6, 0, 0);
		SetDlgItemInt(IDC_D7_TIME6, v[2].L, 0);
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x05, v[0].C, v[1].C, v[2].L);
		break;

	case 6:
		GetDlgItemText(IDC_D7_LATENCY, s);
		FixFloatStr(s.GetBuffer());
		SetDlgItemText(IDC_D7_LATENCY, s);
		v[0].d = atof(s);
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x06, v[0].d);
		break;

	case 7:
		v[0].C = IsDlgButtonChecked(IDC_D7_RAIM) ? 1 : 0;
		v[0].C |= (INT8U)SendDlgItemMessage(IDC_D7_RAIM_TYPE, CB_GETCURSEL, 0, 0) << 1;
		v[0].C |= IsDlgButtonChecked(IDC_D7_2D) ? 4 : 0;
		v[0].C |= IsDlgButtonChecked(IDC_D7_ONE) ? 8 : 0;
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x07, v[0].C);
		break;

	case 8:
		v[0].C = IsDlgButtonChecked(IDC_D7_RTCM) ? 1 : 0;
		v[0].C |= IsDlgButtonChecked(IDC_D7_SBAS) ? 2 : 0;
		v[0].C |= IsDlgButtonChecked(IDC_D7_GBAS) ? 4 : 0;
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x08, v[0].C);
		break;

	case 9:
		v[0].C = (INT8U)GetDlgItemInt(IDC_D7_COUNT1, 0, 0);
		SetDlgItemInt(IDC_D7_COUNT1, v[0].C, 0);
		v[1].C = (INT8U)GetDlgItemInt(IDC_D7_COUNT2, 0, 0);
		SetDlgItemInt(IDC_D7_COUNT2, v[1].C, 0);
		v[2].C = (INT8U)GetDlgItemInt(IDC_D7_COUNT3, 0, 0);
		SetDlgItemInt(IDC_D7_COUNT3, v[2].C, 0);
		size = bcp->MakePacket(p, 0xD7, ds_get(), 0x09, v[0].C, v[1].C, v[2].C);
		break;
	}

	// restore format
	bcp->Format[0xD7] = fmtOriginal;

	// send
	if (mode != 2)
		sendp();

	SwitchInterface(false);
}

void CWindowD7::tmr_do()
{
	bcp->Handler[0xE7] = 0;
	SwitchInterface(true);
}