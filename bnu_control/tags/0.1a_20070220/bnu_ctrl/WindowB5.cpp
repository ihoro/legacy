// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowB5 dialog

INI_VALUE_INFO ivi_B5[] =
{
	{"base_line", INI_TYPE_COMBOBOX, IDC_B5_BASE_LINE, 0}
};

IMPLEMENT_DYNAMIC(CWindowB5, CWindow)
CWindowB5::CWindowB5(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowB5::~CWindowB5()
{
}

void CWindowB5::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindowB5, CWindow)
	ON_BN_CLICKED(IDC_B5_RESET, OnBnClickedB5Reset)
END_MESSAGE_MAP()


// CWindowB5 message handlers

BOOL CWindowB5::OnInitDialog()
{
	// specify settings
	ini_init(1, ivi_B5);

	CWindow::OnInitDialog();

	return TRUE;
}

void CWindowB5::OnBnClickedB5Reset()
{
	INT8U b = (INT8U)SendDlgItemMessage(IDC_B5_BASE_LINE, CB_GETCURSEL, 0, 0);
	size = bcp->MakePacket(p, 0xB5, (b < 4) ? 1 << b : 0x0F);
	sendp();
}
