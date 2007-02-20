// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow1B dialog

GRID_TOP_HEADER th_1B[] =
{
	{50,	0,								CELL_FMT_CENTER, CELL_FMT_RIGHT},
	{30,	"Êàí.",							CELL_FMT_CENTER, CELL_FMT_CENTER},
	{210,	"Èä. àïïàðàòóðû è âåðñèè ÏÌÎ",	CELL_FMT_CENTER, CELL_FMT_LEFT},
	{90,	"Øèôð",							CELL_FMT_CENTER, CELL_FMT_LEFT}
};

GRID_LEFT_HEADER lh_1B[] = 
{
	0,
	"ÐÍÏÈ1", 0, 0,
	"ÐÍÏÈ2", 0, 0,
	"ÐÍÏÈ3", 0, 0,
	"ÐÍÏÈ4", 0, 0,
	"ÖÏÓ", 0, 0
};

IMPLEMENT_DYNAMIC(CWindow1B, CWindow)
CWindow1B::CWindow1B(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow1B::~CWindow1B()
{
	bcp->Handler[0x70] = 0;
}

void got70_1B(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindow1B*) (mdlg->wnd[WND_1B]) )
#define	BCP_PACKET		0x70
#include "bcp2packet.h"

	if (!dlg->rnpi_add(_rnpi))
		return;
	
	// get row
	int row = 1;
	if (_rnpi != 0x00)
	{
		INT8U x = _rnpi;
		while (x != 0x08)
		{
			row += 3;
			x >>= 1;
		}
	}

	// show info
	if (_rnpi != 0x80)
		dlg->grid.SetItemTextFmt(row, 1, "%d", _channels);
	for (int i=0; i<3; i++)
	{
		// cypher
		dlg->grid.SetItemTextFmt(row + i, 3, "%lu",	_cypher(i));

		// text
		_id_str(i)[21] = 0;
		dlg->grid.SetItemText(row + i, 2, (LPCTSTR)_id_str(i));
	}

	dlg->grid.Refresh();
	
	if (dlg->rnpi_done())
	{
		dlg->tmr_off();
		dlg->tmr_do();
	}

#undef	dlg
#include "bcp2packet.h"

}

void CWindow1B::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_1B_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindow1B, CWindow)
END_MESSAGE_MAP()


// CWindow1B message handlers

BOOL CWindow1B::OnInitDialog()
{
	CWindow::OnInitDialog();

	SetDlgItemText(IDC_1B_GET, TITLE_GET);

	// init grid
	grid_init(&grid, 16,0, 16,4, 1,1, false, false, th_1B, lh_1B);

	// get info
	///////////

	tmr_on();
	bcp->Handler[0x70] = got70_1B;

	// send request
	switch (DEVICE)
	{
	case 0:
		hide_device(5);
		rnpi_init(4, 0);
		// rnpi 1
		size = bcp->MakePacket(p, 0x1B, 0x00);
		sendp();
		// rnpi 2
		size = bcp->MakePacket(p, 0x1B, 0x10);
		sendp();
		// rnpi 3
		size = bcp->MakePacket(p, 0x1B, 0x20);
		sendp();
		// rnpi 4
		size = bcp->MakePacket(p, 0x1B, 0x40);
		sendp();
		break;
	case 1:
		for (int i=1; i<5; i++)
			hide_device(i);
		rnpi_init(5, 0x80);
		// cpu
		size = bcp->MakePacket(p, 0x1B, 0x80);
		sendp();
		break;
	case 2:
	case 3:
	case 4:
	case 5:
		for (int i=1; i<6; i++)
			if (i != DEVICE-1)
				hide_device(i);
		rnpi_init(DEVICE - 2, 0);
		// rnpi X
		size = bcp->MakePacket(p, 0x1B, (DEVICE < 5) ? (DEVICE-2)<<4 : 0x40);
		sendp();
		break;
	}

	return TRUE;
}

void CWindow1B::tmr_do()
{
	bcp->Handler[0x70] = 0;
}

void CWindow1B::hide_device(int dev)
{
	for (int i=0; i<3; i++)
		grid.SetRowHeight( (dev-1)*3+1 + i, 0);
}