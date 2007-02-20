// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowFC dialog

GRID_TOP_HEADER th_FC[] =
{
	{40, "t\xB0",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{55, "κξύττ.1",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{55, "κξύττ.2",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{55, "κξύττ.3",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{55, "ρμεω.1",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{55, "ρμεω.2",		CELL_FMT_CENTER, CELL_FMT_LEFT},
	{55, "ρμεω.3",		CELL_FMT_CENTER, CELL_FMT_LEFT}
};

IMPLEMENT_DYNAMIC(CWindowFC, CWindow)
CWindowFC::CWindowFC(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowFC::~CWindowFC()
{
	bcp->Handler[0xFE] = 0;
}

void gotFE_FC(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowFC*) (mdlg->wnd[WND_FC]) )
#define	BCP_PACKET		0xFE
#include "bcp2packet.h"

	// remove all rows
	dlg->grid.DeleteNonFixedRows();

	for (int i=0; i < _count; i++)
	{
		// new row
		dlg->grid.InsertRow(0);

		// fill values
		for (int j=0; j<7; j++)
		{
			dlg->grid.SetItemFormat(i+1, j, CELL_FMT_LEFT);
			dlg->grid.SetItemTextFmt(i+1, j, "%lu", _v(i,j));
		}
	}

	dlg->grid.Refresh();

	dlg->tmr_off();
	dlg->tmr_do();

#undef	dlg
#include "bcp2packet.h"

}

void CWindowFC::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_FC_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowFC, CWindow)
END_MESSAGE_MAP()


// CWindowFC message handlers

BOOL CWindowFC::OnInitDialog()
{
	CWindow::OnInitDialog();

	SetDlgItemText(IDC_FC_GET, TITLE_GET);

	// init grid
	grid_init(&grid, 16,0, 1,7, 1,0, false, false, th_FC, 0);

	// get info
	size = bcp->MakePacket(p, 0xFC);
	bcp->Handler[0xFE] = gotFE_FC;
	tmr_on();
	sendp();

	return TRUE;
}

void CWindowFC::tmr_do()
{
	bcp->Handler[0xFE] = 0;
}