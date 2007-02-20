// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindow01 dialog

IMPLEMENT_DYNAMIC(CWindow01, CWindow)
CWindow01::CWindow01(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

void CWindow01::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindow01, CWindow)
	ON_BN_CLICKED(IDC_01_RESET, OnBnClicked01Reset)
END_MESSAGE_MAP()


// CWindow01 message handlers

BOOL CWindow01::OnInitDialog()
{
	CWindow::OnInitDialog();
	
	// defaults
	SendDlgItemMessage(IDC_01_CLEAR, CB_SETCURSEL, 0, 0);

	return TRUE;
}

void CWindow01::OnBnClicked01Reset()
{
	char clear = (char)SendDlgItemMessage(IDC_01_CLEAR, CB_GETCURSEL, 0, 0);
	
	// send 01h with p#6 = 0x80 + clear
	size = bcp->MakePacket(p, 0x01, 0x00, 0x01, 0x21, 0x01, 0x00, 0x80 + clear);
	sendp();

	// send 01h with p#6 = 0x70 + clear
	size = bcp->MakePacket(p, 0x01, 0x00, 0x01, 0x21, 0x01, 0x00, 0x70 + clear);
	sendp();
}