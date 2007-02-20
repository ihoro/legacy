// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow27 dialog

INT8U dl_27[] =
{
	0,
	0,
	0x00,
	0x10,
	0x20,
	0x40
};

IMPLEMENT_DYNAMIC(CWindow27, CWindow)
CWindow27::CWindow27(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindow27::~CWindow27()
{
	// remove request
	size = bcp->MakePacket(p, 0x27, ds_get(), 0);
	sendp();
}

void CWindow27::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindow27, CWindow)
END_MESSAGE_MAP()


// CWindow27 message handlers

BOOL CWindow27::OnInitDialog()
{
	CWindow::OnInitDialog();

	// init device selector
	ds_init(dl_27);

	// send request
	size = bcp->MakePacket(p, 0x27, ds_get(), RESPONSE_PERIOD_IN_INTERVALS);
	sendp();

	return TRUE;
}
