#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowB6 dialog

GRID_TOP_HEADER th_B6[] =
{
	{130,	0, CELL_FMT_RIGHT, CELL_FMT_RIGHT},
	{82,	0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_B6[] =
{
	"Длина базы №1, м",
	"Длина базы №2, м",
	"Длина базы №3, м",
	"Длина базы №4, м",
	"Длина базы №5, м",
	"Длина базы №6, м",
	"Угол преобр. курс №1",
	"Угол преобр. диф. №1",
	"Угол преобр. крен №1",
	"Угол преобр. курс №2",
	"Угол преобр. диф. №2",
	"Угол преобр. крен №2",
	"Угол преобр. курс №3",
	"Угол преобр. диф. №3",
	"Угол преобр. крен №3",
	"Угол преобр. курс №4",
	"Угол преобр. диф. №4",
	"Угол преобр. крен №4"
};

INI_VALUE_INFO ivi_B6[] =
{
	{"save",	INI_TYPE_CHECKBOX, IDC_B6_SAVE, 0},
	{"v%d",		INI_TYPE_GRID_COLUMN, 1, 0}
};

IMPLEMENT_DYNAMIC(CWindowB6, CWindow)
CWindowB6::CWindowB6(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowB6::~CWindowB6()
{
	bcp->Handler[0xB7] = 0;
}

void gotB7_B6(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowB6*) (mdlg->wnd[WND_B6]) )
#define	BCP_PACKET		0xB7
#include "bcp2packet.h"

	CString s;

	if (_response <= 1)
		s.LoadString(IDS_B6_DATA_ACCEPTED + _response);
	else
		s.LoadString(IDS_B6_WRONG_RESPONSE);

	dlg->SetDlgItemText(IDC_B6_RESPONSE, s);

	dlg->tmr_off();
	bcp->Handler[0xB7] = 0;
	dlg->SwitchInterface(true);

#undef	dlg
#include "bcp2packet.h"

}

void CWindowB6::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_B6_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowB6, CWindow)
	ON_BN_CLICKED(IDC_B6_SET, OnBnClickedB6Set)
END_MESSAGE_MAP()


// CWindowB6 message handlers

BOOL CWindowB6::OnInitDialog()
{
	// specify settings
	ivi_B6[1].grid = &grid;
	ini_init(2, ivi_B6);

	// init grid
	grid_init(&grid, 18,0, 18,2, 0,1, true, false, th_B6, lh_B6);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_B6_SET, TITLE_SET);

	return TRUE;
}

void CWindowB6::OnBnClickedB6Set()
{
	CString s;

	// fix grid's values as float
	for (int i=0; i<18; i++)
	{
		s = grid.GetItemText(i, 1);
		FixFloatStr(s.GetBuffer());
		grid.SetItemText(i, 1, s);
	}
	grid.Refresh();

	// get values
	BCP_VALUE v[18];

	for (int i=0; i<18; i++)
	{
		s = grid.GetItemText(i, 1);
		v[i].f = (float)atof(s);
	}

	// send B6h
	size = bcp->MakePacket(p, 0xB6, IsDlgButtonChecked(IDC_B6_SAVE) ? 1 : 0,
						   v[0].L, v[1].L, v[2].L, v[3].L, v[4].L, v[5].L,
						   v[6].L, v[7].L, v[8].L,
						   v[9].L, v[10].L, v[11].L,
						   v[12].L, v[13].L, v[14].L,
						   v[15].L, v[16].L, v[17].L);
	bcp->Handler[0xB7] = gotB7_B6;
	tmr_on();
	sendp();

	SetDlgItemText(IDC_B6_RESPONSE, "Ожидание ответа...");
	SwitchInterface(false);
}

void CWindowB6::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_B6_SET, OnOff);
	ENABLE_ITEM(IDC_B6_SAVE, OnOff);
}

void CWindowB6::tmr_do()
{
	bcp->Handler[0xB7] = 0;
	SetDlgItemText(IDC_B6_RESPONSE, "");
	SwitchInterface(true);
}