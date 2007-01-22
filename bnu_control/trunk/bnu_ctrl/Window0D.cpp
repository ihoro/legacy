#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow0D dialog

INT8U dl_0D[] =
{
	0x80,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

GRID_TOP_HEADER th_0D[] =
{
	{110, 0, 0, CELL_FMT_RIGHT},
	{82, "РНПИ1", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{82, "РНПИ2", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{82, "РНПИ3", CELL_FMT_CENTER, CELL_FMT_LEFT},
	{82, "РНПИ4", CELL_FMT_CENTER, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_0D[] =
{
	0,
	"система координат",
	"нав. система",
	"мин. угол возвыш.",
	"макс. СКО, м",
	"степ. фильтр. реш."
};

INI_VALUE_INFO ivi_0D[] =
{
	{"coords_system",	INI_TYPE_COMBOBOX,	IDC_0D_COORDS_SYSTEM, 0},
	{"system",			INI_TYPE_COMBOBOX,	IDC_0D_SYSTEM, 0},
	{"angle",			INI_TYPE_EDIT,		IDC_0D_ANGLE, 0},
	{"rms",				INI_TYPE_EDIT,		IDC_0D_CKO, 0},
	{"power",			INI_TYPE_EDIT,		IDC_0D_POWER, 0},
	{"rb",			INI_TYPE_RADIOBOX,	IDC_0D_RB1 | (IDC_0D_RB5 << 16), 0}
};


IMPLEMENT_DYNAMIC(CWindow0D, CWindow)
CWindow0D::CWindow0D(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow0D::~CWindow0D()
{
	bcp->Handler[0x51] = 0;
}

void got51_0D(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow0D*) (mdlg->wnd[WND_0D]) )
#define	BCP_PACKET		0x51
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;

	// get column
	int col = (_rnpi < 0x40) ? (_rnpi >> 4) + 1 : 4;

	// show info
	////////////

	char t[30];

	// coords_system
	if ( (_coords_system >= 0 && _coords_system <= 3) ||
		 (_coords_system >= 249 && _coords_system <= 255)
		)
	{
		if (_coords_system == 255)
			_coords_system = 4;
		if (_coords_system >= 249)
			_coords_system -= 245;
		dlg->SendDlgItemMessage(IDC_0D_COORDS_SYSTEM, CB_GETLBTEXT, _coords_system, (LPARAM)t);
		dlg->grid.SetItemText(1, col, t);
	}
	else
		dlg->grid.SetItemText(1, col, "?");

	// system
	if ( (_system >= 0 && _system <= 2) ||
		 (_system >= '\x10' && _system <= '\x12')
		)
	{
		if (_system >= '\x10')
			_system -= 13;
		dlg->SendDlgItemMessage(IDC_0D_SYSTEM, CB_GETLBTEXT, _system, (LPARAM)t);
		dlg->grid.SetItemText(2, col, t);
	}
	else
		dlg->grid.SetItemText(2, col, "?");

	// angle
	dlg->grid.SetItemTextFmt(3, col, "%d", _angle);

	// RMS
	dlg->grid.SetItemTextFmt(4, col, "%d", _RMS);

	// power
	dlg->grid.SetItemTextFmt(5, col, "%.4f", _power);

	if (dlg->rnpi_done())
	{
		dlg->tmr_off();
		dlg->tmr_do();
	}

	dlg->grid.Refresh();

#undef	dlg
#include "bcp2packet.h"

}

void CWindow0D::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_0D_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow0D, CWindow)
	ON_BN_CLICKED(IDC_0D_SET, OnBnClicked0dSet)
	ON_CBN_SETFOCUS(IDC_0D_COORDS_SYSTEM, OnCbnSetfocus0dCoordsSystem)
	ON_CBN_SETFOCUS(IDC_0D_SYSTEM, OnCbnSetfocus0dSystem)
	ON_EN_SETFOCUS(IDC_0D_ANGLE, OnEnSetfocus0dAngle)
	ON_EN_SETFOCUS(IDC_0D_CKO, OnEnSetfocus0dCko)
	ON_EN_SETFOCUS(IDC_0D_POWER, OnEnSetfocus0dPower)
END_MESSAGE_MAP()


// CWindow0D message handlers

BOOL CWindow0D::OnInitDialog()
{
	// specify settings
	ini_init(6, ivi_0D);

	// init device selector
	ds_init(dl_0D);

	SetDlgItemText(IDC_0D_SET, TITLE_SET);

	// init grid
	grid_init(&grid, 18,0, 6,5, 1,1, false, false, th_0D, lh_0D);

	// some height changes
	for (int i=1; i<6; i++)
		grid.SetRowHeight(i, 20);

	CWindow::OnInitDialog();

	// send 0Dh - get info
	size = bcp->MakePacket(p, 0x0D, ds_get(), 0x00);
	bcp->Handler[0x51] = got51_0D;
	tmr_on();
	rnpi_init(0xff, 0);
	sendp();

	SwitchInterface(false);

	return TRUE;
}

void CWindow0D::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_0D_SET, OnOff);
	for (int i=0; i<5; i++)
		ENABLE_ITEM(IDC_0D_COORDS_SYSTEM + i, OnOff);
}

void CWindow0D::OnBnClicked0dSet()
{
	char *fmtOriginal = bcp->Format[0x0D];
	int i;
	CString s;
	BCP_VALUE v[2];

	switch (GetCheckedRadioButton(IDC_0D_RB1, IDC_0D_RB5))
	{
	// coords_system
	case IDC_0D_RB1:
		bcp->Format[0x0D] = "CCC";
		i = (int)SendDlgItemMessage(IDC_0D_COORDS_SYSTEM, CB_GETCURSEL, 0, 0);
		if (i >= 4)
			i += 245;
		size = bcp->MakePacket(p, 0x0D, ds_get(), 0x01, i);
		break;

	// system
	case IDC_0D_RB2:
		bcp->Format[0x0D] = "CCC";
		i = (int)SendDlgItemMessage(IDC_0D_SYSTEM, CB_GETCURSEL, 0, 0);
		if (i >= 3)
			i += 13;
		size = bcp->MakePacket(p, 0x0D, ds_get(), 0x02, i);
		break;

	// angle & CKO
	case IDC_0D_RB3:
	case IDC_0D_RB4:
		bcp->Format[0x0D] = "CCCCS";
		// angle
		v[0].L = GetDlgItemInt(IDC_0D_ANGLE, 0, 0);
		if ( !(v[0].L >= 0 && v[0].L <= 90) )
		{
			v[0].L = 0;
			SetDlgItemInt(IDC_0D_ANGLE, v[0].L, 0);
		}
		// CKO
		v[1].L = GetDlgItemInt(IDC_0D_CKO, 0, 0);
		if (v[1].L > 0xFFFF)
		{
			v[1].L = 0xFFFF;
			SetDlgItemInt(IDC_0D_CKO, v[1].L, 0);
		}
		size = bcp->MakePacket(p, 0x0D, ds_get(), 0x03, v[0].C, 0, v[1].S);
		break;

	// power
	case IDC_0D_RB5:
		bcp->Format[0x0D] = "CCf";
		GetDlgItemText(IDC_0D_POWER, s);
		FixFloatStr(s.GetBuffer());
		SetDlgItemText(IDC_0D_POWER, s);
		v[0].f = (float)atof(s);
		size = bcp->MakePacket(p, 0x0D, ds_get(), 0x04, v[0].L);
		break;
	}

	bcp->Format[0x0D] = fmtOriginal;
	bcp->Handler[0x51] = got51_0D;
	tmr_on();
	rnpi_init(0xff, 0);
	sendp();

	SwitchInterface(false);
}

void CWindow0D::tmr_do()
{
	bcp->Handler[0x51] = 0;
	SwitchInterface(true);
}

void CWindow0D::OnCbnSetfocus0dCoordsSystem()
{
	CheckRadioButton(IDC_0D_RB1, IDC_0D_RB5, IDC_0D_RB1);
}

void CWindow0D::OnCbnSetfocus0dSystem()
{
	CheckRadioButton(IDC_0D_RB1, IDC_0D_RB5, IDC_0D_RB2);
}

void CWindow0D::OnEnSetfocus0dAngle()
{
	CheckRadioButton(IDC_0D_RB1, IDC_0D_RB5, IDC_0D_RB3);
}

void CWindow0D::OnEnSetfocus0dCko()
{
	CheckRadioButton(IDC_0D_RB1, IDC_0D_RB5, IDC_0D_RB4);
}

void CWindow0D::OnEnSetfocus0dPower()
{
	CheckRadioButton(IDC_0D_RB1, IDC_0D_RB5, IDC_0D_RB5);
}