#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowA0 dialog

GRID_TOP_HEADER th_A0[] =
{
	{110, 0, CELL_FMT_LEFT, CELL_FMT_LEFT},
	{110, 0, CELL_FMT_LEFT, CELL_FMT_LEFT}
};

#define TASK		( (CWindowA0*) (mdlg->wnd[WND_A0]) ) -> SendDlgItemMessage(IDC_A0_TASK, CB_GETCURSEL, 0, 0)
char VALUE_FMT[] = "%.3f";

IMPLEMENT_DYNAMIC(CWindowA0, CWindow)
CWindowA0::CWindowA0(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);	
}

CWindowA0::~CWindowA0()
{
}

void CWindowA0::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
	DDX_GridControl(pDX, IDC_A0_GRID, grid);
}


BEGIN_MESSAGE_MAP(CWindowA0, CWindow)
	ON_CBN_SELCHANGE(IDC_A0_TASK, OnCbnSelchangeA0Task)
END_MESSAGE_MAP()


// CWindowA0 message handlers

BOOL CWindowA0::OnInitDialog()
{
	CWindow::OnInitDialog();

	SendDlgItemMessage(IDC_A0_TIME, EM_LIMITTEXT, 3, 0);
	SendDlgItemMessage(IDC_A0_NUM, EM_LIMITTEXT, 1, 0);
	SetDlgItemText(IDC_A0_DO, TITLE_GET);

	// init grid
	grid_init(&grid, 17,0, 22,2, 0,1, true, false, th_A0, 0);

	// defaults
	for (int i=0; i<2; i++)
		for (int j=0; j<22; j++)
			value[i][j] = 0;
	SetDlgItemInt(IDC_A0_TIME, 1, 0);
	SetDlgItemInt(IDC_A0_NUM, 1, 0);

	// default task
	task = 0;
	SendDlgItemMessage(IDC_A0_TASK, CB_SETCURSEL, task, 0);
	SwitchInterface(true);

	return TRUE;
}

void CWindowA0::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_A0_TASK, OnOff);
	ENABLE_ITEM(IDC_A0_DO, OnOff);
	ENABLE_ITEM(IDC_A0_LBL_TIME, OnOff && task < 2);
	ENABLE_ITEM(IDC_A0_TIME, OnOff && task < 2);
	ENABLE_ITEM(IDC_A0_LBL_NUM, OnOff && (task == 2 || task == 3 || task == 5 || task == 6));
	ENABLE_ITEM(IDC_A0_NUM, OnOff && (task == 2 || task == 3 || task == 5 || task == 6));

	ENABLE_ITEM(IDC_A0_GRID, OnOff);

	// show/hide column #0
	if (task == 4 || task == 7)
		grid.SetColumnWidth(0, 0);
	else
		grid.SetColumnWidth(0, th_A0[0].column_width);
	
	// show/hide column #1
	if ( !(task == 3 || task == 6) )
		grid.SetColumnWidth(1, 0);
	else
		grid.SetColumnWidth(1, th_A0[0].column_width);

	grid.Refresh();
}

void CWindowA0::FixValues()
{
	CString s;

	for (int i=0; i<22; i++)
	{
		s = grid.GetItemText(i, 1);
		FixFloatStr(s.GetBuffer());
		grid.SetItemText(i, 1, s);
	}

	grid.Refresh();
}

void CWindowA0::OnCbnSelchangeA0Task()
{
	// save values if need
	CString s;
	if (task == 3 || task == 6)
	{
		FixValues();
		for (int i=0; i<22; i++)
		{
			s = grid.GetItemText(i, 1);
			value[task/3 - 1][i] = (float)atof(s);
		}
	}

	task = (char)TASK;

	// show values if need
	if (task == 3 || task == 6)
	{
		for (int i=0; i<22; i++)
			grid.SetItemTextFmt(i, 1, VALUE_FMT, value[task/3 - 1][i]);
		grid.Refresh();
	}

	SwitchInterface(true);
}

#undef	TASK