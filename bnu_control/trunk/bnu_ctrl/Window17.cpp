#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow17 dialog

INT8U dl_17[] =
{
	0x00,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_17[] =
{
	{20, "№",			CELL_FMT_CENTER, CELL_FMT_RIGHT},
	{60, "Система",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{40, "Л/Ном",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{35, "С/Ш",			CELL_FMT_CENTER, CELL_FMT_LEFT},
	{50, "Статус",		CELL_FMT_CENTER, CELL_FMT_CENTER},
	{65, "Призн. д.",	CELL_FMT_CENTER, CELL_FMT_CENTER}
};

INI_VALUE_INFO ivi_17[] =
{
	{"ch_num",		INI_TYPE_EDIT,		IDC_17_CH_NUM, 0},
	{"system",		INI_TYPE_COMBOBOX,	IDC_17_SYSTEM, 0},
	{"num",			INI_TYPE_EDIT,		IDC_17_NUM, 0},
	{"status",		INI_TYPE_COMBOBOX,	IDC_17_STATUS, 0},
	{"set_dopler",	INI_TYPE_CHECKBOX,	IDC_17_SET_DOPLER, 0},
	{"dopler",		INI_TYPE_EDIT,		IDC_17_DOPLER, 0}
};

IMPLEMENT_DYNAMIC(CWindow17, CWindow)
CWindow17::CWindow17(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow17::~CWindow17()
{
	bcp->Handler[0x42] = 0;
}

void got42_17(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow17*) (mdlg->wnd[WND_17]) )
#define	BCP_PACKET		0x42
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	CString s;

	// clear unused cells
	for (int i = _channels + 1; i<25; i++)
		for (int j=1; j<6; j++)
			dlg->grid.SetItemText(i, j, "");

	// show new data
	for (int i=0; i < _channels; i++)
	{
		// system
		if (_system(i) >= 1 && _system(i) <= 6)
			s.LoadString(IDS_39_SYSTEM_GPS + _system(i) - 1);
		else
			s = "?";
		dlg->grid.SetItemText(i+1, 1, s);

		// num
		int n = _ci[i].num;
		if (_system(i) == 1 || _system(i) == 4)
		{
			s = "%lu";
			n = (INT8U)_ci[i].num;
		}
		else
			s = "%d";
		dlg->grid.SetItemTextFmt(i+1, 2, s, n);
		
		// s2n_ratio
		dlg->grid.SetItemTextFmt(i+1, 3, "%d", _ci[i].s2n_ratio);

		// status
		if (_ci[i].status >= 0  &&  _ci[i].status <= 3)
			s.LoadString(IDS_39_STATUS_AUTO + _ci[i].status);			
		else
			s = "?";
		dlg->grid.SetItemText(i+1, 4, s);

		// pseudorange_flag
		if (_ci[i].pseudorange_flag >= 0  &&  _ci[i].pseudorange_flag <= 2)
			s.LoadString(IDS_39_FLAG_NORMAL + _ci[i].pseudorange_flag);			
		else
			s = "?";
		dlg->grid.SetItemText(i+1, 5, s);
	}

	dlg->grid.Refresh();

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow17::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_17_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow17, CWindow)
	ON_BN_CLICKED(IDC_17_GET, OnBnClicked17Get)
	ON_BN_CLICKED(IDC_17_SET_DOPLER, OnBnClicked17SetDopler)
	ON_BN_CLICKED(IDC_17_SET, OnBnClicked17Set)
END_MESSAGE_MAP()


// CWindow17 message handlers

BOOL CWindow17::OnInitDialog()
{
	// specify settings
	ini_init(6, ivi_17);

	// init device selector
	ds_init(dl_17);

	// init status combobox
	CString s;
	for (int i=0; i<2; i++)
	{
		s.LoadString(IDS_39_STATUS_AUTO + i);
		SendDlgItemMessage(IDC_17_STATUS, CB_ADDSTRING, 0, (LPARAM)s.GetBuffer());
	}

	// init ch_num/num edits
	SendDlgItemMessage(IDC_17_CH_NUM, EM_SETLIMITTEXT, 2, 0);
	SendDlgItemMessage(IDC_17_NUM, EM_SETLIMITTEXT, 3, 0);

	CWindow::OnInitDialog();

	// init dopler edit field
	if (IsDlgButtonChecked(IDC_17_SET_DOPLER))
		ENABLE_ITEM(IDC_17_DOPLER, true);

	SetDlgItemText(IDC_17_GET, TITLE_GET);
	SetDlgItemText(IDC_17_SET, TITLE_SET);

	// init grid
	grid_init(&grid, 16,0, 25,6, 1,1, false, false, th_17, 0);

	// left header
	for (int i=1; i<25; i++)
		grid.SetItemTextFmt(i, 0, "%d", i);
	
	// get info
	OnBnClicked17Get();

	return TRUE;
}

void CWindow17::OnBnClicked17Get()
{
	char *fmtOriginal = bcp->Format[0x17];
	bcp->Format[0x17] = "C";

	size = bcp->MakePacket(p, 0x17, ds_get());
	rnpi_init(0xff, 0);
	bcp->Handler[0x42] = got42_17;
	tmr_on();
	sendp();

	bcp->Format[0x17] = fmtOriginal;

	SwitchInterface(false);
}

void CWindow17::OnBnClicked17Set()
{
	///////////
	// get data
	///////////

	// ch_num
	int cn = GetDlgItemInt(IDC_17_CH_NUM, 0, 0);
	if ( !(cn >= 1 && cn <= 24) )
	{
		cn = 1;
		SetDlgItemInt(IDC_17_CH_NUM, cn, 0);
	}

	// num
	int s = (int)SendDlgItemMessage(IDC_17_SYSTEM, CB_GETCURSEL, 0, 0) + 1;
	int n = GetDlgItemInt(IDC_17_NUM, 0);
	if (s == 1 && n < 1) n = 1;
	if (s == 1 && n > 32) n = 32;
	if (s == 2 && n < -7) n = -7;
	if (s == 2 && n > 13) n = 13;
	if (s == 3 && n < 120) n = 120;
	if (s == 3 && n > 138) n = 138;
	SetDlgItemInt(IDC_17_NUM, n);

	// status
	int status = (int)SendDlgItemMessage(IDC_17_STATUS, CB_GETCURSEL, 0, 0);

	// dopler
	BCP_VALUE d;
	CString str;
	GetDlgItemText(IDC_17_DOPLER, str);
	FixFloatStr(str.GetBuffer());
	SetDlgItemText(IDC_17_DOPLER, str);
	d.f = (float)atof(str);

	//////////////
	// send packet
	//////////////

	tmr_on();
	bcp->Handler[0x42] = got42_17;
	rnpi_init(0xff, 0);

	char *fmtOriginal = bcp->Format[0x17];
	if (!IsDlgButtonChecked(IDC_17_SET_DOPLER))
		bcp->Format[0x17] = "CCCcC";

	size = bcp->MakePacket(p, 0x17, ds_get(), (INT8U)(cn-1), (INT8U)s, (INT8S)n, (INT8U)status, d.L);
	sendp();

	bcp->Format[0x17] = fmtOriginal;
	
	SwitchInterface(false);
}

void CWindow17::OnBnClicked17SetDopler()
{
	IsDlgButtonChecked(IDC_17_SET_DOPLER)
	?
		ENABLE_ITEM(IDC_17_DOPLER, true)
	:
		ENABLE_ITEM(IDC_17_DOPLER, false);

}

void CWindow17::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_17_GET, OnOff);
	ENABLE_ITEM(IDC_17_SET, OnOff);
}

void CWindow17::tmr_do()
{
	bcp->Handler[0x42] = 0;
	SwitchInterface(true);
}