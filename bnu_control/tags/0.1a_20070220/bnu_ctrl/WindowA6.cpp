// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowA6 dialog

INI_VALUE_INFO ivi_A6[] =
{
	{"num", INI_TYPE_EDIT, IDC_A6_NUM, 0}
};

IMPLEMENT_DYNAMIC(CWindowA6, CWindow)
CWindowA6::CWindowA6(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowA6::~CWindowA6()
{
	bcp->Handler[0xA7] = 0;
}

void gotA7_A6(INT8U *data_ptr, INT32U data_size)
{

#define dlg				( (CWindowA6*) (mdlg->wnd[WND_A6]) )
#define	BCP_PACKET		0xA7
#include "bcp2packet.h"

	if (_rnpi == (INT8U)dlg->GetDlgItemInt(IDC_A6_NUM, 0, 0))
	{
		dlg->tmr_off();
		dlg->tmr_do();
	}
		   
#undef	dlg
#include "bcp2packet.h"

}

void CWindowA6::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindowA6, CWindow)
	ON_BN_CLICKED(IDC_A6_SET, OnBnClickedA6Set)
END_MESSAGE_MAP()


// CWindowA6 message handlers

BOOL CWindowA6::OnInitDialog()
{
	// specify settings
	ini_init(1, ivi_A6);

	CWindow::OnInitDialog();

	SetDlgItemText(IDC_A6_SET, TITLE_SET);
	SendDlgItemMessage(IDC_A6_NUM, EM_LIMITTEXT, 3, 0);

	return TRUE;
}

void CWindowA6::OnBnClickedA6Set()
{
	int i = GetDlgItemInt(IDC_A6_NUM, 0, 0);
	if (i > 255)
		i = 255;
	SetDlgItemInt(IDC_A6_NUM, i, 0);

	size = bcp->MakePacket(p, 0xA6, (INT8U)i);
	bcp->Handler[0xA7] = gotA7_A6;
	tmr_on();
	sendp();

	SwitchInterface(false);
}

void CWindowA6::SwitchInterface(bool OnOff)
{
	ENABLE_ITEM(IDC_A6_NUM, OnOff);
	ENABLE_ITEM(IDC_A6_SET, OnOff);
}

void CWindowA6::tmr_do()
{
	bcp->Handler[0xA7] = 0;
	SwitchInterface(true);
}